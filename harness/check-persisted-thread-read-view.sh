#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/persisted-thread-read-view
haxe -cp src -cp test -main PersistedThreadReadViewHarness --interp
haxe hxml/persisted-thread-read-view.hxml
cargo check --manifest-path generated/persisted-thread-read-view/Cargo.toml --locked
cargo test --manifest-path generated/persisted-thread-read-view/Cargo.toml --locked
cargo run --manifest-path generated/persisted-thread-read-view/Cargo.toml --locked --quiet

echo "Persisted thread read-view harness passed."
