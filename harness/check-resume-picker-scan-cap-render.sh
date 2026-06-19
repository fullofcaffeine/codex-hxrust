#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-scan-cap-render
haxe -cp src -cp test -main ResumePickerScanCapRenderHarness --interp
haxe hxml/resume-picker-scan-cap-render.hxml
cargo check --manifest-path generated/resume-picker-scan-cap-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-scan-cap-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-scan-cap-render/Cargo.toml --locked --quiet

echo "Resume picker scan-cap render harness passed."
