#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-goal-runtime-restore
haxe -cp src -cp test -main ThreadReadGoalRuntimeRestoreHarness --interp
haxe hxml/thread-read-goal-runtime-restore.hxml
cargo check --manifest-path generated/thread-read-goal-runtime-restore/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-goal-runtime-restore/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-goal-runtime-restore/Cargo.toml --locked --quiet
