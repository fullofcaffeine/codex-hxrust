#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

rm -rf generated/thread-read-resume-idle-continuation
haxe -cp src -cp test -main ThreadReadResumeIdleContinuationHarness --interp
haxe hxml/thread-read-resume-idle-continuation.hxml
cargo check --manifest-path generated/thread-read-resume-idle-continuation/Cargo.toml --locked
cargo test --manifest-path generated/thread-read-resume-idle-continuation/Cargo.toml --locked
cargo run --manifest-path generated/thread-read-resume-idle-continuation/Cargo.toml --locked --quiet

echo "Thread read resume idle continuation harness passed."
