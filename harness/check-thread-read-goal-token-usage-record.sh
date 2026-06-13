#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-goal-token-usage-record
haxe -cp src -cp test -main ThreadReadGoalTokenUsageRecordHarness --interp
haxe hxml/thread-read-goal-token-usage-record.hxml
cargo check --manifest-path generated/thread-read-goal-token-usage-record/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-goal-token-usage-record/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-goal-token-usage-record/Cargo.toml --locked --quiet
