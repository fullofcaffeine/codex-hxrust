#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

haxe -cp src -cp test -main ResumePickerAppServerTypedResponseRecoveryPostCompletionScheduledRenderExecutionRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render/Cargo.toml
cargo test --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render/Cargo.toml
cargo run --manifest-path generated/resume-picker-app-server-typed-response-recovery-post-completion-scheduled-render-execution-render/Cargo.toml

echo "Resume picker app-server typed response recovery post-completion scheduled render execution render harness passed."
