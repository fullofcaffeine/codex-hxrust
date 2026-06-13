#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-turn-error-active-goal-stop
haxe -cp src -cp test -main ThreadReadTurnErrorActiveGoalStopHarness --interp
haxe hxml/thread-read-turn-error-active-goal-stop.hxml
cargo check --manifest-path generated/thread-read-turn-error-active-goal-stop/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turn-error-active-goal-stop/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turn-error-active-goal-stop/Cargo.toml --locked --quiet
