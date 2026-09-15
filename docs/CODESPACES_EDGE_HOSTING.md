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

The GitHub forwarded port remains private. Cloudflare must not use the `*.app.github.dev` forwarded-port URL as the origin.

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

## Secrets

Target the fleet SOPS + age pattern:

- GitHub Codespaces secrets contain only bootstrap material needed to decrypt the selected environment;
- `env/enc/codespaces.env.enc` may contain `CF_TUNNEL_TOKEN` and other environment values;
- `env/dec/**`, plaintext `.env` files and tunnel credentials are gitignored.

A direct `CF_TUNNEL_TOKEN` Codespaces secret is acceptable for the initial proof of concept, but should not become a separate long-lived secret-management system.

## Process lifecycle

Repositories should expose stable commands equivalent to:

```text
just codespace-edge-up
just codespace-edge-status
just codespace-edge-down
```

`codespace-edge-up` starts the preview server and `cloudflared`, waits for `/readyz`, and fails closed if required bootstrap material is unavailable. Prefer an explicit supervisor over detached background shell jobs.

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
