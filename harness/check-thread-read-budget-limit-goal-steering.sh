#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-budget-limit-goal-steering
haxe -cp src -cp test -main ThreadReadBudgetLimitGoalSteeringHarness --interp
haxe hxml/thread-read-budget-limit-goal-steering.hxml
cargo check --manifest-path generated/thread-read-budget-limit-goal-steering/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-budget-limit-goal-steering/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-budget-limit-goal-steering/Cargo.toml --locked --quiet
