# Lambda Authority Merge-Protection Runbook

**Audit date:** 2026-09-09  
**Linear:** DEN-3959  
**GitHub task:** [scintilla-run/.github#34](https://github.com/scintilla-run/.github/issues/34)

## Finding

After the shared public-contract foundation and organization rollout roadmap were
merged, the effective GitHub configuration was checked directly for both
control repositories:

- `scintilla-run/scintilla-lambda-pub-core`
- `scintilla-run/.github`

For each repository, the `main` branch endpoint reported `protected: false`,
and the repository/inherited ruleset collection was empty. The successful CI
runs therefore prove the source at the reviewed commits, but GitHub does not yet
enforce those checks as mandatory merge controls.

This distinction matters because the public core holds independently authored
TypeSpec and JSON Schema Draft 2020-12 authorities, while the organization
repository holds the reviewed cross-organization rollout registry. A direct
push, force push, branch deletion, or merge that bypasses CI could invalidate
the evidence boundary without being stopped by current repository settings.

## Required effective policy

Configure repository rulesets or equivalent branch protection for `main` in
both repositories.

### `scintilla-run/scintilla-lambda-pub-core`

Require:

- pull requests for changes to `main`;
- no direct pushes, force pushes, or branch deletion;
- the current `Polyglot lambda core` workflow/check context;
- positive immutable TJSV admission;
- zero-finding receipt and admissible Contract IR assertions;
- intentional peer-authority drift rejection and non-admissible tombstone;
- retained evidence;
- TypeScript, Bun, Deno, Rust, Go, Erlang, and Gleam native lanes;
- a branch current with the protected base before merge;
- resolution of review conversations and inline threads.

The effective policy must not encode generated JSON Schema or Contract IR as a
third authority. It protects the peer-authority process; it does not change
which artifacts are authoritative.

### `scintilla-run/.github`

Require:

- pull requests for changes to `main`;
- no direct pushes, force pushes, or branch deletion;
- `baseline policy`;
- `public-privacy-boundary`;
- a branch current with the protected base before merge;
- resolution of review conversations and inline threads.

Workflow-file changes must not be able to remove or rename their own required
check without a separately reviewed ruleset transition.

## Merge and bypass policy

Normal semantic integration remains merge-based. Do not require rebases,
force-push branch rewriting, or conflict-side selection as a merge-control
shortcut.

Bypass access must be minimal and owner-controlled. An emergency bypass must
record:

- actor;
- repository and target ref;
- exact source and resulting commits;
- reason and incident/task reference;
- bypassed rules/checks;
- verification performed before and after the bypass;
- confirmation that enforcement remains active afterward.

A missing runner, zero-step job, missing credential, or infrastructure-only
failure is not success and must not satisfy a required check.

## Negative proof

After administrative configuration, capture evidence that:

1. a direct push to `main` is rejected;
2. a force push is rejected;
3. deletion of `main` is rejected;
4. a PR with a failing TJSV negative control cannot merge;
5. a PR that removes or renames a required workflow cannot merge until an
   explicitly reviewed ruleset transition is applied;
6. an unresolved review thread blocks merge;
7. a stale branch cannot merge when update-before-merge is required;
8. an unavailable or zero-step check remains blocking rather than green;
9. an approved emergency bypass is auditable and does not weaken subsequent
   enforcement.

Use disposable branches and intentionally failing fixtures. Do not mutate the
human-authored contract authorities merely to test repository administration.

## Verification receipt

Retain a machine-readable receipt with at least:

```json
{
  "schema": "scintilla.run/lambda-authority-merge-protection/v1",
  "verifiedAt": "RFC3339 timestamp",
  "policySourceCommit": "40-character commit",
  "repositories": [
    {
      "repository": "owner/name",
      "defaultBranch": "main",
      "rulesetIds": [],
      "enforcement": "active",
      "requiredChecks": [],
      "requiresPullRequest": true,
      "requiresCurrentBase": true,
      "requiresConversationResolution": true,
      "allowsForcePush": false,
      "allowsDeletion": false,
      "bypassActors": [],
      "negativeProof": []
    }
  ]
}
```

The receipt records effective GitHub administration state. It is evidence, not
an alternate source for the contract or rollout policy.

## Current known-good source evidence

### Public core

- PR: `scintilla-run/scintilla-lambda-pub-core#4`
- verified source head: `afc59d3224d7ed17cfdf3ea89fa3dccdb2c15a44`
- merge commit: `ab54c9a394f048ffbd9f10b2362c7b595c148b19`
- exact-head run: `34389876636`
- post-merge run: `34390357419`
- immutable TJSV revision:
  `4740f1367a7906813dcd420a77d0c9ede26943fb`

### Organization roadmap

- PR: `scintilla-run/.github#33`
- merge commit: `a7cbdd9a6450dc686a04c7d41296e49792b0edbf`
- post-merge baseline-policy run: `34390724644`
- post-merge public-privacy run: `34390724688`

These successful commits and runs are the starting evidence for configuring
required checks. Workflow names and check contexts must be verified against the
actual GitHub check suites during administration rather than copied blindly
from this document.

## Administration boundary

This runbook and its pull request contain no repository-setting mutation,
credential mutation, secret, cloud-resource change, or bypass grant. Applying
rulesets/branch protection is a separately authorized GitHub administration
operation. After that operation, verify effective settings through the GitHub
API and attach the receipt to #34 and DEN-3959.
