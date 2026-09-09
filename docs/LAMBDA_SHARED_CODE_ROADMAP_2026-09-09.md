# Scintilla Lambda Shared-Code Roadmap

**Audit date:** 2026-09-09  
**Primary Linear trackers:** DEN-3959, DEN-1095, DEN-1569, DEN-3043  
**Machine-readable companion:** [`lambda-fleet-rollout.json`](./lambda-fleet-rollout.json)

## Decision

The portable Lambda wire and artifact boundary belongs in
`scintilla-run/scintilla-lambda-pub-core`. Product and shared-service
`*-lambdas` repositories consume that boundary and remain thin runtime/provider
adapters. Product behavior belongs behind named operations in the sibling
`*-lib-core`; persistence belongs behind the sibling private `*-orm-core`.

```text
independently authored TypeSpec ─┐
                                ├─ TJSV admission ─> scintilla-lambda-pub-core
independently authored JSON Schema┘                      │
                                                        v
                                            product *-lambdas adapters
                                                        │
                                                        v
                                       sibling *-lib-core named operations
                                                        │
                                                        v
                                         sibling private *-orm-core seams
```

TypeSpec and JSON Schema Draft 2020-12 remain independent, human-maintained,
co-equal authorities. Generated JSON Schema and Contract IR are comparison,
admission, and projection evidence only; neither is a third authority.

The reviewed validator revision for this rollout is:

```text
ORESoftware/typespec-json-schema-validator
4740f1367a7906813dcd420a77d0c9ede26943fb
```

## Current evidence

