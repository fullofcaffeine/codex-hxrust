#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/process-exec generated/process-exec-sandbox
rm -f generated/reports/process-exec.v1.jsonl
haxe -cp src -cp test -main ProcessExecHarness --interp
haxe hxml/process-exec.hxml
cargo check --manifest-path generated/process-exec/Cargo.toml --locked
cargo test --manifest-path generated/process-exec/Cargo.toml --locked
cargo run --manifest-path generated/process-exec/Cargo.toml --locked --quiet
cmp fixtures/hxrust/process-exec-output.v1.jsonl generated/reports/process-exec.v1.jsonl

echo "Process exec harness passed."
