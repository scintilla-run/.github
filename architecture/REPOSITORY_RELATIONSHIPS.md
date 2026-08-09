# `scintilla-run` repository relationships

Generated from reviewed policy and the current **public** repository inventory.

- Public repositories declared: **2**
- Private repository names withheld: **12**
- Relationship edges: **3**

## Repository roles

| Repository | Role | Lifecycle |
|---|---|---|
| [`.github`](https://github.com/scintilla-run/.github) | `organization_governance` | `active` |
| [`scintilla-run.github.io`](https://github.com/scintilla-run/scintilla-run.github.io) | `site` | `active` |

## Declared edges

| From | Relationship | To | Status/basis |
|---|---|---|---|
| `organization://scintilla-run` | `coordinates_via` | `capability://fiducia-cloud/distributed-coordination` | `platform-default` / `explicit-platform-decision`: locks, leases, idempotency, elections, schedules, budgets, and task claims |
| `organization://scintilla-run` | `authenticates_via` | `capability://shared-auth/human-identity` | `platform-default` / `explicit-platform-decision`: platform human identity and session authority |
| `scintilla-run/.github` | `governs` | `scintilla-run/scintilla-run.github.io` | `inferred` / `role-convention`: organization defaults, safety, and relationship declarations |

## Composition, service, and observability contract

Git submodules compose editable source; Zed packages resolve packages/artifacts; dual-managed commits must match. Production deploys immutable image digests, not runtime source builds. Cross-service access uses APIs/SDKs/events rather than another service database. MCP uses the product API/SDK. Services emit OpenTelemetry traces, bounded metrics, and correlated structured logs.

## Privacy boundary

This public registry deliberately omits private repository names and edges; the count above makes the boundary explicit.
