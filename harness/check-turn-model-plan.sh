#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

rm -rf generated/turn-model-plan
haxe -cp src -cp test -main TurnModelPlanHarness --interp
haxe hxml/turn-model-plan.hxml
cargo check --manifest-path generated/turn-model-plan/Cargo.toml --locked
cargo test --manifest-path generated/turn-model-plan/Cargo.toml --locked
cargo run --manifest-path generated/turn-model-plan/Cargo.toml --locked --quiet
