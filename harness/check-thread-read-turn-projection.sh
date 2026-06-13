#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-turn-projection
haxe -cp src -cp test -main ThreadReadTurnProjectionHarness --interp
haxe hxml/thread-read-turn-projection.hxml
cargo check --manifest-path generated/thread-read-turn-projection/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turn-projection/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turn-projection/Cargo.toml --locked --quiet

echo "Thread read turn projection harness passed."
