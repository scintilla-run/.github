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

The repository-level `just codespace-edge-up/status/down` recipes delegate to the shared `codespaces-cluster` lifecycle. `up` starts the local cluster first and then the connector; `down` stops the connector first and then the local cluster. The long-term Scintilla application graph can move into `scintilla-run/scintilla-infra` without changing this outer edge contract.

## Codespace provisioning

The current `.github` Codespace devcontainer provisions Rust, `just`, `cloudflared`, and GitHub CLI, and installs reviewed private `ORESoftware/ores-cli` revision `c854130ee147e9793a3af8736e90241630a5c934`. That revision contains the connector-only `oresc` behavior required by the shared lifecycle.

Because the CLI repository is private and cross-owner, configure:

- `ORES_CLI_READ_TOKEN` — fine-grained read-only Contents access to `ORESoftware/ores-cli`;
- `TUNNEL_TOKEN` — connector token for the pre-provisioned named Cloudflare tunnel.

Tokens are supplied through environment-based credential handling and must not be embedded in Git URLs, argv, source, state, logs, or reports. Rebuild the Codespace after devcontainer changes.

## Lifecycle commands

```text
just codespace-edge-check
just codespace-edge-up
just codespace-edge-status
just codespace-edge-down
```

`codespace-edge-up` clones or fast-forwards the shared `ORESoftware/codespaces-cluster` checkout, runs its local `ores-compose`/Rust origin lifecycle, waits for `127.0.0.1:8080/readyz`, and then launches the connector. `status` and `down` intentionally do not fetch or change that shared checkout, so they inspect/stop the exact implementation that owns the running local supervisor.

## Tunnel contract

Use one remotely managed named tunnel per Codespace origin. Quick Tunnels are not the target architecture. Stable service identity belongs to Cloudflare DNS. Workers VPC requires `cloudflared` 2025.7.0 or newer and QUIC-capable outbound connectivity; the reviewed `oresc` connector enforces that minimum and uses QUIC. Protect administrative/diagnostic routes with Cloudflare Access and apply WAF/rate limiting where appropriate.

## GitHub Project contract

Track the fleet in a Project named `Codespaces Edge Hosting` with fields: Status, Origin org, Origin repo, Codespace name, Public hostname, Tunnel health, Codespace state, Last verified, and Risk. Recommended views are `By org`, `Tunnel health`, `Blocked`, and `Recently verified`.

## Exit path

A stopped or deleted Codespace is an expected outage for this tier. Workloads needing durable public availability must graduate to Cloudflare-native hosting or the normal multi-cloud deployment path while keeping the same public hostname and health contract where practical.
