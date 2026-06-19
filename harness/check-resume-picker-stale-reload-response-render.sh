#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-stale-reload-response-render
haxe -cp src -cp test -main ResumePickerStaleReloadResponseRenderHarness --interp
haxe hxml/resume-picker-stale-reload-response-render.hxml
cargo check --manifest-path generated/resume-picker-stale-reload-response-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-stale-reload-response-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-stale-reload-response-render/Cargo.toml --locked --quiet

echo "Resume picker stale reload response render harness passed."
