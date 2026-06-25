package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAgentStatusItemKind(String) to String {
	final AgentMessage = "agent_message";
	final Plan = "plan";
	final Reasoning = "reasoning";
	final CommandExecution = "command_execution";
	final FileChange = "file_change";
	final McpToolCall = "mcp_tool_call";
	final DynamicToolCall = "dynamic_tool_call";
	final CollabAgentToolCall = "collab_agent_tool_call";
	final SubAgentActivity = "sub_agent_activity";
	final WebSearch = "web_search";
	final ImageView = "image_view";
	final ImageGeneration = "image_generation";
	final EnteredReviewMode = "entered_review_mode";
	final ExitedReviewMode = "exited_review_mode";
	final ContextCompaction = "context_compaction";
	final Skipped = "skipped";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAgentStatusItemKind {
		return switch value {
			case "agent_message": AgentMessage;
			case "plan": Plan;
			case "reasoning": Reasoning;
			case "command_execution": CommandExecution;
			case "file_change": FileChange;
			case "mcp_tool_call": McpToolCall;
			case "dynamic_tool_call": DynamicToolCall;
			case "collab_agent_tool_call": CollabAgentToolCall;
			case "sub_agent_activity": SubAgentActivity;
			case "web_search": WebSearch;
			case "image_view": ImageView;
			case "image_generation": ImageGeneration;
			case "entered_review_mode": EnteredReviewMode;
			case "exited_review_mode": ExitedReviewMode;
			case "context_compaction": ContextCompaction;
			case "skipped": Skipped;
			case _: Unknown;
		}
	}
}
