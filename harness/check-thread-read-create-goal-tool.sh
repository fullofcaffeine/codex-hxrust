#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-create-goal-tool
haxe -cp src -cp test -main ThreadReadCreateGoalToolHarness --interp
haxe hxml/thread-read-create-goal-tool.hxml
cargo check --manifest-path generated/thread-read-create-goal-tool/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-create-goal-tool/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-create-goal-tool/Cargo.toml --locked --quiet
