package codexhx.tools.registry;

import haxe.json.Value;

class ToolRegistry {
	final entries:Array<ToolRegistryEntry>;

	public function new() {
		entries = [];
	}

	public function register(entry:ToolRegistryEntry):ToolLookupOutcome {
		if (!ToolKind.isValid(entry.kind)) {
			return ToolLookupOutcome.missing(entry.name);
		}
		if (find(entry.name).ok) {
			return ToolLookupOutcome.missing(entry.name);
		}
		entries.push(entry);
		return ToolLookupOutcome.found(entry.name, entry);
	}

	public function registerLocalFunction(name:String, description:String, inputSchema:Value):ToolLookupOutcome {
		return register(ToolRegistryEntry.localFunction(name, description, inputSchema));
	}

	public function registerMcpTool(serverName:String, rawToolName:String, description:String, inputSchema:Value, connectorId:String, connectorName:String,
			supportsParallelToolCalls:Bool):ToolLookupOutcome {
		return register(ToolRegistryEntry.mcp(serverName, rawToolName, description, inputSchema, connectorId, connectorName, supportsParallelToolCalls));
	}

	public function registerDynamicTool(namespace:String, name:String, description:String, inputSchema:Value, deferLoading:Bool):ToolLookupOutcome {
		return register(ToolRegistryEntry.dynamicTool(namespace, name, description, inputSchema, deferLoading));
	}

	public function find(query:String):ToolLookupOutcome {
		final trimmed = StringTools.trim(query);
		for (entry in entries) {
			if (entry.name == trimmed || (entry.namespace == "" && entry.tool == trimmed)) {
				return ToolLookupOutcome.found(trimmed, entry);
			}
		}
		return ToolLookupOutcome.missing(trimmed);
	}

	public function listJson():String {
		final sorted = entries.copy();
		sorted.sort(compareEntries);
		final parts:Array<String> = [];
		for (entry in sorted) {
			parts.push(entry.json());
		}
		return "[" + parts.join(",") + "]";
	}

	public function unsupportedMcpFeature(method:String, toolName:String):ToolCallOutcome {
		return switch method {
			case "mcpServerStatus/list":
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_server_status", "MCP server status listing is not implemented in codexhx");
			case "mcpServer/resource/read":
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_resource_read", "MCP resource reads are not implemented in codexhx");
			case "mcpServer/tool/call":
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_tool_call", "MCP tool execution is not implemented in codexhx");
			case "config/mcpServer/reload":
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_reload", "MCP server reload is not implemented in codexhx");
			case "mcpServer/oauth/login":
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_oauth", "MCP OAuth login is not implemented in codexhx");
			case _:
				ToolCallOutcome.unsupported(method, toolName, "unsupported_mcp_feature", "MCP feature is not implemented in codexhx");
		}
	}

	static function compareEntries(a:ToolRegistryEntry, b:ToolRegistryEntry):Int {
		if (a.name < b.name)
			return -1;
		if (a.name > b.name)
			return 1;
		return 0;
	}
}
