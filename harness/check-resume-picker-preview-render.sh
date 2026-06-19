#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-preview-render
haxe -cp src -cp test -main ResumePickerPreviewRenderHarness --interp
haxe hxml/resume-picker-preview-render.hxml
cargo check --manifest-path generated/resume-picker-preview-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-preview-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-preview-render/Cargo.toml --locked --quiet

echo "Resume picker preview render harness passed."
