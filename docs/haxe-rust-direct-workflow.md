# haxe.rust Pull-Request Workflow

**Date:** 2026-08-29
**Decision:** Develop compiler changes in isolated haxe.rust worktrees and land them through pull requests.

The filename is historical. Direct work on the shared haxe.rust `main` checkout is no longer permitted.

## Why This Workflow Exists

codex-hxrust has two linked goals. It ports upstream Codex, and it proves that haxe.rust can support a production Rust application.

A compiler error must become a generic haxe.rust improvement. A consumer workaround does not prove that the compiler improved.

The old workflow used the live sibling checkout for implementation and tests. It could test compiler commit Y and record pin X.

The current sibling also contains local `main` history that is not on `origin/main`. New compiler work must not inherit or overwrite that history.

The new workflow gives each repository one clear responsibility:

- codex-hxrust records the product failure and the final acceptance tracer.
- haxe.rust owns the generic fixture, fix, review, CI, and merged commit.
- the consumer pin records only the exact merged compiler commit that passed the original tracer.

## Repository Roles

Keep haxe.rust outside this repository. Do not copy, vendor, or add it as a submodule during ordinary development.

`reference/haxe-rust.pin.json` records the known-good compiler commit. The pin does not select local compiler files.

Local builds still use the paths in `haxe_libraries/reflaxe.rust.hxml`. These paths make the shared sibling useful for quick diagnostics.

A live sibling result is not reproducible admission evidence unless its exact clean commit matches the candidate pin.

`../haxe.rust/AGENTS.md` owns compiler commands, Beads behavior, tests, commits, reviews, merges, and releases. Read it before each compiler task.

## Phase 1: Record And Classify The Failure

Record these facts in the codex-hxrust Bead:

- the exact codex-hxrust commit.
- the exact compiler commit and dirty state.
- the selected profile.
- the failing command and fixture.
- the expected and actual results.
- the upstream Codex source or test anchor.
- the production observer that the error blocks.

Then classify the error:

- Keep Codex policy and application-design errors in codex-hxrust.
- Keep real host capabilities behind typed native or metal boundaries.
- Send a reusable Haxe-to-Rust lowering or runtime error to haxe.rust.

If the error cannot use a generic fixture, stop the compiler task. Reclassify the error before implementation.

## Phase 2: Find The Existing Owner

Use the haxe.rust canonical tracker checkout for Beads operations. Do not run `bd` from a disposable worktree.

Inspect the current haxe.rust issues, pull requests, branches, worktrees, and shared-library coordination record.

If active work already owns the same behavior, contact that owner. Do not modify or supersede the active branch.

For a new blocker, create or claim one generic haxe.rust task. Use the codex-hxrust Bead only as discovery context.

## Phase 3: Create An Isolated Compiler Worktree

Fetch haxe.rust `origin` without changing the shared checkout. Create the feature worktree from fetched `origin/main`.

Use these naming shapes:

```text
branch:   fix/<haxe-rust-issue-id>-<generic-gap-slug>
worktree: ../haxe-rust-worktrees/<haxe-rust-issue-id>-<generic-gap-slug>
```

Use the worktree-creation rules in `../haxe.rust/AGENTS.md`. Its hook and Beads rules take priority over this guide.

Before the first edit:

1. Record the fetched `origin/main` commit.
2. Make sure that the feature worktree is clean.
3. Make sure that feature `HEAD` equals the recorded base commit.
4. Make sure that `origin` is the expected haxe.rust repository.
5. Make sure that the branch and path are owned by this task.

If any check fails, stop. Do not reset, clean, rebase, or remove an unknown checkout.

## Phase 4: Prove And Fix The Generic Error

Add the smallest generic failing fixture before the fix. Remove all Codex paths, names, schemas, and assumptions.

Implement the fix at the lowest correct owner:

1. Use typed compiler analysis or lowering when compile-time facts are sufficient.
2. Use a narrow typed native facade for real Rust ownership or resource limits.
3. Use haxe.rust runtime support only for runtime semantics.

Run the current focused and broader gates from `../haxe.rust/AGENTS.md`. Inspect the changed generated Rust.

Run the original codex-hxrust tracer against the feature worktree for early feedback. This result is diagnostic before merge.

Use a repository-supported compiler-root override for this cross-repository run. Do not use a symlink or edit generated Rust.

If no override exists, create that consumer support first. Do not admit a pin through the hard-coded shared path.

## Phase 5: Review And Merge haxe.rust

Commit and push only the owned feature branch. Never push the compiler fix directly to `main`.

Open a pull request against refreshed haxe.rust `main`. Include these facts:

- the haxe.rust task and blocked consumer Bead.
- the exact base commit.
- the generic failing fixture.
- the generated Rust before and after the fix.
- the focused and broader validation results.
- the original consumer error.
- the public branch owner and reviewer.
- the intentionally deferred scope.

Do not stack on an existing pull request without its current owner's approval. Stop if required review or CI is incomplete.

After merge, record the commit that landed on `origin/main`. Do not assume that the pull-request head is the merged commit.

## Phase 6: Readmit The Compiler Into codex-hxrust

Create a clean detached integration worktree at the exact merged compiler commit. Do not change the divergent shared checkout.

Make sure that the integration worktree meets these conditions:

- its status is clean.
- its `origin` is the expected repository.
- its `HEAD` equals the merged commit.
- the merged commit is reachable from fetched `origin/main`.

Run the original consumer tracer against this worktree. Then run the affected consumer gates.

Production-shaped evidence must include:

- the Haxe interpreter result.
- generated portable and metal results when both profiles apply.
- `cargo check --locked`.
- `cargo test --locked`.
- `cargo fmt --check`.
- Clippy with warnings denied.
- focused review of the changed generated modules.

Update the consumer pin in a separate codex-hxrust change. The pin candidate must equal the integration worktree `HEAD`.

Record the merged compiler pull request, compiler commit, consumer commit, profiles, commands, and evidence paths.

Consumer CI must check out the exact pin and compare its `HEAD` with the pin. A skipped generated-Rust job is not admission evidence.

## Stop Conditions

Stop the workflow for any of these conditions:

- another owner has an active task, pull request, branch, or worktree.
- the remote is unexpected.
- the fetch fails.
- the clean base has red required CI without an owned baseline task.
- no generic fixture reproduces the consumer error.
- the fixture contains Codex-specific behavior.
- the fix requires a consumer workaround.
- generated Rust adds a warning, format error, or output-quality regression.
- the compiler pull request is not merged.
- the original consumer tracer fails against the merged commit.
- the candidate pin differs from the compiler commit used by the gates.
- Beads export changes include unrelated work.

## Cleanup

Remove only clean worktrees and branches that this task owns. Wait until the compiler and consumer changes are merged.

Do not clear unknown stashes. Do not prune unknown worktrees. Do not erase local history from the shared checkout.

## Current Baseline Exception

The shared haxe.rust checkout was 67 commits ahead of fetched `origin/main` during the 2026-08-29 review.

This policy does not decide the disposition of those commits. It also does not decide the two older stacked pull requests.

Preserve those resources until their current owner records a separate decision. New work must start from fetched `origin/main` in a new worktree.

See [the cross-repository Oracle disposition](decision-records/2026-08-29-cross-repo-direction-oracle.md) for the review evidence and deferred owner decisions.
