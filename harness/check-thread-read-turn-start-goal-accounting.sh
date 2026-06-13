#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-turn-start-goal-accounting
haxe -cp src -cp test -main ThreadReadTurnStartGoalAccountingHarness --interp
haxe hxml/thread-read-turn-start-goal-accounting.hxml
cargo check --manifest-path generated/thread-read-turn-start-goal-accounting/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turn-start-goal-accounting/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turn-start-goal-accounting/Cargo.toml --locked --quiet
