#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-reload-scroll-preservation-render
haxe -cp src -cp test -main ResumePickerReloadScrollPreservationRenderHarness --interp
haxe hxml/resume-picker-reload-scroll-preservation-render.hxml
cargo check --manifest-path generated/resume-picker-reload-scroll-preservation-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-reload-scroll-preservation-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-reload-scroll-preservation-render/Cargo.toml --locked --quiet

echo "Resume picker reload scroll preservation render harness passed."
