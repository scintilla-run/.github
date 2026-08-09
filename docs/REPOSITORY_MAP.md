# Scintilla Run repository map

This map defines ownership and dependency direction across the `scintilla-run`
organization. It is intentionally architectural rather than a list of every
experimental repository.

## Canonical repositories

| Repository | Responsibility | May depend on | Must not own |
| --- | --- | --- | --- |
| `.github` | Organization policy, contribution/security defaults, delivery-system routing | No product repository | Product schemas, runtime code, deployment secrets |
| `scintilla-interfaces` | JSON Schema, OpenAPI, AsyncAPI, WIT, fixtures, compatibility vocabulary | Shared contract tooling pinned immutably | Persistence, execution, operator UI |
| `scintilla-backend.rs` | Rust/Postgres management plane, authenticated APIs, transactions, durable desired state | `scintilla-interfaces`, shared Rust libraries | BEAM worker lifecycle, UI state, infrastructure ownership |
| `gleam-lambda-runner` | Gleam/BEAM execution plane, workers, streaming, deadlines, warm capacity, finite retry execution | `scintilla-interfaces`, explicitly pinned shared BEAM libraries | Management-plane source of truth, operator authorization |
| `scintilla-clients` | Public SDK transports and native package routes | `scintilla-interfaces`, shared client libraries | Canonical schema invention, server persistence |
| `scintilla-sync` | Product-specific replicated-state envelopes, allowlists, durable queues, tombstones, additive GitOps | `scintilla-interfaces`, certified sync primitives | Raw source/bundle sync, signing keys, live telemetry streams |
| `scintilla-app-rs` | Rust operator application and authenticated control-plane UX | backend and client contracts | Runtime worker ownership, infrastructure state |
| `scintilla-ui.dart` | Flutter operator console and offline UX | `scintilla-clients`, `scintilla-sync` | Backend mutation authority, embedded production credentials |
| `scintilla-mcp-server.rs` | Read-only/build-only MCP tools, bounded diagnostics, stdio lifecycle | pinned shared MCP libraries, product repositories through read-only probes | Deployment mutations, secret persistence, arbitrary shell authority |
| `scintilla-run-e2e` | Cross-repository product journeys and release certification | immutable repository/package pins | Product implementation or mutable shared state |
| `scintilla-run-infra` | Kubernetes/cloud/deployment resources and observability deployment | reviewed application artifacts and interfaces | Application library APIs, CLI/client imports |
| `scintilla-run-monorepo` | Integration checkout, Git submodule and Zed interoperability | component repositories as pinned sources | Replacing component ownership or importing infra into apps |
| `scintilla-run.github.io` | Public documentation and marketing site | published documentation/artifacts | Private operational data or credentials |

## Dependency direction

The normal dependency direction is:

```text
interfaces
   ├── backend ── operator apps
   ├── execution runner
   ├── clients ── UI
   └── sync ───── UI / E2E

shared MCP libraries ── MCP server ── read-only product probes
reviewed artifacts ──── infra
component repositories ─ monorepo integration checkout
```

Crossing this direction requires an explicit design record. In particular:

- the backend and runner may consume interfaces; interfaces never consume their
  implementations;
- clients import interfaces rather than copying operation or model definitions;
- UI repositories call authenticated management APIs; they do not become the
  source of durable function or concurrency state;
- infra deploys reviewed artifacts but is never a package dependency of apps,
  clients, CLI, MCP, or the integration monorepo;
- E2E repositories pin tested commits or package digests and do not silently
  follow mutable branches as release evidence.

## Current workstreams

### Management and contract parity

- function resource/concurrency configuration;
- immutable, content-digested revisions;
- weighted aliases with exact basis-point totals;
- synchronous and asynchronous invocation through revisions and aliases;
- invocation status and cancellation;
- event-source mapping contracts and durable CRUD;
- finite async delivery, DLQ/destination, and redrive semantics.

### Execution parity

- reserved and provisioned concurrency;
- retained worker reconciliation and safe scale-down;
- deadlines, cancellation, streaming, and backpressure;
- finite retry scheduling, poison-event isolation, and redrive;
- low-cardinality invocation SLO metrics, traces, and correlated logs.

### Durability and sync

- PostgreSQL remains authoritative for management and delivery state;
- no silent in-memory fallback after database failure;
- additive GitOps: absence is never deletion without an explicit tombstone;
- encrypted/source-redacted offline synchronization;
- deterministic replay identity, restart recovery, conflict resolution, and
  terminal-state monotonicity.

### Security and operations

- operator identity and authorization fail closed;
- no bearer, secret, source, payload, or provider response leakage;
- redirect refusal, credential-free URL validation, finite deadlines, and body
  caps before decode/display;
- stdio stdout reserved for MCP JSON-RPC frames;
- exact-head CI or truthful runner-admission evidence;
- release records include package digest, reviewed commit, and native/Zed route.

## Repository creation policy

A new repository is justified only when it has a distinct ownership boundary,
release lifecycle, or security domain. Before creation:

1. identify the owner and forbidden responsibilities;
2. record expected dependencies and consumers;
3. choose the canonical short name and license/visibility;
4. create a Linear issue and add the future repository to the organization
   project specification;
5. establish `.github` policy, pinned read-only CI, and a root Zed package when
   the repository is publishable;
6. avoid copying code that belongs in an existing shared library or interface
   repository.

Duplicate or experimental repositories are deprecated with pointers and history
preservation; they are not silently deleted or treated as parallel owners.
