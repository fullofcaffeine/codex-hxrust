# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd sync               # Sync with git
```

## haxe.rust Upstream Improvement Rule

The `../haxe.rust` checkout is part of the work surface for this project. Do **not** copy, move, vendor, or submodule it into this repo by default; keep it as a sibling compiler repository and record the known-good consumer commit in `reference/haxe-rust.pin.json`.

Work directly in `../haxe.rust` when fixing compiler/runtime limitations. The compiler must remain a general Haxe-to-Rust backend: never add Codex-specific code, fixtures, paths, naming, or assumptions to haxe.rust. Codex-specific pressure fixtures belong in this repo; haxe.rust fixes need generic minimal repros and generic tests.

When the Codex port exposes a haxe.rust limitation:

1. Reduce the limitation to the smallest Haxe/haxe.rust fixture or failing example.
2. Fix or improve haxe.rust in `../haxe.rust`, respecting its Beads milestones, `AGENTS.md`, and contract-first test policy.
3. Commit and push the haxe.rust change directly in that repository.
4. Run the relevant haxe.rust validation plus this repo's generated Cargo/fixture gates.
5. Update `reference/haxe-rust.pin.json` only after the gated checks pass.
6. Commit and push the codex-hxrust pin/docs/fixture updates.
7. Record local patches, upstream gaps, and follow-up work in Beads and `reference/haxe-rust-local-patches.v1.json` or an audit note.

Treat haxe.rust fixes as first-class compiler contributions, not one-off local hacks hidden inside `codex-hxrust`.

## External Reference Checkouts

`../codex` is the mainstream Codex reference checkout. Use it to inspect upstream directory structure, protocol schemas, runtime behavior, tests, and fixtures while keeping this port upstream-first.

The Cafex/Cafetera Codex fork lives under `../fullofcaffeine` (for example `../fullofcaffeine/deps/codex` and Cafetera module paths). Treat those paths as later adapter-parity reference material and inspiration only.

Do not edit, commit, or push changes in `../codex` or Cafex/Cafetera repositories from this project. If a fixture or schema is needed here, copy the narrow artifact into `fixtures/{upstream,cafex,hxrust}/` and record its provenance under `reference/`.

## Work Selection Priority

Keep Beads ordered so mainstream/raw Codex parity work is ready before Cafex adapter expansion. Use priorities and dependencies to make `bd ready` reflect the intended sequence: upstream/raw Codex protocol, runtime, app-server, tool, and state parity slices should outrank later Cafex/Cafetera adapter tasks.

If a Cafex/Cafetera item floats to the top of the ready queue before its upstream-shaped core is strong enough, fix the queue first: reprioritize or dependency-gate the Cafex item and file/select the missing raw Codex slice. Do this as Beads hygiene, not as an ad hoc skip rule.

Cafex work is a compatibility layer that comes after the upstream-shaped Haxe core is strong enough for the slice being claimed. Keep Cafex adapter changes under `codexhx.adapters.cafex` and related fixtures/docs, and do not let Cafex behavior leak into upstream-shaped core modules or into `../haxe.rust`.

## haxe.rust Profile Language

Use haxe.rust's supported profile selectors precisely:

- `portable` is the Haxe-semantics-first contract and the default for DTOs, codecs, fixtures, config/profile parsing, and pure state transitions.
- `metal` is the Rust-semantics-first contract for typed native boundaries, async/process/tool wrappers, sandbox/state integration, measured hot paths, and reduced/no-HXRT runtime experiments.
- `idiomatic` is **not** a profile selector. It is an output-quality goal for both contracts: readable Rust, warning-clean code, avoidable clone/temp reduction, and native Rust representations where the active semantic contract permits them.

Use the architecture framing: portable by default, Rust-native by opt-in, metal-like performance whenever haxe.rust can prove Haxe semantics are preserved. Do not describe portable as the slow/safe lane or metal as the only "real Rust" lane.

When documenting plans, say "idiomatic portable output" or "idiomatic metal output" if needed; do not introduce `portable+idiomatic`, `idiomatic`, or `rusty` as build/profile lanes.

## Landing the Plane (Session Completion)

**When ending a work session**, you MUST complete ALL steps below. Work is NOT complete until `git push` succeeds.

**MANDATORY WORKFLOW:**

1. **File issues for remaining work** - Create issues for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **PUSH TO REMOTE** - This is MANDATORY:
   ```bash
   git pull --rebase
   bd sync
   git push
   git status  # MUST show "up to date with origin"
   ```
5. **Clean up** - Clear stashes, prune remote branches
6. **Verify** - All changes committed AND pushed
7. **Hand off** - Provide context for next session

**CRITICAL RULES:**
- Work is NOT complete until `git push` succeeds
- NEVER stop before pushing - that leaves work stranded locally
- NEVER say "ready to push when you are" - YOU must push
- If push fails, resolve and retry until it succeeds
