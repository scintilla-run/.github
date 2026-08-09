# scintilla-run organization handbook

> Shared operating defaults for repositories maintained under **scintilla-run**. Repository-local policy may strengthen these rules but should not silently weaken them.

## Mission

scintilla-run maintains runtime, execution, orchestration, and automation tooling. This `.github` repository is the canonical home for shared policy, reusable templates, community health files, and planning links.

## Repository contract

Each active repository must document purpose, ownership, maturity, supported environments, development and test commands, authoritative interfaces and configuration, release and rollback procedures, compatibility policy, and GitHub Project/Linear links. Runtime components should also document process and task lifecycle, concurrency, cancellation, timeouts, retries, resource limits, isolation, persistence, observability, and crash recovery.

## Change workflow

1. Anchor work in an issue, Linear item, or documented maintenance objective.
2. Keep branches and pull requests focused.
3. Explain motivation, scope, reliability and compatibility risk, validation, migration, and rollback.
4. Test startup, shutdown, cancellation, timeout, retry, overload, crash, restart, and partial-failure paths as relevant.
5. Resolve conflicts semantically by reconstructing both sides' intent.
6. Prefer squash merges for focused work unless commit structure materially improves auditability.

## Evidence, security, and documentation

Pull requests should include reproducible commands, deterministic fixtures, expected and observed results, negative-path and stress evidence, documentation updates, and CI or local-equivalent evidence. Never commit credentials, production payloads, signing material, or sensitive logs. Follow `SECURITY.md` for private reporting. Keep lifecycle and concurrency invariants explicit, examples executable, compatibility matrices current, and important architectural and operational decisions recorded.

## Planning ownership

GitHub owns code, reviews, checks, releases, and delivery evidence. Linear owns priority, dependencies, sequencing, and cross-project planning. The organization GitHub Project is the cross-repository execution view; see `PROJECTS.md` for routing details.

## Organization health

- [ ] Profiles, descriptions, topics, and READMEs are current.
- [ ] Community health files and reusable issue/PR guidance are present.
- [ ] Lifecycle, cancellation, concurrency, persistence, limits, and recovery are documented.
- [ ] Required checks cover failure, stress, compatibility, security, and supply-chain risk.
- [ ] Stale repositories are archived or clearly marked.
- [ ] GitHub Project and Linear links resolve and reflect completed work.
