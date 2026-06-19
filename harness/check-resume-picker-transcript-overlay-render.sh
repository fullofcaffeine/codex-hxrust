#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-transcript-overlay-render
haxe -cp src -cp test -main ResumePickerTranscriptOverlayRenderHarness --interp
haxe hxml/resume-picker-transcript-overlay-render.hxml
cargo check --manifest-path generated/resume-picker-transcript-overlay-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-transcript-overlay-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-transcript-overlay-render/Cargo.toml --locked --quiet

echo "Resume picker transcript overlay render harness passed."
