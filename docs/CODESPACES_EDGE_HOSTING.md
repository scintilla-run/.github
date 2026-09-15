# Codespaces edge hosting

Issue: #39

## Scope

This is a development/preview hosting tier that uses a GitHub Codespace as an ephemeral origin behind Cloudflare. It is not a production availability tier.

Current pilot Codespace:

- current repository: `scintilla-run/.github`
- Codespace: `bookish-goldfish-v6v7w4vx545hxp95`
- canonical local ingress port: `8080`
- canonical long-term infra owner: `scintilla-run/scintilla-infra`

## Request path

```text
browser
  -> Cloudflare DNS / TLS / optional Access
  -> remotely managed named Cloudflare Tunnel
  -> cloudflared inside the Codespace
  -> http://127.0.0.1:8080
  -> repository-owned local application origin
```

The GitHub forwarded port remains private. Cloudflare must not use the `*.app.github.dev` forwarded-port URL as the origin. Port 8080 is marked `onAutoForward: ignore`.

## Ownership boundary

Current `oresc` revision `c854130ee147e9793a3af8736e90241630a5c934` uses the external-origin connector model:

- the repository/local orchestrator owns the application origin;
- the origin must already answer `GET /readyz` on `127.0.0.1:8080`;
- `oresc codespace edge up` then starts only the detached `cloudflared` connector;
- `oresc codespace edge down` stops only the connector and leaves the origin untouched.

Do not add a synthetic status server merely to satisfy the tunnel. The canonical `scintilla-infra` rollout uses the existing `scintilla-backend.rs` origin on 8080 and `gleam-lambda-runner` dependency on 8083 through `ores-compose`.

## Codespace provisioning

The current `.github` Codespace devcontainer provisions Rust, `just`, `cloudflared`, and GitHub CLI, and installs the exact private `ORESoftware/ores-cli` revision above. Because the CLI repository is private and cross-owner, configure:

- `ORES_CLI_READ_TOKEN` — fine-grained read-only Contents access to `ORESoftware/ores-cli`;
- `TUNNEL_TOKEN` — connector token for the pre-provisioned named Cloudflare tunnel.

Tokens are supplied through environment-based credential handling and must not be embedded in Git URLs, argv, source, state, logs, or reports. Rebuild the Codespace after devcontainer changes.

The current `.github` repository remains useful as an org-control pilot, but application-origin orchestration belongs in `scintilla-run/scintilla-infra`; new long-lived Codespaces should converge there rather than duplicating the `ores-compose` graph here.

## Lifecycle commands

This repository exposes connector wrappers:

```text
just codespace-edge-check
just codespace-edge-up
just codespace-edge-status
just codespace-edge-down
```

`codespace-edge-check` is read-only. `codespace-edge-up` fails closed until a real local origin is ready on 8080. For the canonical Scintilla flow, start the `scintilla-infra` `ores-compose` origin first, then start the connector.

## Tunnel contract

Use one remotely managed named tunnel per Codespace origin. Quick Tunnels are not the target architecture. Stable service identity belongs to Cloudflare DNS. Protect administrative/diagnostic routes with Cloudflare Access and apply WAF/rate limiting where appropriate.

## GitHub Project contract

Track the fleet in a Project named `Codespaces Edge Hosting` with fields: Status, Origin org, Origin repo, Codespace name, Public hostname, Tunnel health, Codespace state, Last verified, and Risk. Recommended views are `By org`, `Tunnel health`, `Blocked`, and `Recently verified`.

The current connector does not expose GitHub Project mutation APIs, so this document defines the contract without claiming that Project has been created.

## Exit path

A stopped or deleted Codespace is an expected outage for this tier. Workloads needing durable public availability must graduate to Cloudflare-native hosting or the normal multi-cloud deployment path while keeping the same public hostname and health contract where practical.
