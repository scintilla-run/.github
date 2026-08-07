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

<!-- org-project-routing:start -->
## Planning and delivery

- [GitHub Project: scintilla-run-project](https://github.com/orgs/scintilla-run/projects/1)
- [Linear planning project](https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244)
- [Detailed project-routing contract](../docs/PROJECTS.md)

GitHub owns code and delivery evidence; Linear owns planning and dependencies. The linked organization Project provides the cross-repository execution view.
<!-- org-project-routing:end -->

<!-- ore-org-baseline:begin -->
This GitHub account maintains software, infrastructure, research, and supporting documentation under the [`scintilla-run`](https://github.com/scintilla-run) GitHub owner.

Planning and delivery context is tracked in [github.com/scintilla-run](https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244). Public contribution, security, and governance defaults are maintained in [`.github`](https://github.com/scintilla-run/.github).

Repository descriptions and repository-local documentation remain authoritative for each project. Do not infer production readiness, support commitments, or security guarantees from this profile alone.
<!-- ore-org-baseline:end -->

Organization-wide contribution, security, branching, repository-boundary, and
release guidance lives in this `.github` repository.
