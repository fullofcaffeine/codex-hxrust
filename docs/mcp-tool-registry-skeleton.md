# MCP / Tool Registry Skeleton

**Date:** 2026-06-11
**Bead:** `HXCX-4.5` / `codex-hxrust-hpu.5`
**Gate:** G4 tools/state/security
**Decision:** Add a minimal typed registry for fixture lookup and model-visible tool metadata. Do not claim real MCP transport.

Machine-readable record:

`reference/tool-registry-skeleton.v1.json`

Validation gate:

```bash
harness/check-tool-registry.sh
```

## Implemented

The skeleton owns three DTO families:

| DTO | Purpose |
| --- | --- |
| `ToolRegistryEntry` | Local, MCP, and dynamic model-visible tool metadata. |
| `ToolLookupOutcome` | Deterministic fixture lookup with `tool_not_found` failures. |
| `ToolCallOutcome` | Explicit fail-closed unsupported operation results. |

The registry preserves raw MCP routing identity while exposing sanitized model-visible names:

| Raw | Model-visible |
| --- | --- |
| server `music-studio`, tool `get-strudel-guide` | `mcp__music_studio__get_strudel_guide` |

This mirrors the upstream principle that raw MCP identity is kept for protocol calls, while model-visible names are normalized.

## Unsupported MCP Features

These methods fail closed with stable error codes:

| Method | Error |
| --- | --- |
| `mcpServerStatus/list` | `unsupported_mcp_server_status` |
| `mcpServer/resource/read` | `unsupported_mcp_resource_read` |
| `mcpServer/tool/call` | `unsupported_mcp_tool_call` |
| `config/mcpServer/reload` | `unsupported_mcp_reload` |
| `mcpServer/oauth/login` | `unsupported_mcp_oauth` |

## Future Real MCP Scope

Real MCP work remains out of this bead and needs separate acceptance gates for:

- stdio and streamable HTTP MCP client startup
- `initialize` / `tools/list` protocol handling
- per-server allow/deny filters
- tool cache ownership and invalidation
- resource/template reads
- OAuth credentials and host-owned app connectors
- elicitation/review flows
- live tool execution dispatch and app-server progress notifications

The skeleton is not a parallel Cafex action registry. Cafex/UI affordances must project over upstream-shaped tool metadata rather than inventing client-local commands.
