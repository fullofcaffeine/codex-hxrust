#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-resume-goal-snapshot
haxe -cp src -cp test -main ThreadReadResumeGoalSnapshotHarness --interp
haxe hxml/thread-read-resume-goal-snapshot.hxml
cargo check --manifest-path generated/thread-read-resume-goal-snapshot/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-resume-goal-snapshot/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-resume-goal-snapshot/Cargo.toml --locked --quiet

echo "Thread read resume goal snapshot harness passed."
