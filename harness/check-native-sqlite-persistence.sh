#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/native-sqlite-persistence
haxe -cp src -cp test -main NativeSqlitePersistenceHarness --interp
haxe hxml/native-sqlite-persistence.hxml
cargo check --manifest-path generated/native-sqlite-persistence/Cargo.toml --locked
cargo test --manifest-path generated/native-sqlite-persistence/Cargo.toml --locked
cargo run --manifest-path generated/native-sqlite-persistence/Cargo.toml --locked --quiet

echo "Native SQLite persistence harness passed."
