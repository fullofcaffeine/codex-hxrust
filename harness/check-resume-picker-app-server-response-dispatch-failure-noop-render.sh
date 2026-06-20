#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

haxe -cp src -cp test -main ResumePickerAppServerResponseDispatchFailureNoopRenderHarness --interp
haxe hxml/resume-picker-app-server-response-dispatch-failure-noop-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-response-dispatch-failure-noop-render/Cargo.toml
cargo test --manifest-path generated/resume-picker-app-server-response-dispatch-failure-noop-render/Cargo.toml
cargo run --manifest-path generated/resume-picker-app-server-response-dispatch-failure-noop-render/Cargo.toml

echo "Resume picker app-server response dispatch failure/noop render harness passed."
