#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

haxe -cp src -cp test -main CompletionRenderedStateHandoffRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render/Cargo.toml
cargo test --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render/Cargo.toml
cargo run --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-rendered-state-handoff-render/Cargo.toml

echo "Resume picker app-server typed response recovery post-completion rendered-state handoff render harness passed."
