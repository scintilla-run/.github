# scintilla-run

Scintilla Run is a polyglot functions and workflow platform pursuing practical
AWS Lambda and Google Cloud Functions parity without collapsing its architecture
boundaries.

## Architecture

- **Gleam/BEAM execution plane** — invocation workers, deadlines, streaming,
  concurrency, warm capacity, retries, and runtime SLOs.
- **Rust/Postgres management plane** — authenticated APIs, durable function
  configuration, revisions, aliases, invocation records, and operator authority.
- **Versioned interfaces** — JSON Schema, OpenAPI, AsyncAPI, and WIT contracts.
- **Polyglot clients and sync** — bounded transports, native package routes,
  encrypted/offline state, and additive GitOps semantics.
- **Operator applications, MCP, infrastructure, and E2E** — separate ownership
  for UX, read-only/build-only tooling, deployment, and cross-repository proof.

See the [repository ownership map](../docs/REPOSITORY_MAP.md) and
[delivery control plane](../docs/DELIVERY_CONTROL_PLANE.md) for the complete
boundary, dependency direction, Linear/GitHub Project routing, and exact-head
merge policy.

## Working principles

- Keep changes reviewable, tested, bounded, and reversible.
- Treat security, privacy, compatibility, durability, and finite retries as
  design constraints.
- Resolve merge conflicts semantically: reconstruct both intentions, preserve
  compatible behavior, regenerate derived contracts, and document deliberate
  trade-offs.
- Prefer canonical repositories and short, stable names; deprecate duplicates
  with migration notes rather than silently deleting history.
- Keep cross-repository dependencies explicit and immutably pinned where
  reproducibility matters.
- Treat zero-step GitHub Actions conclusions as runner-admission evidence, not
  as passing or code-failure evidence.

Organization-wide contribution, security, branching, repository-boundary, and
release guidance lives in this `.github` repository.
