#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-tool-finish-goal-progress-admission
haxe -cp src -cp test -main ThreadReadToolFinishGoalProgressAdmissionHarness --interp
haxe hxml/thread-read-tool-finish-goal-progress-admission.hxml
cargo check --manifest-path generated/thread-read-tool-finish-goal-progress-admission/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-tool-finish-goal-progress-admission/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-tool-finish-goal-progress-admission/Cargo.toml --locked --quiet
