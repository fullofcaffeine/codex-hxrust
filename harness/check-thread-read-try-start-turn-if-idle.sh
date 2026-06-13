#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/thread-read-try-start-turn-if-idle
haxe -cp src -cp test -main ThreadReadTryStartTurnIfIdleHarness --interp
haxe hxml/thread-read-try-start-turn-if-idle.hxml
cargo check --manifest-path generated/thread-read-try-start-turn-if-idle/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-try-start-turn-if-idle/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-try-start-turn-if-idle/Cargo.toml --locked --quiet
