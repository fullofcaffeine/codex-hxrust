# Cross-Repository Direction Review

**Date:** 2026-08-29
**Oracle request:** `orq_20260829T231030Z_550c61ca`
**Oracle response digest:** `63d2c7d09b2b37b017e63e04cf4e234e4d3827ad9848515407eb6400d3985789`
**Local review level:** `xhigh`

## Outcome

The project has the correct foundations, but the current work queue needs a course correction.

The port will keep these rules:

- Upstream Codex owns product behavior and module responsibility.
- Strongly typed Haxe owns product logic.
- Generated Rust remains build output and a required review surface.
- haxe.rust owns generic compiler, runtime, standard-library, and Rust-facade behavior.
- `portable` and `metal` remain the only profile selectors.

The project will stop treating each deterministic input permutation as a production milestone. Existing cases remain useful regression tests.

The next production milestone must replace a fake or missing production boundary. It must end in one observable upstream-shaped workflow.

## Evidence Reproduced Locally

The Oracle review matched the independent local conclusion. The following findings reproduce on the current checkout:

- The last 100 commits contain 87 `test:` subjects.
- The live-shell harness contains more than 4,000 lines.
- The TUI execution-history document contains more than 7,000 lines.
- `src/codexhx/runtime/tui/smoke` contains 464 Haxe files.
- `TUI-LIVE-141` adds another malformed-JSON permutation without replacing a production boundary.
- `TuiPromptTransport` and `TuiAppServerJsonRpcTransport` accept `FakeTuiAppServerFacade` directly.
- `TuiLiveShellRunRequest` stores and rebuilds that concrete fake.
- The pin updater can run gates against compiler revision Y and record candidate revision X.
- GitHub CI does not select the commit from `reference/haxe-rust.pin.json`.
- Generated Rust formatting and Clippy checks are optional.
- The open-gap reproducer gate expects an empty gap list while the pressure ledger reports open gaps.
- The haxe.rust sibling is 67 commits ahead of its fetched `origin/main`.
- The upstream Codex checkout is not a clean current-main checkout.

These checks support the review verdict. They do not establish current compiler, port, or upstream test health.

## Disposition

### Retained

1. **Pause `TUI-LIVE-141`.** A production-session task and a vertical tracer must precede this permutation.
2. **Preserve the existing regression corpus.** Convert repeated cases to data-driven fixtures when nearby work changes the same seam.
3. **Add an upstream-shaped session boundary.** The live runner, event pump, and transports must not depend on a concrete fake.
4. **Use one vertical observer.** The observer must cover protocol, session, events, state, rendering, completion or interruption, and shutdown.
5. **Make compiler work a reviewed parallel product.** Each active compiler blocker must use an isolated haxe.rust worktree and pull request.
6. **Admit one exact merged compiler commit.** The original consumer tracer must pass before the consumer pin changes.
7. **Make generated output quality mandatory.** Production-shaped gates must include formatting, warning-denying Clippy, and focused generated-module review.
8. **Refresh the upstream oracle safely.** A separate clean read-only checkout must own the next admitted Codex baseline.
9. **Move validation facts out of production APIs.** Do this around active vertical work, not through a repository-wide rewrite.
10. **Protect public attribution.** Future tracked activity must use a role or approved public handle.

### Modified

The Oracle review asked for one haxe.rust issue and reproducer for every open compiler gap. The local record is stale and internally inconsistent.

The immediate rule applies to an active compiler blocker. Before work starts, it must have one generic owner issue and one failing fixture.

A separate audit will classify the other recorded gaps. It will close stale gaps or map confirmed gaps without creating speculative compiler work.

The Oracle response also supplied detailed haxe.rust commands. This repository will record only consumer-specific rules.

The current `../haxe.rust/AGENTS.md` remains the authority for compiler commands, tests, Beads operations, commits, pull requests, and merge steps.

### Deferred

- Repair or publication of the 67 local haxe.rust `main` commits needs a separate owner decision.
- The two older stacked haxe.rust pull requests retain their current ownership until a public handoff occurs.
- The haxe.rust owner must identify the canonical checkout for Beads writes.
- Required private-compiler access in public consumer CI needs a separate implementation decision.
- Historical public-attribution migration needs explicit owner approval.
- The exact upstream Codex commit and first public test anchor require a clean current-main review.

### Rejected

No major architectural finding was rejected. The review did not justify a full rewrite or a file-by-file mechanical port.

## Required Work Order

1. Define and enforce exact compiler and upstream revision selection.
2. Replace direct haxe.rust work with the worktree and pull-request policy.
3. Consolidate the production app-server session seam.
4. Deliver one upstream-shaped vertical observer.
5. Resume feature work by upstream workflow, not by input permutation.

Small edge-case tests can continue. They do not become roadmap milestones unless they complete a production boundary.

## Review Limits

Oracle received the full consumer repository and selected compiler and upstream sources. It did not run local or remote tests.

Local reconciliation reproduced the critical source, workflow, pin, CI, and queue findings. Later implementation tasks must run their own focused gates.
