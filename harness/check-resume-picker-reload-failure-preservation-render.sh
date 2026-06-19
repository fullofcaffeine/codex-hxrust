#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-reload-failure-preservation-render
haxe -cp src -cp test -main ResumePickerReloadFailurePreservationRenderHarness --interp
haxe hxml/resume-picker-reload-failure-preservation-render.hxml
cargo check --manifest-path generated/resume-picker-reload-failure-preservation-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-reload-failure-preservation-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-reload-failure-preservation-render/Cargo.toml --locked --quiet

echo "Resume picker reload failure preservation render harness passed."
