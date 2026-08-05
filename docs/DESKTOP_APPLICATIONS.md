# Desktop application allocation

Verified **2026-08-05**.

Scintilla Run uses the paired native desktop application standard:

- Rust: [`scintilla-run/scintilla-desktop.rs`](https://github.com/scintilla-run/scintilla-desktop.rs) — **planned**, not yet verified as a published repository.
- Flutter: [`scintilla-run/scintilla-ui.dart`](https://github.com/scintilla-run/scintilla-ui.dart) — repository exists, but **native Linux, macOS, and Windows runners and release status remain incomplete**.

[`scintilla-run/scintilla-app-rs`](https://github.com/scintilla-run/scintilla-app-rs) is an Axum/Maud web console. It is related product code, but it is not the native Rust desktop companion allocated above. Running a web UI in a desktop browser is not a native desktop artifact.

The Flutter repository records the companion and web/native distinction in [`COMPANION_DESKTOP.md`](https://github.com/scintilla-run/scintilla-ui.dart/blob/main/COMPANION_DESKTOP.md), merged through [PR #9](https://github.com/scintilla-run/scintilla-ui.dart/pull/9).

## Product boundary

Both native implementations should support semantic parity for job submission, lifecycle state, logs, retries, cancellation, replay, artifacts, credentials, notifications, and local/offline runner interaction.

The Rust and Flutter implementations remain independently buildable, testable, releasable applications. Shared schemas, clients, fixtures, sample jobs, lifecycle models, and conformance tests should be versioned deliberately. Web-console status must be reported separately.

## Feature-delivery rule

Every desktop-facing change must inspect the allocated Rust and Flutter implementations plus the web console when shared operator behavior is affected. Update every affected surface or record an explicit no-change rationale, and report native Rust, native Flutter, and web status separately.

## Project routing

- GitHub Project: [`scintilla-run-project` — Project 1](https://github.com/orgs/scintilla-run/projects/1)
- Linear project: `github.com/scintilla-run`
- Central registry: [`approved-private-registry`](private-registry://canonical/registry/desktop-applications.json)
- Portfolio rollout: [`DEN-2469`](https://linear.app/denman/issue/DEN-2469/roll-out-paired-rust-flutter-desktop-repositories-across-the-portfolio)

Repository creation, native-runner work, renames, transfers, archival, or platform-status changes must update this document, Linear, the central registry, and all affected repositories together.
