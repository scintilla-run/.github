# Codespaces edge hosting

Issue: #39

## Scope

This is a development/preview hosting tier that uses a GitHub Codespace as an ephemeral origin behind Cloudflare. It is not a production availability tier.

Current Scintilla origin:

- repository: `scintilla-run/.github`
- Codespace: `bookish-goldfish-v6v7w4vx545hxp95`
- canonical local port: `8080`

## Request path

```text
browser
  -> Cloudflare DNS / TLS / optional Access
  -> remotely managed named Cloudflare Tunnel
  -> cloudflared inside the Codespace
  -> http://127.0.0.1:8080
  -> preview/status server
```

The GitHub forwarded port remains private. Cloudflare must not use the `*.app.github.dev` forwarded-port URL as the origin. The devcontainer marks port 8080 with `onAutoForward: ignore` so GitHub does not become the ingress layer.

## Origin contract

Every participating Codespace SHOULD expose:

- `GET /` — minimal landing/status surface
- `GET /healthz` — process liveness
- `GET /readyz` — readiness for traffic
- `GET /version` — repository, commit SHA and build/version metadata; no secrets

The server is stateless and binds to `127.0.0.1:8080` unless a local development tool specifically requires another bind address.

## Tunnel contract

Use one remotely managed named tunnel per Codespace origin. Quick Tunnels are not the target architecture. The stable public hostname belongs to Cloudflare DNS; a Codespace hostname is never treated as a stable service identifier.

Public application routes may be unauthenticated. Administrative, diagnostic and internal routes must be protected with Cloudflare Access. Apply WAF/rate limiting where appropriate.

## Codespace provisioning

The repository devcontainer provisions Rust, `just`, `cloudflared`, and the GitHub CLI. It installs `oresc` from the reviewed private `ORESoftware/ores-cli` commit `620cbbc3a5595cfa90b242011b5c1a859928c297` rather than a moving branch.

Because `ORESoftware/ores-cli` is private and belongs to a different GitHub owner, the Scintilla Codespace cannot rely on its source-repository token to clone it. Configure this GitHub Codespaces secret before creating or rebuilding the Codespace:

- `ORES_CLI_READ_TOKEN` — fine-grained GitHub token limited to read-only Contents access on `ORESoftware/ores-cli`.

The post-create hook supplies that token through the environment, configures the Git CLI credential helper with `gh auth setup-git`, and enables Cargo's Git CLI fetch path. The token is not embedded in a repository URL or command-line argument.

Rebuild the existing Codespace after changes to `.devcontainer/devcontainer.json`; a running container does not retroactively install new features or post-create tooling.

## Runtime secrets

Target the fleet SOPS + age pattern for application/runtime configuration:

- GitHub Codespaces secrets contain only bootstrap material needed to decrypt the selected environment where practical;
- `env/enc/codespaces.env.enc` may contain the Cloudflare tunnel connector token and other environment values;
- `env/dec/**`, plaintext `.env` files and tunnel credentials are gitignored.

For the current preview bootstrap, `TUNNEL_TOKEN` is the canonical Codespaces secret consumed by `oresc codespace edge up`; `CF_TUNNEL_TOKEN` remains a compatibility input. Neither value belongs in Git, argv, process state, or command output. `ORES_CLI_READ_TOKEN` is a separate least-privilege bootstrap credential needed only because the CLI source repository is private and cross-owner.

## Process lifecycle

The repository exposes:

```text
just codespace-edge-check
just codespace-edge-up
just codespace-edge-status
just codespace-edge-down
```

These recipes are deliberately thin wrappers around:

```text
oresc codespace edge up
oresc codespace edge status
oresc codespace edge down
```

`just codespace-edge-check` is read-only: it verifies that `cloudflared` and `oresc` are installed and accepts the stopped-runtime status code. `codespace-edge-up` starts the preview server and `cloudflared`, waits for readiness, and fails closed if required tunnel material is unavailable. `codespace-edge-down` only signals processes proven to belong to its recorded edge runtime.

The tunnel is healthy only while the Codespace is running. A stopped or deleted Codespace is an expected origin outage for this tier.

## GitHub Project contract

Track the fleet in a Project named `Codespaces Edge Hosting`.

Recommended fields:

- Status: Backlog / Ready / In progress / Blocked / Validating / Done
- Origin org
- Origin repo
- Codespace name
- Public hostname
- Tunnel health
- Codespace state
- Last verified
- Risk

Recommended views: `By org`, `Tunnel health`, `Blocked`, and `Recently verified`.

## Exit path

Any workload that needs durable public availability must graduate to Cloudflare-native hosting or the normal multi-cloud deployment path. The application contract should remain portable so moving off Codespaces does not change its public hostname or health endpoints.
