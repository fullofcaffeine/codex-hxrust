#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-no-credential-gate generated/tmp/resume-picker-no-credential
haxe -cp src -cp test -main ResumePickerNoCredentialGateHarness --interp
haxe hxml/resume-picker-no-credential-gate.hxml
cargo check --manifest-path generated/resume-picker-no-credential-gate/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-no-credential-gate/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-no-credential-gate/Cargo.toml --locked --quiet

echo "Resume picker no-credential gate harness passed."
