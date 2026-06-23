#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

haxe -cp src -cp test -main ResumePickerAppServerTypedResponseRecoveryRenderSnapshotReplayRenderHarness --interp
haxe hxml/resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render.hxml
cargo check --manifest-path generated/resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render/Cargo.toml
cargo test --manifest-path generated/resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render/Cargo.toml
cargo run --manifest-path generated/resume-picker-app-server-typed-response-recovery-render-snapshot-replay-render/Cargo.toml

echo "Resume picker app-server typed response recovery render snapshot replay render harness passed."
