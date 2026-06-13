#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-token-usage-owner
haxe -cp src -cp test -main ThreadReadTokenUsageOwnerHarness --interp
haxe hxml/thread-read-token-usage-owner.hxml
cargo check --manifest-path generated/thread-read-token-usage-owner/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-token-usage-owner/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-token-usage-owner/Cargo.toml --locked --quiet

echo "Thread read token usage owner harness passed."
