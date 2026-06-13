#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-goal-steering
haxe -cp src -cp test -main ThreadReadGoalSteeringHarness --interp
haxe hxml/thread-read-goal-steering.hxml
cargo check --manifest-path generated/thread-read-goal-steering/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-goal-steering/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-goal-steering/Cargo.toml --locked --quiet

echo "Thread read goal steering harness passed."
