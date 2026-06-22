# Agent Instructions

This project uses **bd** (beads) for issue tracking. Run `bd onboard` to get started.

## Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --status in_progress  # Claim work
bd close <id>         # Complete work
bd bootstrap --yes    # Hydrate local runtime state from tracked JSONL if needed
git diff .beads/issues.jsonl  # Review tracked issue changes
```

This repo uses Beads in JSONL-only mode. `.beads/issues.jsonl` is the source of truth and must be committed and pushed like normal project code. On a fresh clone or when local Beads runtime state is missing, run `bd bootstrap --yes` to hydrate from tracked JSONL. Do not run or require `bd sync` in this repo; this installed `bd` does not expose that command, and Git already carries the tracked JSONL ledger.

## haxe.rust Upstream Improvement Rule

The `../haxe.rust` checkout is part of the work surface for this project. Do **not** copy, move, vendor, or submodule it into this repo by default; keep it as a sibling compiler repository and record the known-good consumer commit in `reference/haxe-rust.pin.json`.

Local codex-hxrust builds use the live sibling checkout through `haxe_libraries/reflaxe.rust.hxml`, which adds `../haxe.rust/src` and `../haxe.rust/std` to the Haxe classpath. That means edits in `../haxe.rust` are reflected immediately in this repo's Haxe/haxe.rust gates. The pin does not select files for local scoped builds; it records the committed known-good compiler revision for reproducibility.

haxe.rust CI health is a hard prerequisite for codex-hxrust feature work. Before continuing Codex port implementation after any reported or suspected haxe.rust CI failure, stop codex-hxrust feature work, inspect the failing haxe.rust CI run, fix haxe.rust in `../haxe.rust`, commit and push that fix there, and verify haxe.rust CI is passing or has an explicitly documented equivalent green validation. Do not keep stacking codex-hxrust gates on top of a known-broken compiler backend.

Work directly in `../haxe.rust` when fixing compiler/runtime limitations. Before making any change there, read `../haxe.rust/AGENTS.md` in full and follow that repository's current instructions, including its test expectations, commit-message conventions, push/landing rules, and any local branch or release discipline. Do not assume codex-hxrust conventions apply inside haxe.rust unless that repo's instructions say so.

`bd` issue tracking is repository-local. This repository uses JSONL-only Beads (`.beads/config.yaml` sets `no-db: true`, `no-daemon: true`, `no-auto-flush: true`, and `auto-start-daemon: false`), so `.beads/issues.jsonl` is the authoritative issue ledger and Git is the sync mechanism. If haxe.rust has an active `.beads` setup and its `AGENTS.md` asks for Beads, run `bd` from `../haxe.rust` when claiming or closing haxe.rust work and follow that repo's local Beads mode. Do not run this repo's `bd` and assume it scopes into haxe.rust. If haxe.rust Beads are unavailable, unclear, or not useful for the current compiler pressure note, track the follow-up from codex-hxrust Beads/docs instead and keep the haxe.rust source change itself governed by haxe.rust's local instructions.

The compiler must remain a general Haxe-to-Rust backend: never add Codex-specific code, fixtures, paths, naming, or assumptions to haxe.rust. Codex-specific pressure fixtures belong in this repo; haxe.rust fixes need generic minimal repros and generic tests.

Before changing `../haxe.rust`, verify it is up to date with its remote `origin` by fetching and rebasing or otherwise reconciling remote changes without overwriting unrelated local work. After making a haxe.rust fix, commit and push it directly in that repository; do not leave compiler/runtime improvements stranded locally while codex-hxrust has already adapted to them.

When the Codex port exposes a haxe.rust limitation:

1. Reduce the limitation to the smallest Haxe/haxe.rust fixture or failing example.
2. Re-read or confirm `../haxe.rust/AGENTS.md` is current for this session, then fix or improve haxe.rust in `../haxe.rust`, respecting its Beads milestones, commit conventions, and contract-first test policy.
3. Commit and push the haxe.rust change directly in that repository.
4. Run the relevant haxe.rust validation plus this repo's generated Cargo/fixture gates.
5. Update `reference/haxe-rust.pin.json` only after the committed haxe.rust revision should become codex-hxrust's known-good compiler pin and the gated checks pass.
6. Commit and push the codex-hxrust pin/docs/fixture updates.
7. Record local patches, upstream gaps, and follow-up work in Beads and `reference/haxe-rust-local-patches.v1.json` or an audit note.

Do not change the pin just to try an uncommitted local haxe.rust edit. Test against the live sibling checkout first; pin only after the compiler change is landed and meant to be reproducible for the project.

Treat haxe.rust fixes as first-class compiler contributions, not one-off local hacks hidden inside `codex-hxrust`.

## External Reference Checkouts

`../codex` is the mainstream Codex reference checkout. Use it to inspect upstream directory structure, protocol schemas, runtime behavior, tests, and fixtures while keeping this port upstream-first.

The Cafex/Cafetera Codex fork lives under `../fullofcaffeine` (for example `../fullofcaffeine/deps/codex` and Cafetera module paths). Treat those paths as later adapter-parity reference material and inspiration only.

Do not edit, commit, or push changes in `../codex` or Cafex/Cafetera repositories from this project. If a fixture or schema is needed here, copy the narrow artifact into `fixtures/{upstream,cafex,hxrust}/` and record its provenance under `reference/`.

## Work Selection Priority

The project goal is a full Haxe-to-Rust Codex port, not a headless-only replacement. This includes upstream app-server protocol, runtime, tool/state systems, and the interactive TUI. Headless/core gates are early proof slices because they are deterministic and credential-free; do not describe them as the final scope.

Keep Beads ordered so mainstream/raw Codex parity work is ready before Cafex adapter expansion. Use priorities and dependencies to make `bd ready` reflect the intended sequence: upstream/raw Codex protocol, runtime, app-server, tool, and state parity slices should outrank later Cafex/Cafetera adapter tasks.

If a Cafex/Cafetera item floats to the top of the ready queue before its upstream-shaped core is strong enough, fix the queue first: reprioritize or dependency-gate the Cafex item and file/select the missing raw Codex slice. Do this as Beads hygiene, not as an ad hoc skip rule.

Cafex work is a separate later revision/adaptation layer after the 1:1 upstream Codex port is complete enough to stand on its own. Do not treat Cafex parity as part of the first-port acceptance path. Keep Cafex adapter changes under `codexhx.adapters.cafex` and related fixtures/docs, and do not let Cafex behavior leak into upstream-shaped core modules or into `../haxe.rust`.

## Public Readiness, Hooks, And Secret Scanning

Before saying this repository is ready to be public, verify the public-readiness rails are installed and passing. This repo should maintain parity with the safety posture used in `../opencodehx`: staged pre-commit gitleaks scanning, Haxe formatting, full-history secret scanning, GitHub Actions security scanning, CI format/build gates, and Dependabot.

Use `npm run hooks:install` to set `core.hooksPath` to `scripts/hooks`. The pre-commit hook must run `scripts/security/run-gitleaks.sh --staged` before formatting staged `.hx` files with `haxelib formatter`.

Use `npm run public:precommit` before public-release checks. The full gitleaks wrapper must not silently accept a result that scans zero commits when git history exists; if the local gitleaks CLI reports zero scanned commits for a non-empty history, the wrapper should fall back to scanning `git log -p --all` through `gitleaks detect --pipe` and then scan the current tree with `gitleaks dir`.

Do not flip package metadata from private/unlicensed to public/released casually. Public readiness also requires an intentional license, repository URL, README status, and audit of local paths, private references, fixtures, pins, and generated artifacts.

## Testing Strategy

Use `docs/testing-strategy.md` as the testing policy. Haxe-authored tests that run through the Haxe interpreter and haxe.rust-generated Rust are the primary codexhx proof. Upstream Codex schemas, fixtures, and tests are contract inputs and oracle evidence; adapt them into Haxe-owned fixtures or differential public-behavior harnesses rather than treating upstream Rust-internal test success as sufficient. Generated Rust must remain build output and must not be manually edited to pass tests.

## Haxe and Generated Rust Quality

Write codexhx as top-quality, well-typed Haxe that adapts upstream Codex idioms into Haxe's type system instead of copying Rust shapes mechanically. Prefer Haxe-native abstractions that preserve the Codex architecture while making illegal states harder to represent.

For the upstream Codex port, keep runtime, TUI, tool, process, persistence, async, and other performance-sensitive paths close to the native Codex Rust architecture first. Use metal/Rust-native Haxe shapes when that best preserves upstream behavior, ownership, host-boundary semantics, and performance. More portable abstractions can come later where they do not compromise correctness, generated Rust quality, or performance parity.

Performance parity with upstream handwritten Rust is a core requirement, not a nice-to-have. Haxe source should be shaped so haxe.rust can emit Rust that is as fast as, or eventually faster than, the handwritten upstream implementation through generic compiler optimization. Avoid abstractions that force avoidable allocation, cloning, dynamic dispatch, or hxrt/runtime involvement on hot paths. If the Haxe source is clear and typed but haxe.rust cannot yet lower it to efficient Rust, track or fix that as a generic haxe.rust compiler issue instead of weakening the codexhx design.

The reason for porting through Haxe is not to write Rust with different syntax. With LLM assistance, Haxe can be a more expressive authoring language for this project. Lean into Haxe features when they make the code stronger: abstracts/newtypes for domain identifiers, enum abstracts and typed enums for protocol/action spaces, GADT-style patterns where useful, functional transforms for pure state, and macros for derivation, validation, boilerplate elimination, or compile-time invariants. When upstream Rust relies on ergonomics Haxe lacks, consider whether a clear macro, typed helper, or Haxe-native abstraction can provide an equal or better authoring experience while still generating high-quality Rust.

For any Haxe-to-target compiler or framework layer used here, target compatibility is the floor, not the Haxe API design ceiling. Target-shaped Haxe APIs are fine when intentional for migration, interop, predictable lowering, performance, ownership/borrow-shaped paths, or escape hatches. For canonical codexhx APIs, prefer semantic Haxe wrappers that use types, abstracts, macros, generated refs, properties, completion, and compile-time diagnostics when they improve readability or safety without changing upstream Rust behavior or hiding target costs. Keep 1:1 Rust-shaped facades available where they help match upstream Codex or haxe.rust interop, but do not let them become accidental boilerplate as the default design style.

Avoid stringly typed code when a stronger representation is practical. Prefer concrete `typedef` schemas, classes, abstracts/newtypes, enum abstracts, typed enums, and GADT-style typed enum patterns where Haxe can express them. Use strings only at protocol, JSON, CLI, filesystem, or upstream compatibility boundaries; convert them into typed values as soon as they enter codexhx code.

Use macros when they materially improve the abstraction: deriving repetitive protocol/schema validators, keeping fixtures and DTO definitions in sync, enforcing invariants at compile time, or reducing boilerplate that would otherwise invite drift. Do not use macros for cleverness alone; macro output should remain understandable, typed, and covered by interpreter plus generated-Rust tests.

Do not hand-write long field-copy/defaulting constructor walls for record-shaped DTOs. Prefer a typed field-record plus a reusable derivation macro such as `codexhx.macros.FieldRecordConstructor`, or a small named builder/factory when defaults need domain logic. If a DTO requires dozens of scalar fields, the Haxe source should expose the schema and invariants, not a fragile assignment checklist.

Avoid long positional constructors for DTOs, outcomes, requests, policies, and other record-shaped values. As a rule of thumb, if a constructor has more than 5-7 scalar arguments or several adjacent `Bool`/`Int`/`String` values, use a typed field-record `typedef`, named factory, or small builder so call sites read with field names. Haxe does not have Rust-style named parameters, so field records are the preferred way to preserve intent, reduce argument-order bugs, and keep the Haxe source and generated Rust reviewable.

The generated Rust is a product surface. Haxe design choices should help haxe.rust emit readable, idiomatic, warning-clean, production-quality Rust with native representations and minimal hxrt/runtime involvement wherever the active semantic contract permits it. If high-quality Haxe still produces poor Rust, track and fix that as a generic haxe.rust compiler/runtime improvement rather than working around it with Codex-specific source contortions.

## haxe.rust Profile Language

Use haxe.rust's supported profile selectors precisely:

- `portable` is the Haxe-semantics-first contract and the default for DTOs, codecs, fixtures, config/profile parsing, and pure state transitions.
- `metal` is the Rust-semantics-first contract for typed native boundaries, async/process/tool wrappers, sandbox/state integration, measured hot paths, and reduced/no-HXRT runtime experiments.
- `idiomatic` is **not** a profile selector. It is an output-quality goal for both contracts: readable Rust, warning-clean code, avoidable clone/temp reduction, and native Rust representations where the active semantic contract permits them.

Use the architecture framing: portable by default, Rust-native by opt-in, metal-like performance whenever haxe.rust can prove Haxe semantics are preserved. Do not describe portable as the slow/safe lane or metal as the only "real Rust" lane.

For near-term codexhx runtime/tool boundaries, it is acceptable to choose `metal` when the slice needs Rust-native authority, stricter host-boundary semantics, or production-shaped performance now. When a slice would ideally be portable but needs metal for performance or backend maturity, track that as a generic haxe.rust convergence gap rather than encoding Codex-specific compiler behavior.

When a slice is intentionally metal, prefer Haxe APIs that are close to the Rust concepts being modeled: explicit ownership, borrow-shaped access, RAII/guard lifetimes, native handle wrappers, result/error boundaries, and low-allocation data flow. Use Haxe macros or typed helpers to make those concepts ergonomic, but keep the generated Rust shape visible, efficient, and close to what a strong handwritten Rust implementation would use.

For async runtime work, keep the Haxe-facing contract runtime-neutral. Do not expose Tokio types, Tokio task handles, or Rust async implementation details directly in codexhx app APIs. Model async work as typed Haxe abstractions such as tasks, streams, poll/next outcomes, cancellation, and backpressure; map those to Tokio only inside a Rust backend, haxe.rust metal/native facade, or generic haxe.rust runtime layer. Haxe has no native `await`, so do not make `@:await` or macro sugar the foundational contract; optional sugar may come later only if it lowers to the same typed abstraction and remains backend-neutral.

For persistent app-server/TUI state, portable Haxe may own typed metadata, codecs, fixtures, validation, and pure decisions. Production state effects such as `StateDbHandle`, `LogDbLayer`, SQLite/sqlx ownership, rollout reconciliation, live thread persistence, file locking, migrations, repair, and cross-process coordination belong behind a generic haxe.rust metal/native Rust boundary.

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
   git diff -- .beads/issues.jsonl  # should be empty after commit
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
