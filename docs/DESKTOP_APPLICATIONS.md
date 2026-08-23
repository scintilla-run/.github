# Desktop application allocation

Verified **2026-08-06**.

Scintilla Run uses the paired desktop application standard:

- Rust: [`scintilla-run/scintilla-desktop.rs`](https://github.com/scintilla-run/scintilla-desktop.rs) — **planned**, not yet verified as a published repository.
- Flutter, current: [`scintilla-run/scintilla-ui.dart`](https://github.com/scintilla-run/scintilla-ui.dart) — repository exists, but native Linux, macOS, and Windows runners, packaging, and release status remain incomplete.
- Flutter canonical rename target: `scintilla-run/scintilla-flutter` — planned naming normalization; do not describe as published until renamed and verified.

[`scintilla-run/scintilla-app-rs`](https://github.com/scintilla-run/scintilla-app-rs) is an Axum/Maud web console. It is related product code but is not the native Rust desktop companion.

## Why both Rust and Flutter remain active

The native Rust and Flutter apps remain first-class side-by-side implementations so the product can compare operator ergonomics, performance, offline/local-runner integration, accessibility, mobile reuse, developer velocity, packaging, and long-term maintenance with identical job-control semantics. The web console is tracked as a third, separate surface.

Every desktop-facing change must inspect both native implementations and the web console when shared behavior is affected. A one-sided change requires an explicit no-change rationale and parity gap. Browser execution is not native desktop completion.

## Rust desktop kit: Dioxus Desktop

**Selected strategy:** Dioxus Desktop.

**WebView policy:** allowed and explicitly acknowledged. The mature Dioxus Desktop renderer uses the system WebView while Rust application logic runs natively.

**Frontend policy:** Dioxus RSX and Rust components only. Do not add React, JSX, a JavaScript SPA, or a second frontend framework. Rust owns privileged runner operations, credentials, persistence, validation, event routing, and deep-link parsing.

Dioxus suits an operator console with componentized Rust state, job/event streams, forms, tables, logs, and route concepts that can align with the existing web console without falsely treating the web console as the native app.

The Rust repository must contain `docs/DESKTOP_TOOLKIT.md` covering the Dioxus major-version and renderer policy, CSP/WebView threat model, privileged Rust boundary, deep links, tests, packaging, web-console distinction, and Flutter companion.

## HTTPS-first deep linking

Canonical form:

```text
https://<verified-scintilla-owned-host>/open/<route>?<bounded-query>
```

Fallback scheme:

```text
scintilla://<route>?<bounded-query>
```

Routes belong in `scintilla-interfaces` and must be shared by native Rust, Flutter, clients, and the web console/browser fallback.

Required behavior:

- receive OS/Wry events in Rust and parse them before updating Dioxus component state;
- support cold-start and already-running/single-instance delivery;
- validate the exact host, route, job/run/artifact identifiers, action, and bounded query parameters;
- never place runner credentials, service tokens, private logs, artifact contents, or secrets in URLs;
- use short-lived, one-time, audience-bound codes for authentication and artifact handoffs;
- require confirmation for destructive retry/cancel/replay actions reached from an external link; and
- test macOS, Windows, Linux, Android, and iOS app/universal links plus browser fallback.

## Product boundary

Both native implementations should support semantic parity for job submission, lifecycle state, logs, retries, cancellation, replay, artifacts, credentials, notifications, local/offline runner interaction, and deep links.

Shared schemas, clients, route fixtures, sample jobs, lifecycle models, and conformance tests must be versioned deliberately. Native Rust, native Flutter, and web-console status must be reported separately.

## Repository-local documentation

The Flutter repository records the companion and web/native distinction in [`COMPANION_DESKTOP.md`](https://github.com/scintilla-run/scintilla-ui.dart/blob/main/COMPANION_DESKTOP.md), introduced through [PR #9](https://github.com/scintilla-run/scintilla-ui.dart/pull/9).

Central toolkit assignments: [`rust-desktop-strategies.md`](private-registry://canonical/registry/rust-desktop-strategies.md).

## Project routing

- GitHub Project: [`scintilla-run-project` — Project 1](https://github.com/orgs/scintilla-run/projects/1)
- Linear project: `github.com/scintilla-run`
- Central registry: [`approved-private-registry`](private-registry://canonical/registry/desktop-applications.json)
- Portfolio rollout: [`DEN-2469`](https://linear.app/denman/issue/DEN-2469/roll-out-paired-rust-flutter-desktop-repositories-across-the-portfolio)

Repository creation, native-runner work, Flutter renaming, toolkit/renderer changes, deep-link changes, transfers, archival, or platform-status changes must update this document, Linear, the central registry/strategy, and all affected repositories together.
