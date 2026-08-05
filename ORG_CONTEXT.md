# Organization context

Organization: **scintilla-run**

## Canonical delivery systems

- GitHub organization: `scintilla-run`
- Organization policy and profile: `scintilla-run/.github`
- Linear project: [`github.com/scintilla-run`](https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244)
  - project ID: `f5da817a-9c48-48ff-abcd-c6dd21045c20`
- GitHub Project title: `scintilla-run-project`
  - preferred organization Project number: `1`
  - expected URL after verification/provisioning: `https://github.com/orgs/scintilla-run/projects/1`
- Slack channel: `#scintilla-run`

The GitHub Project title and field specification are canonical even when project
provisioning or API visibility has not yet been verified. Do not claim that the
board exists merely because its preferred URL is documented.

## Product boundary

Scintilla Run targets AWS Lambda and Google Cloud Functions parity while
preserving explicit ownership:

- Gleam/BEAM owns invocation execution and worker lifecycle.
- Rust/Postgres owns authenticated management APIs and durable desired state.
- `scintilla-interfaces` owns canonical schemas and protocol vocabulary.
- client, sync, UI, MCP, infrastructure, and E2E repositories retain the
  narrower responsibilities recorded in [`docs/REPOSITORY_MAP.md`](docs/REPOSITORY_MAP.md).

See [`docs/DELIVERY_CONTROL_PLANE.md`](docs/DELIVERY_CONTROL_PLANE.md) for the
GitHub Project field contract, Linear synchronization rules, exact-head evidence
requirements, and active delivery priorities.

Project-specific deployment environments, customer data, and secrets must be
recorded only in their owning secure systems. They never belong in this public
organization profile repository.

<!-- ore-org-baseline:begin -->
| Field | Value |
|---|---|
| GitHub owner | [`scintilla-run`](https://github.com/scintilla-run) |
| Mapping ID | `context:scintilla-run` |
| GitHub owner ID | `306201161` |
| Linear project ID | `f5da817a-9c48-48ff-abcd-c6dd21045c20` |
| Linear team ID | `eb8ab169-5afe-4b6f-9cab-3f2aa3e887dc` |
| Account type | `organization` |
| Default-community repository | [`scintilla-run/.github`](https://github.com/scintilla-run/.github) |
| Linear project | [github.com/scintilla-run](https://linear.app/denman/project/githubcomscintilla-run-6d9dd5f5e244) |
| Public repository graph | [`repository-relationships.json`](repository-relationships.json) |
| Reviewed relationship declarations | [`repository-relationships.manual.json`](repository-relationships.manual.json) |
| Baseline version | `2026-08-04` |

## Authority and synchronization

GitHub is authoritative for source code, public organization context, policy files, repository relationship declarations, and merged implementation history. Linear is the planning and delivery ledger. Material Linear changes that alter architecture, policy, or repository ownership should be represented by a GitHub issue or pull request; merged GitHub changes should be reflected in the linked Linear project.

This file is public. Do not place credentials, customer data, legal records, private operational details, security-sensitive topology, or unpublished business information here. Use the approved private project registry or another approved private system for member-only context. The public graph may identify that a private mirror exists, but it must not name private sibling repositories or reveal private-only edges.
<!-- ore-org-baseline:end -->
