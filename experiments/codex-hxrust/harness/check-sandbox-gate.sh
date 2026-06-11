#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/sandbox-gate
rm -f generated/reports/sandbox-gate.v1.jsonl
haxe -cp src -cp test -main SandboxGateHarness --interp
haxe hxml/sandbox-gate.hxml
cargo check --manifest-path generated/sandbox-gate/Cargo.toml --locked
cargo test --manifest-path generated/sandbox-gate/Cargo.toml --locked
cargo run --manifest-path generated/sandbox-gate/Cargo.toml --locked --quiet
cmp fixtures/hxrust/sandbox-gate-output.v1.jsonl generated/reports/sandbox-gate.v1.jsonl

echo "Sandbox gate harness passed."
