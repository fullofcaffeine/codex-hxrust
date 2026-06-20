#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/resume-picker-app-server-response-dispatch-intent-render
haxe -cp src -cp test -main ResumePickerAppServerResponseDispatchIntentRenderHarness --interp
haxe hxml/resume-picker-app-server-response-dispatch-intent-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-response-dispatch-intent-render/Cargo.toml --locked
cargo test --manifest-path generated/resume-picker-app-server-response-dispatch-intent-render/Cargo.toml --locked
cargo run --manifest-path generated/resume-picker-app-server-response-dispatch-intent-render/Cargo.toml --locked --quiet

echo "Resume picker app-server response dispatch intent render harness passed."
