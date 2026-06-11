#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

jq -e '
  .schema == "codex-hxrust.haxe-rust-performance-convergence-plan.v1"
  and .codexIssue == "codex-hxrust-yt7"
  and (.compilerFollowUps[] | select(.id == "haxe.rust-oo3.73"))
  and (.architecture.defaultContract == "portable")
  and (.architecture.nativeOptInContract == "metal")
  and (.architecture.forbidden | index("Codex-specific compiler behavior") != null)
  and (.benchmarkCriteria[] | select(.family == "json_schema_validation" and .defaultContract == "portable"))
  and (.benchmarkCriteria[] | select(.family == "process_tool_boundaries" and .defaultContract == "metal"))
  and (.codexhxPortableFirstSlices | index("schema_protocol_validation") != null)
  and (.codexhxMetalNowSlices | index("live_app_server_transport") != null)
' reference/haxe-rust-performance-convergence-plan.v1.json >/dev/null

grep -q "haxe.rust-oo3.73" docs/haxe-rust-performance-convergence-plan.md
grep -q "near-term Rust-native authoring contract" docs/haxe-rust-performance-convergence-plan.md
grep -q "No Codex-specific compiler behavior is permitted" docs/haxe-rust-performance-convergence-plan.md

echo "haxe.rust performance convergence plan passed."
