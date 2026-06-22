#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OUT="generated/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-render-request-scheduling-render"
rm -rf "$OUT"

haxe -cp src -cp test -main ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareRenderRequestSchedulingRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-render-request-scheduling-render.hxml
cargo check --manifest-path "$OUT/Cargo.toml"
cargo test --manifest-path "$OUT/Cargo.toml"
cargo run --manifest-path "$OUT/Cargo.toml"

echo "Resume picker app-server typed response recovery post-completion post-render replay-aware render request scheduling harness passed."
