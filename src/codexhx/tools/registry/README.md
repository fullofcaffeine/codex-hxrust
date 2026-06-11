# Tool Registry

`ToolRegistry` is the HXCX-4.5 compatibility skeleton for model-visible tool metadata and fixture lookup.

Implemented:

- local function tool DTOs
- MCP tool DTOs that preserve raw server/tool identity
- dynamic tool DTOs shaped after the app-server `DynamicToolSpec` subset
- model-visible name normalization for MCP and dynamic tools
- deterministic lookup/list JSON
- explicit unsupported errors for MCP status, resource read, tool call, reload, and OAuth operations

Not implemented:

- MCP process/HTTP transport
- `tools/list` startup and cache refresh
- MCP OAuth credential handling
- resource/template reads
- elicitation/review flows
- live tool execution dispatch
- plugin marketplace ownership

The skeleton is intentionally not a parallel Cafex action registry. It is a typed evidence surface for selected fixtures until real upstream-compatible MCP work is scheduled.
