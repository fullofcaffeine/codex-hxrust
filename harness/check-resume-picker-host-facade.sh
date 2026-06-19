#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-host-facade
haxe -cp src -cp test -main ResumePickerHostFacadeHarness --interp
haxe hxml/resume-picker-host-facade.hxml
cargo check --manifest-path generated/resume-picker-host-facade/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-host-facade/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-host-facade/Cargo.toml --locked --quiet

echo "Resume picker host facade harness passed."
