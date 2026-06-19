#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-reload-transcript-overlay-invalidation-render
haxe -cp src -cp test -main ResumePickerReloadTranscriptOverlayInvalidationRenderHarness --interp
haxe hxml/resume-picker-reload-transcript-overlay-invalidation-render.hxml
cargo check --manifest-path generated/resume-picker-reload-transcript-overlay-invalidation-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-reload-transcript-overlay-invalidation-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-reload-transcript-overlay-invalidation-render/Cargo.toml --locked --quiet

echo "Resume picker reload transcript overlay invalidation render harness passed."
