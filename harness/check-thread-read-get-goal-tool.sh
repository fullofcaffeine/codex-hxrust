#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-get-goal-tool
haxe -cp src -cp test -main ThreadReadGetGoalToolHarness --interp
haxe hxml/thread-read-get-goal-tool.hxml
cargo check --manifest-path generated/thread-read-get-goal-tool/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-get-goal-tool/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-get-goal-tool/Cargo.toml --locked --quiet
