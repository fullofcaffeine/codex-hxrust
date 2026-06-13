#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-update-goal-tool
haxe -cp src -cp test -main ThreadReadUpdateGoalToolHarness --interp
haxe hxml/thread-read-update-goal-tool.hxml
cargo check --manifest-path generated/thread-read-update-goal-tool/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-update-goal-tool/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-update-goal-tool/Cargo.toml --locked --quiet
