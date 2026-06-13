#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-goal-tool-contributor-visibility
haxe -cp src -cp test -main ThreadReadGoalToolContributorVisibilityHarness --interp
haxe hxml/thread-read-goal-tool-contributor-visibility.hxml
cargo check --manifest-path generated/thread-read-goal-tool-contributor-visibility/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-goal-tool-contributor-visibility/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-goal-tool-contributor-visibility/Cargo.toml --locked --quiet
