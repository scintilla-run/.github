# Scintilla Run delivery control plane

This document is the canonical cross-system routing guide for the `scintilla-run`
GitHub organization. Product and implementation truth remains in the owning
repository; planning truth is synchronized through the Linear project and one
organization-level GitHub Project.

## Canonical systems

| System | Canonical object | Purpose |
| --- | --- | --- |
| GitHub | `scintilla-run` | Source, reviews, releases, security boundaries, and executable evidence |
| GitHub profile/policy | `scintilla-run/.github` | Organization-wide contribution, merge, security, and project-routing policy |
| GitHub Project | `scintilla-run-project` | Portfolio view of repository issues and pull requests |
| Linear | `github.com/scintilla-run` | Product planning, cross-repository dependencies, milestones, and durable status |
| Slack | `#scintilla-run` | Operational discussion; decisions must be copied to GitHub or Linear |

The Linear project is:

`https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244`

The GitHub Project uses the organization-level title `scintilla-run-project`.
Do not create one board per repository. When the project is provisioned as
organization Project 1, its canonical URL is:

`https://github.com/orgs/scintilla-run/projects/1`

Project availability and permissions must be verified through GitHub before a
document claims that the board exists. The title and field contract below remain
the canonical creation specification if the board is absent.

## Architecture ownership

- **`scintilla-interfaces`** owns JSON Schema, OpenAPI, AsyncAPI, WIT, operation
  identifiers, and compatibility vocabulary.
- **`scintilla-backend.rs`** owns the Rust/Postgres management plane, durable
  configuration, authenticated APIs, transaction boundaries, and fail-closed
  persistence.
- **`gleam-lambda-runner`** owns the Gleam/BEAM execution plane: workers,
  deadlines, streaming, concurrency, warm capacity, retries, and runtime SLOs.
- **`scintilla-clients`** owns public SDK transports and native publication
  routes; it imports interfaces rather than redefining contracts.
- **`scintilla-sync`** owns Scintilla-specific replicated-state envelopes,
  allowlists, source redaction, tombstones, and additive GitOps reconciliation.
- **`scintilla-app-rs`** and **`scintilla-ui.dart`** own operator-facing control
  surfaces. Authentication must fail closed and mutation authority remains in
  the backend.
- **`scintilla-mcp-server.rs`** owns the read-only/build-only MCP tool surface,
  stdio lifecycle, bounded diagnostics, and product-specific runtime probes.
- **`scintilla-run-e2e`** owns cross-repository executable certification,
  restart/replay/conflict/authorization journeys, and release-gated browser
  coverage.
- **`scintilla-run-infra`** owns deployment resources only; application and CLI
  repositories must not import it as a package or monorepo submodule.
- **`scintilla-run-monorepo`** is an integration checkout and Zed/submodule
  interoperability surface, not an ownership replacement for component repos.

## GitHub Project field contract

The organization project should contain these fields:

| Field | Type | Values / rule |
| --- | --- | --- |
| Status | single select | Backlog, Ready, In progress, Review, Blocked, Done |
| Repository | single select | One value per canonical repository |
| Workstream | single select | Interfaces, Management plane, Execution plane, Clients, Sync, UI, MCP, Infra, E2E, Governance |
| Priority | single select | Urgent, High, Medium, Low |
| Linear | text | Linear issue identifier such as `DEN-1095` |
| Evidence | text | Exact reviewed head, workflow run, release, or merge commit |
| Blocked by | text | Issue/PR/incident identifier; never a vague prose-only blocker |
| Target | date | Optional delivery target; mirror the Linear milestone when set |

Recommended views:

1. **Portfolio** — grouped by Workstream, filtered to non-Done items.
2. **Pull requests** — PRs grouped by Status and Repository.
3. **Blocked** — Status=Blocked with Linear and Blocked by visible.
4. **Release evidence** — Done items with Evidence populated.
5. **Security and durability** — labels or workstreams covering auth, secrets,
   PostgreSQL durability, retries, DLQ, redaction, and MCP safety.

## Synchronization rules

1. Every substantial implementation prompt maps to exactly one authoritative
   Linear issue. Duplicates are linked and closed rather than maintained as
   parallel completion records.
2. Every implementation branch and PR references its Linear issue in the body.
3. Every GitHub Project item records the same Linear identifier.
4. Merge evidence is written back to Linear: reviewed head, meaningful test or
   workflow evidence, merge commit, and any residual infrastructure blocker.
5. GitHub Actions runs with `steps: null`, no runner ID, or no logs are recorded
   as runner-admission evidence. They are neither passing nor code-failure
   evidence.
6. A PR is merged only from an exact reviewed head. If `main` advances, compare
   the merge base and changed files. Rebuild on current `main` when overlapping
   behavior changed; do not select `ours` or `theirs` wholesale.
7. Generated contracts are regenerated from merged canonical source. Generated
   files are never line-merged independently of their source manifest/schema.
8. Security-critical fail-closed fixes may merge during a documented runner
   outage only when the diff is bounded, static review is complete, no check is
   weakened, and the recertification incident is linked.

## Current delivery priorities

The active architecture target is AWS Lambda / Google Cloud Functions parity
without erasing ownership boundaries:

1. durable function configuration, immutable revisions, weighted aliases, and
   sync/async invocation and cancellation;
2. event-source mappings and finite async delivery/redrive contracts;
3. BEAM provisioned concurrency, bounded retries, worker lifecycle, streaming,
   and invocation SLO telemetry;
4. PostgreSQL durability and restart/disconnect/conflict certification with no
   silent memory fallback;
5. source-redacted offline sync, additive GitOps, and real application/browser
   E2E coverage;
6. read-only/build-only MCP bootstrap, telemetry, URL, output, and authorization
   hardening;
7. release and package evidence across Zed and native ecosystems.

## Review checklist

Before moving an item to Done in either system:

- canonical owner and cross-repository dependencies are explicit;
- conflicts were resolved semantically using history and tests;
- auth, secrets, source code, payloads, and provider errors remain redacted;
- retries are finite, idempotency is explicit, and durable state has one owner;
- success and error bodies are bounded before decoding or display;
- exact-head evidence is recorded truthfully;
- documentation, Linear, and the organization project agree on status.
