#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

haxe -cp src -cp test -main ResumePickerAppServerResponseTransportEnvelopeRenderHarness --interp
haxe hxml/resume-picker-app-server-response-transport-envelope-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-response-transport-envelope-render/Cargo.toml
cargo test --manifest-path generated/resume-picker-app-server-response-transport-envelope-render/Cargo.toml
cargo run --manifest-path generated/resume-picker-app-server-response-transport-envelope-render/Cargo.toml

echo "Resume picker app-server response transport envelope render harness passed."
