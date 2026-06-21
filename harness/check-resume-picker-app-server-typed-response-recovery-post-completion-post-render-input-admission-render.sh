#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OUT="generated/resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-admission-render"
rm -rf "$OUT"

haxe -cp src -cp test -main ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderInputAdmissionRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-input-admission-render.hxml
cargo check --manifest-path "$OUT/Cargo.toml"
cargo test --manifest-path "$OUT/Cargo.toml"
cargo run --manifest-path "$OUT/Cargo.toml"

echo "Resume picker app-server typed response recovery post-completion post-render input admission render harness passed."
