#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/diagnostics
rm -f generated/reports/diagnostics.v1.jsonl
haxe -cp src -cp test -main DiagnosticsHarness --interp
haxe hxml/diagnostics.hxml
cargo check --manifest-path generated/diagnostics/Cargo.toml --locked
cargo test --manifest-path generated/diagnostics/Cargo.toml --locked
cargo run --manifest-path generated/diagnostics/Cargo.toml --locked --quiet
cmp fixtures/hxrust/diagnostics-output.v1.jsonl generated/reports/diagnostics.v1.jsonl

echo "Diagnostics harness passed."
