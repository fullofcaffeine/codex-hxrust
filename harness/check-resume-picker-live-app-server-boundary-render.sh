#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-live-app-server-boundary-render
haxe -cp src -cp test -main ResumePickerLiveAppServerBoundaryRenderHarness --interp
haxe hxml/resume-picker-live-app-server-boundary-render.hxml
cargo check --manifest-path generated/resume-picker-live-app-server-boundary-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-live-app-server-boundary-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-live-app-server-boundary-render/Cargo.toml --locked --quiet

echo "Resume picker live app-server boundary render harness passed."
