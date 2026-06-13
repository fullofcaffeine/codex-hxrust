#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

rm -rf generated/thread-read-turn-items-list
haxe -cp src -cp test -main ThreadReadTurnItemsListHarness --interp
haxe hxml/thread-read-turn-items-list.hxml
cargo check --manifest-path generated/thread-read-turn-items-list/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turn-items-list/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turn-items-list/Cargo.toml --locked --quiet

echo "Thread read turn items list harness passed."
