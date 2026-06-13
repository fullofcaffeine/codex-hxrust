#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-active-turn-goal-steering-injection
haxe -cp src -cp test -main ThreadReadActiveTurnGoalSteeringInjectionHarness --interp
haxe hxml/thread-read-active-turn-goal-steering-injection.hxml
cargo check --manifest-path generated/thread-read-active-turn-goal-steering-injection/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-active-turn-goal-steering-injection/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-active-turn-goal-steering-injection/Cargo.toml --locked --quiet
