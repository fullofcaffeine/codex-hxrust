#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-turn-goal-finalization
haxe -cp src -cp test -main ThreadReadTurnGoalFinalizationHarness --interp
haxe hxml/thread-read-turn-goal-finalization.hxml
cargo check --manifest-path generated/thread-read-turn-goal-finalization/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turn-goal-finalization/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turn-goal-finalization/Cargo.toml --locked --quiet
