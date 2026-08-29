## Purpose and change summary

Describe the problem, intended and user-visible behavior, why this repository owns
the change, affected repositories/components, compatibility impact, staged rollout,
and rollback path. Mark non-applicable checks as `N/A` with a reason.

## Review path and change control

- [ ] This work is on a non-default topic branch; this pull request is the only proposed path into the protected default branch.
- [ ] No generated tool, bot, migration runner, or deployment process writes directly to `main`, `master`, or another protected default branch.
- [ ] The change is small enough to review, or its staged rollout and follow-up pull requests are identified.
- [ ] Cross-repository dependencies are pinned by immutable commit, lockfile, or released Zed package.
- [ ] Breaking changes include compatibility, migration, rollback, and staged rollout notes.

## Scope, ownership, and public contracts

- [ ] The change is focused and does not silently cross repository ownership boundaries.
- [ ] Shared functionality is imported from its owning repository rather than copied into a new local implementation.
- [ ] Public contracts are generated from the canonical interface/schema source and consumer compatibility was checked deterministically.
- [ ] No `*-infra` repository is introduced as a Git submodule under `*-monorepo/apps`.
- [ ] Failure behavior, telemetry, and security boundaries are documented.

## SQL, persistence, and state

- [ ] No SQL changes, or every declaration has a stable organization/domain namespace and an explicit owning repository.
- [ ] Domain SQL may remain with its owning organization, but identity, ordering, checksums, drift detection, and promotion are registered through `declarative-migrations`.
- [ ] Application startup validates schema compatibility and does not apply production DDL.
- [ ] JSON Schema, generated language interfaces, ORM models, fixtures, and migration declarations were updated and checked together.
- [ ] Destructive changes, backfills, tenant isolation, RLS/authorization, idempotency, and state-machine invariants have evidence.

## Infrastructure and end-to-end coverage

- [ ] Application manifests remain app-owned; cluster composition is delegated to `oresoftware/k8s-cluster` and shared components to `oresoftware/k8s-libs-and-shared-defs`.
- [ ] Workloads use least privilege, restricted Pod Security, default-deny networking, explicit egress, non-root execution, immutable images, probes, and bounded resources where applicable.
- [ ] Destructive and cross-runtime tests run in the corresponding `*-test` organization or an isolated end-to-end environment, with teardown evidence.
- [ ] Zed lifecycle hooks cover the relevant pre-build, pre-test, and pre-publish checks without bypassing local language-native validation.

## Security and observability

- [ ] Secrets, credentials, personal data, and user content are excluded from source, logs, fixtures, build artifacts, and telemetry.
- [ ] Authentication and authorization failures are fail-closed, and sensitive operations are auditable.
- [ ] ORES OTEL trace/correlation propagation is present where applicable, with secret and user-content capture disabled by default.
- [ ] Conflicts were resolved semantically using both sides, relevant history, tests, and cross-repository contracts.
- [ ] No destructive Git recovery, history rewrite, force push, review bypass, or protected-branch bypass was used.

## Validation evidence and residual risk

- [ ] Deterministic format, lint, build, contract, schema/codegen, migration, security, unit, integration, adversarial, and end-to-end checks were run where applicable.
- [ ] Test evidence, hosted-run links, residual risks, follow-up work, and intentionally deferred repositories are listed below.

Provide exact commands, checks, fixtures, test-organization run links,
migration/drift results, and an explanation for every check that could not run.
