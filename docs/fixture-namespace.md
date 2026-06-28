# Fixture Namespace Decision

**Date:** 2026-06-28
**Bead:** `codex-hxrust-uw6p`

## Decision

Keep `fixtures/hxrust/` as the legacy codexhx generated-Rust proof namespace for now.

The path is historical: early fixtures proved Haxe-authored behavior through haxe.rust-generated Rust. The directory now contains codexhx-owned upstream Codex protocol, runtime, tool, state, and TUI parity fixtures. It is not a haxe.rust compiler fixture directory, and files such as `fixtures/hxrust/tui-smoke.v1.json` belong to this repository's Codex port harnesses.

Do not move or rename the namespace as part of ordinary parity work. A scan on 2026-06-28 found the path in 118 files and more than 500 references, so renaming it would create broad churn across harnesses, docs, tests, and source paths without improving runtime parity.

## Ownership Rules

- `fixtures/hxrust/` contains codexhx-owned deterministic fixtures that are consumed by Haxe interpreter and haxe.rust-generated Rust gates.
- `fixtures/upstream/` contains narrow copied/adapted upstream Codex oracle fixtures with source provenance.
- `fixtures/cafex/` contains later Cafex/Cafetera adapter evidence and must not define upstream-core behavior.
- haxe.rust compiler/backend fixtures belong in `../haxe.rust`, unless codexhx needs a local consumer pressure fixture. Local haxe.rust pressure fixtures in this repo must document why they are codexhx-owned and must not add Codex-specific behavior to `../haxe.rust`.

## Rename Criteria

A future rename or split is allowed only as a focused migration. It should happen when the project can afford the churn, not inside a feature slice. Acceptance for that migration should include:

- a replacement namespace plan, such as `fixtures/codexhx/` plus a smaller `fixtures/hxrust-pressure/` if compiler pressure fixtures need a local bucket;
- mechanical updates to harness, source, docs, reference, and README paths;
- generated gate validation for every migrated fixture family;
- a compatibility note for any external scripts or docs that still reference `fixtures/hxrust/`.
