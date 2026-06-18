#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/tui-smoke
haxe -cp src -cp test -main TuiSmokeHarness --interp
haxe hxml/tui-smoke.hxml
cargo check --manifest-path generated/tui-smoke/Cargo.toml --locked
cargo test --manifest-path generated/tui-smoke/Cargo.toml --locked
cargo run --manifest-path generated/tui-smoke/Cargo.toml --locked --quiet > generated/tui-smoke.snapshot.txt
diff -u fixtures/hxrust/tui-smoke.snapshot.txt generated/tui-smoke.snapshot.txt

echo "TUI smoke binary harness passed."
