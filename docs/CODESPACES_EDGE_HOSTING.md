# Codespaces edge hosting

Issue: #39

## Scope

This is a development/preview hosting tier that uses a GitHub Codespace as an ephemeral origin behind Cloudflare. It is not a production availability tier.

Current pilot Codespace:

- current repository: `scintilla-run/.github`
- Codespace: `bookish-goldfish-v6v7w4vx545hxp95`
- canonical local ingress port: `8080`
- canonical long-term application infra owner: `scintilla-run/scintilla-infra`

## Request path

```text
browser
  -> Cloudflare DNS / TLS / optional Access
  -> Workers VPC / named Cloudflare Tunnel
  -> cloudflared inside the Codespace
  -> http://127.0.0.1:8080
  -> codespaces-cluster Rust edge proxy
  -> path-selected local service
```

The GitHub forwarded port remains private. Cloudflare must not use the `*.app.github.dev` forwarded-port URL as the origin. Port 8080 is marked `onAutoForward: ignore`.

## Ownership boundary

The implementation deliberately separates local service orchestration from tunnel supervision:

- `ORESoftware/codespaces-cluster` owns the shared local Codespace cluster and Rust path proxy on `127.0.0.1:8080`;
- `ORESoftware/ores-compose` owns dependency-wave startup/readiness and graceful child shutdown;
- `oresc codespace edge` owns only the detached `cloudflared` connector;
- `oresc` requires the external origin's `/readyz` to be healthy before starting the connector.

The repository-level `just codespace-edge-up/status/down` recipes delegate to the shared `codespaces-cluster` lifecycle. `up` starts the local cluster first and then the connector; `down` stops the connector first and then the local cluster. The long-term Scintilla application graph belongs in `scintilla-run/scintilla-infra` without changing this outer edge contract.

## Codespace provisioning

The current `.github` Codespace devcontainer provisions Rust, `just`, `cloudflared`, GitHub CLI, pinned `ORESoftware/ores-compose@9fbbaf4580b91c1445ec91f67ad3b31252094171`, and reviewed private `ORESoftware/ores-cli@d37aa4c1a0b79a292a31e2f16db8622144b0831f`.

Because the ORE tooling repositories are private and cross-owner, configure:

- `ORES_CLI_READ_TOKEN` — fine-grained read-only Contents access limited to `ORESoftware/ores-cli`, `ORESoftware/ores-compose`, and `ORESoftware/codespaces-cluster`, used only for bootstrap/network operations;
- `TUNNEL_TOKEN` — connector token for the pre-provisioned named Cloudflare tunnel.

The devcontainer performs a read-only `gh repo view ORESoftware/codespaces-cluster` preflight so insufficient token scope fails during rebuild. Tokens are supplied through environment-based credential handling and must not be embedded in Git URLs, argv, source, state, logs, or reports. Rebuild the Codespace after devcontainer changes.

The pinned `oresc` revision removes `ORES_CLI_READ_TOKEN`, `GH_TOKEN`, `GITHUB_TOKEN`, `TUNNEL_TOKEN`, and `CF_TUNNEL_TOKEN` from its generic child command environments before the version preflight, detached supervisor, and connector spawn, then selectively re-adds only the canonical tunnel token and ownership marker where required. The shared controller revision likewise strips bootstrap/tunnel credentials before `ores-compose` preflight/spawn so they cannot reach the application process tree.

## Lifecycle commands

```text
just codespace-edge-check
just codespace-edge-up
just codespace-edge-status
just codespace-edge-down
```

The org-control wrapper records the reviewed shared cluster revision in `config/codespaces-cluster.rev`. `up` clones only when needed, fetches only when the exact pinned object is absent, checks out that commit detached, proves `HEAD` equals the pin, and then delegates to the shared lifecycle. It never executes moving `main`. `status` and `down` intentionally do not fetch, switch branches, or mutate that shared checkout while it may own running processes.

The currently reviewed shared revision is `ORESoftware/codespaces-cluster@8c494f4b038a766be06ff29df5a067b6d78c9134`. In addition to controller-side secret stripping, it bootstraps fallback `oresc` from the same reviewed `d37aa4c1...` revision, pins its own GitHub Actions dependencies to immutable commit SHAs, and disables checkout credential persistence.

## Tunnel contract

Use one remotely managed named tunnel per Codespace origin. Quick Tunnels are not the target architecture. Stable service identity belongs to Cloudflare DNS. Workers VPC requires `cloudflared` 2025.7.0 or newer and QUIC-capable outbound connectivity; the reviewed `oresc` connector enforces that minimum and uses QUIC. Protect administrative/diagnostic routes with Cloudflare Access and apply WAF/rate limiting where appropriate.

## GitHub Project contract

Track the fleet in a Project named `Codespaces Edge Hosting` with fields: Status, Origin org, Origin repo, Codespace name, Public hostname, Tunnel health, Codespace state, Last verified, and Risk. Recommended views are `By org`, `Tunnel health`, `Blocked`, and `Recently verified`.

## Exit path

A stopped or deleted Codespace is an expected outage for this tier. Workloads needing durable public availability must graduate to Cloudflare-native hosting or the normal multi-cloud deployment path while keeping the same public hostname and health contract where practical.
