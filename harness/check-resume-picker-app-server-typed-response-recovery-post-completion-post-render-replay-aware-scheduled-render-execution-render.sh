#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OUT="generated/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-scheduled-render-execution-render"
rm -rf "$OUT"

haxe -cp src -cp test -main ResumePickerAppServerTypedResponseRecoveryPostCompletionPostRenderReplayAwareScheduledRenderExecutionRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-post-completion-post-render-replay-aware-scheduled-render-execution-render.hxml
cargo check --manifest-path "$OUT/Cargo.toml"
cargo test --manifest-path "$OUT/Cargo.toml"
cargo run --manifest-path "$OUT/Cargo.toml"

echo "Resume picker app-server typed response recovery post-completion post-render replay-aware scheduled render execution harness passed."
