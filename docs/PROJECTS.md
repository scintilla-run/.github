<!-- org-project-routing:start -->
# Project routing

- **GitHub organization:** [scintilla-run](https://github.com/scintilla-run)
- **Canonical GitHub Project:** [scintilla-run-project](https://github.com/orgs/scintilla-run/projects/1) (project 1)
- **Canonical Linear project:** [planning workspace](https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244)
- **Organization documentation repository:** [scintilla-run/.github](https://github.com/scintilla-run/.github)

## Source-of-truth boundaries

GitHub is authoritative for repositories, commits, pull requests, reviews, CI checks, releases, deployable artifacts, and runtime evidence. Linear is authoritative for product planning, priorities, ownership, dependencies, milestones, and status reporting. The GitHub Project is the organization-level execution board and should contain the governance issue maintained by this repository.

## Change and merge policy

Documentation branches must be reviewed through pull requests and merged after checks pass. Concurrent edits are reconciled semantically against the latest default branch: this managed routing block is regenerated while all unrelated prose outside the block is preserved. Do not resolve conflicts by blindly choosing one side.
<!-- org-project-routing:end -->

## Execution snapshot — 2026-08-05

### Canonical SDK baseline

`scintilla-run/scintilla-clients` maintains the canonical multi-language client matrix and one repository-owned Zed release set. The current baseline includes:

- TypeScript with Node.js, Deno, Bun, and edge entrypoints;
- Go, native Rust, Rust/WASM, Dart/Flutter, Gleam, Erlang, Java, Swift, Python, Ruby, PHP, and an Android-safe Kotlin core;
- gateway-prefix preservation, redirect refusal, finite deadlines, bounded response/error bodies, token redaction, and pre-I/O input validation;
- repository-root `.zpkg.toml` and `.zpkg.lock` ownership instead of nested per-client release sets;
- deterministic build/package checks separated from time-varying advisory and committed-secret checks.

### Security gate merge

Pull request `scintilla-clients#12` merged as `b564391498d43ababb7c67a3bec2c34a6fefb15e` and added only two bounded artifacts:

1. `.github/workflows/security.yml`
   - RustSec audits for `clients/rust` and `clients/wasm`;
   - npm audit against the committed workspace dependency graph;
   - digest-pinned, redacted Gitleaks scanning;
   - read-only permissions, immutable action/image references, disabled persisted checkout credentials, and a weekly advisory run.
2. `scripts/check_zed_root_release.py`
   - requires one root `.zpkg.toml` and `.zpkg.lock`;
   - rejects nested client package metadata.

The predecessor security workflow executed and passed all five jobs. The rebuilt current-main PR jobs were rejected before runner allocation. Project reporting must preserve that distinction: a job with no steps is admission evidence, not a source or security-test result.

### Root release-layout repair

The permanent validator exposed one empty legacy file on `main`: `clients/dart/.zpkg.lock`. Pull request `scintilla-clients#19` removed it and merged as `27a7d33197132f9915e301343c30ed9cccd77184`. The canonical tree now matches the one-root release policy it enforces.

### Bounded extended client matrix

Pull request `scintilla-clients#15` merged as `72f9d4dbe130031809f1f7ec7c2e23ec2006da3f` and added:

- full Python, Ruby, PHP, and Kotlin implementations of all nine `scintilla.run/v1` operations;
- Deno, Bun, and edge runtime entrypoints sharing the portable TypeScript core;
- root-owned Zed targets and native manifests;
- immutable-pinned, read-only CI;
- a fail-closed contract/package validator;
- exact security and package documentation.

Direct exact-head evidence included the bounded validator, Python tests, Ruby tests, PHP smoke tests, TypeScript runtime metadata checks, and Kotlin source compilation plus a transport-policy corpus. Hosted jobs were rejected before checkout with `steps: null`; post-merge hosted recertification remains owned by `DEN-1573`.

The initial Elixir proposal was not merged. Its synchronous OTP `httpc` transport received the complete response before applying its result cap, so it did not provide the same streaming memory bound as the canonical tranche. A proper streaming implementation is tracked by:

- GitHub issue `scintilla-clients#20`;
- Linear `DEN-2446`.

The weaker stub-only `dev` proposal `scintilla-clients#17` was closed as superseded rather than merged.

### Active project lanes

1. **Actions admission and main recertification (`DEN-1573`).** Restore reliable runner allocation and record step-level evidence for current mainline hardening and the extended matrix.
2. **Bounded streaming Elixir client (`DEN-2446`).** Implement streaming response ceilings, native Elixir 1.18 / OTP 28 tests, and a clean Zed consumer before adding the target.
3. **Go hardening (`DEN-1544`).** Maintain lexical path validation, safe token state, and alias/description constraints without weakening cross-runtime policy.
4. **Native registry parity (`DEN-713`).** Keep native dry-runs aligned with the exact Zed-packed artifacts and fail when a declared route cannot be installed by a clean consumer.
5. **Cross-runtime parity (`DEN-1089`, completed `DEN-1101`, `DEN-1116`, and `DEN-2440`).** New work must extend the canonical matrix rather than reintroduce duplicate package roots or weaker historical transports.
6. **E2E evidence (`DEN-1569`).** Validate source redaction, isolated polyglot packages, and additive GitOps behavior outside the client repository where integration ownership belongs.

### Board hygiene

- Attach implementation PRs and exact merge commits to their Linear issues.
- Record whether a workflow actually executed before labeling the result green or red.
- Keep advisory/secret-scan signals separate from deterministic build CI.
- Rebuild stale branches on current `main` when their unique intent is still valuable; do not mechanically merge obsolete cleanup or temporary write workflows.
- Never store personal access tokens, expiring artifact URLs, broad secret allowlists, or write-capable bootstrap jobs in permanent documentation or CI.
- A release lane is complete only when repository and isolated artifacts install in clean consumers and map to one reviewed commit with checksums/provenance.
