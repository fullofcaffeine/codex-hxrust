#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

rm -rf generated/thread-read-active-turn-merge
haxe -cp src -cp test -main ThreadReadActiveTurnMergeHarness --interp
haxe hxml/thread-read-active-turn-merge.hxml
cargo check --manifest-path generated/thread-read-active-turn-merge/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-active-turn-merge/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-active-turn-merge/Cargo.toml --locked --quiet

echo "Thread read active-turn merge harness passed."
