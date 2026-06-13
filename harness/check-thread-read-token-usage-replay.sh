#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-token-usage-replay
haxe -cp src -cp test -main ThreadReadTokenUsageReplayHarness --interp
haxe hxml/thread-read-token-usage-replay.hxml
cargo check --manifest-path generated/thread-read-token-usage-replay/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-token-usage-replay/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-token-usage-replay/Cargo.toml --locked --quiet

echo "Thread read token usage replay harness passed."
