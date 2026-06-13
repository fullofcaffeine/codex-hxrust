#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

rm -rf generated/thread-read-turns-page
haxe -cp src -cp test -main ThreadReadTurnsPageHarness --interp
haxe hxml/thread-read-turns-page.hxml
cargo check --manifest-path generated/thread-read-turns-page/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-turns-page/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-turns-page/Cargo.toml --locked --quiet

echo "Thread read turns page harness passed."