[`scintilla-run/scintilla-lambda-pub-core#4`](https://github.com/scintilla-run/scintilla-lambda-pub-core/pull/4)
adds immutable TJSV admission, an explicit closed declaration mapping, an
intentional negative control, retained JSON/SARIF/Contract-IR evidence, and a
seven-language native matrix.

The first hosted run proved the repository-local verifier still passes and
exposed 66 declaration-identity findings. The reviewed mapping reduced those to
15 while preserving 325/325 differential agreements. A bounded, self-deleting
migration then promoted `LaunchArgument` into a real peer declaration, removed
duplicated inline definitions, aligned stable declaration identities, regenerated
the TypeSpec witness, reran the complete local verifier, and obtained a
zero-finding admissible TJSV result before committing the final source tree.

This is the expected fail-closed workflow: discrepancies were retained and
resolved at their source rather than ignored or relabeled as green.

The native Scintilla image proof remains linked to
[`scintilla-run/gleam-lambda-runner#20`](https://github.com/scintilla-run/gleam-lambda-runner/pull/20)
and [`ORESoftware/k8s-cluster#1454`](https://github.com/ORESoftware/k8s-cluster/pull/1454).
Those PRs remain draft until repository-restricted App credentials can be
hydrated through the trusted main-branch bootstrap. AWS currently rejects both
configured OIDC roles for the exact `ORESoftware/k8s-cluster` main identity.
No PAT or deploy-key fallback is permitted.

## Promotion sequence

A production repository is not eligible merely because its source compiles.
Promotion requires all of the following on exact immutable revisions:

1. Public-core local comparison, TJSV positive admission, TJSV mutation
   rejection, and every native SDK test pass.
2. One paired test-organization consumer verifies the public-core lock, exact
   TJSV receipt and Contract IR, live request/success/failure envelopes,
   entrypoint lifecycle, product-core boundaries, and amd64/arm64 artifacts.
3. The pilot production wave uses the same reviewed public-core release and
   passes equivalent evidence.
4. Later waves advance only through repository-specific PRs with exact source
   closure, no mutable dependency references, and no hidden private dependency.
5. A zero-step, unassigned-run, missing-credential, or infrastructure-only
   outcome is `not-yet-verified`, never green.

## Rollout waves

| Wave | Count | Repositories |
| --- | ---: | --- |
| `foundation` | 3 | `scintilla-run/scintilla-lambda-pub-core`, `ORESoftware/ores-lambdas-template`, `scintilla-run/scintilla-lambdas` |
| `canary` | 1 | `honeypot-r-us-test/hnpt-lambdas` |
| `pilot` | 5 | `athlet-o/athleto-lambdas`, `messaging-intel/msgint-lambdas`, `fiducia-cloud/fiducia-lambdas`, `zed-pkg/zed-lambdas`, `shared-auth/shared-auth-lambdas` |
| `wave-2` | 9 | `canonical-cloud/canonical-lambdas`, `cliptown/cliptown-lambdas`, `quaestor-ledger/quaestor-lambdas`, `opto-sync/opto-sync-lambdas`, `sonus-auris/sonus-auris-lambdas`, `daedalus-fab/daedalus-lambdas`, `claritas-viz/claritas-lambdas`, `benefactor-cc/benefactor-lambdas`, `3FA-app/3fa-lambdas` |
| `wave-3` | 16 | `StreemPilot/streempilot-lambdas`, `file-tunnel/ftnl-lambdas`, `agent-pontifex/agent-pontifex-lambdas`, `embedded-alerts/eal-lambdas`, `hacker-house-medellin/hhm-lambdas`, `elenkos-systems/elenkos-lambdas`, `happy-wakey/happy-wakey-lambdas`, `chapter-publishing/chptr-lambdas`, `premarital-asset-protection/pmap-lambdas`, `honeypot-r-us/hnpt-lambdas`, `ClaimGraph/claimgraph-lambdas`, `ores-chat/ores-chat-lambdas`, `hhaus-org/hhaus-lambdas`, `praxonne/praxonne-lambdas`, `ores-legal/ores-legal-lambdas`, `ores-rate-limit/ores-rl-lambdas` |
| `exception` | 5 | `ores-otel/ores-otel-lambdas`, `ores-redis-lru-cache/ores-lru-redis-lambdas`, `pal-trace/pal-trace-lambdas`, `hypesiege/hsg-lambdas`, `hypesiege/hypesiege-lambdas` |

The canary wave also requires selecting and recording the exact
`scintilla-run-test` conformance repository. The discovery baseline does not
guess that repository name.

The exception wave is blocked pending explicit intent:

- `ores-otel/ores-otel-lambdas`, `ores-redis-lru-cache/ores-lru-redis-lambdas`,
  and `pal-trace/pal-trace-lambdas` were discovered as empty repositories and
  require an intentional-state record.
- `hypesiege/hsg-lambdas` and `hypesiege/hypesiege-lambdas` both exist; their
  ownership and compatibility roles must be documented before either is used as
  the canonical consumer.

## Work items

| GitHub task | Linear | State |
| --- | --- | --- |
| [Admit scintilla-lambda-pub-core with immutable TJSV and negative controls](https://github.com/scintilla-run/.github/issues/21) | `DEN-3959` | in-progress |
| [Define lambda shared-code ownership and one-way dependency boundaries](https://github.com/scintilla-run/.github/issues/22) | `DEN-3959` | open |
| [Add exact lambda contract lock, consumer verifier, and release provenance](https://github.com/scintilla-run/.github/issues/23) | `DEN-3959` | open |
| [Certify a paired test-org lambda consumer before production rollout](https://github.com/scintilla-run/.github/issues/24) | `DEN-3959` | open |
| [Reconcile ores-lambdas-template with the shared public core](https://github.com/scintilla-run/.github/issues/25) | `DEN-3959` | open |
| [Make scintilla-lambdas consume public contracts without becoming a second authority](https://github.com/scintilla-run/.github/issues/26) | `DEN-3959` | open |
| [Extract reusable argv-safe entrypoint and lifecycle conformance](https://github.com/scintilla-run/.github/issues/27) | `DEN-3959` | open |
| [Add bounded stdio-json streaming, cancellation, and backpressure conformance](https://github.com/scintilla-run/.github/issues/28) | `DEN-1569` | open |
| [Publish one provider-adapter conformance matrix for every *-lambdas repo](https://github.com/scintilla-run/.github/issues/29) | `DEN-1095` | open |
| [Standardize reproducible multi-architecture Lambda and OCI release evidence](https://github.com/scintilla-run/.github/issues/30) | `DEN-1095` | open |
| [Inventory every *-lambdas repository and ratchet new shared-code debt](https://github.com/scintilla-run/.github/issues/31) | `DEN-3043` | open |
| [Enforce product lib-core and orm-core boundaries in every *-lambdas repo](https://github.com/scintilla-run/.github/issues/32) | `DEN-3043` | open |

## Fleet-wide invariants

Every consumer must record a versioned `lambda-contract.lock.json` that binds
the public-core repository and commit, Zed package/version, authority digests,
mapping digest, parity receipt, Contract IR, selected native binding,
generator/toolchain revisions, supported protocol/runtime/provider values, and
consumer source SHA.

The consumer verifier must reject mutable branches or tags, stale or copied
evidence, non-admissible IR, wrong native binding, unsupported protocol,
unrecorded generated artifacts, copied public-contract authorities, raw database
handles, boot-time DDL, generic database credential fallback, and customer/admin
plane crossing.

Shared runtime code includes portable envelopes, artifact metadata, provider
normalization, argv-safe launch/lifecycle behavior, telemetry vocabulary, and
language-neutral conformance fixtures. Product repositories retain handlers,
product-specific authorization and validation, named domain operations, and
deployment wiring. They do not receive Scintilla-private persistence, identity,
billing, or infrastructure policy through the public package.

## Automation boundaries

The fleet inventory and linter may discover repositories, classify evidence,
open issues, and propose PRs. It must not mass-merge product repositories,
modify secrets, create cloud resources, or treat inaccessible evidence as
success. Test-org evidence precedes production changes.

This file is a reviewed planning source. Generated fleet receipts belong in
read-only generated/evidence paths and must carry the exact source commit and
toolchain provenance.
