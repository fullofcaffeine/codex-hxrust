#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/apply-patch-dry-run
rm -f generated/reports/apply-patch-dry-run.v1.jsonl
haxe -cp src -cp test -main ApplyPatchDryRunHarness --interp
haxe hxml/apply-patch-dry-run.hxml
cargo check --manifest-path generated/apply-patch-dry-run/Cargo.toml --locked
cargo test --manifest-path generated/apply-patch-dry-run/Cargo.toml --locked
cargo run --manifest-path generated/apply-patch-dry-run/Cargo.toml --locked --quiet
cmp fixtures/hxrust/apply-patch-dry-run-output.v1.jsonl generated/reports/apply-patch-dry-run.v1.jsonl

echo "Apply-patch dry-run harness passed."
