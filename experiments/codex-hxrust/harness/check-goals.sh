#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/goals
haxe -cp src -cp test -main GoalHarness --interp
haxe hxml/goals.hxml
cargo check --manifest-path generated/goals/Cargo.toml --locked
cargo test --manifest-path generated/goals/Cargo.toml --locked
cargo run --manifest-path generated/goals/Cargo.toml --locked --quiet

echo "Goal harness passed."
