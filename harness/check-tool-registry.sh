#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_ROOT="${ROOT}"
REFERENCE="${REPO_ROOT}/reference/tool-registry-skeleton.v1.json"

cd "$ROOT"

jq -e '
  .schema == "codex-hxrust.tool-registry-skeleton.v1"
  and .bead == "HXCX-4.5"
  and .decision.realMcpTransportImplemented == false
  and .decision.parallelCafexActionRegistryAllowed == false
  and (.decision.summary | test("fixture"))
' "$REFERENCE" >/dev/null

jq -e '
  (.implementedDtos | index("ToolRegistryEntry") != null)
  and (.implementedDtos | index("ToolLookupOutcome") != null)
  and (.implementedDtos | index("ToolCallOutcome") != null)
  and (.unsupportedMcpFeatures | length) >= 5
  and (.futureRealMcpScope | length) >= 6
' "$REFERENCE" >/dev/null

jq -e '
  .replacementGate.helperHeadless == "registry_lookup_allowed"
  and .replacementGate.selectedAdapterSlice == "lookup_allowed_transport_not_claimed"
  and .replacementGate.broadReplacement == "real_mcp_transport_and_app_server_parity_required"
' "$REFERENCE" >/dev/null

jq -e -s '
  length == 4
  and (.[0].lookup.entry.kind == "local_function")
  and (.[1].lookup.entry.kind == "mcp")
  and (.[1].lookup.entry.rawServerName == "music-studio")
  and (.[1].lookup.entry.rawToolName == "get-strudel-guide")
  and (.[1].lookup.entry.name == "mcp__music_studio__get_strudel_guide")
  and (.[2].lookup.entry.kind == "dynamic")
  and (.[3].lookup.ok == false)
  and (.[3].lookup.errorCode == "tool_not_found")
' fixtures/hxrust/tool-registry-lookup.v1.jsonl >/dev/null

jq -e -s '
  length == 5
  and ([.[].errorCode] | index("unsupported_mcp_server_status") != null)
  and ([.[].errorCode] | index("unsupported_mcp_resource_read") != null)
  and ([.[].errorCode] | index("unsupported_mcp_tool_call") != null)
  and ([.[].errorCode] | index("unsupported_mcp_reload") != null)
  and ([.[].errorCode] | index("unsupported_mcp_oauth") != null)
  and all(.[]; .ok == false)
' fixtures/hxrust/tool-registry-unsupported-mcp.v1.jsonl >/dev/null

rm -rf generated/tool-registry
haxe -cp src -cp test -main ToolRegistryHarness --interp
haxe hxml/tool-registry.hxml
cargo check --manifest-path generated/tool-registry/Cargo.toml --locked
cargo test --manifest-path generated/tool-registry/Cargo.toml --locked
cargo run --manifest-path generated/tool-registry/Cargo.toml --locked --quiet

echo "Tool registry harness passed."
