package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadTranscriptItemKind(String) to String {
	final UserMessage = "user_message";
	final AgentMessage = "agent_message";
	final Plan = "plan";
	final Reasoning = "reasoning";
	final HookPrompt = "hook_prompt";
	final CommandExecution = "command_execution";
	final FileChange = "file_change";
	final McpToolCall = "mcp_tool_call";
	final DynamicToolCall = "dynamic_tool_call";
	final WebSearch = "web_search";
	final ImageView = "image_view";
	final ImageGeneration = "image_generation";
	final EnteredReviewMode = "entered_review_mode";
	final ExitedReviewMode = "exited_review_mode";
	final ContextCompaction = "context_compaction";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadTranscriptItemKind {
		return switch value {
			case "user_message": UserMessage;
			case "agent_message": AgentMessage;
			case "plan": Plan;
			case "reasoning": Reasoning;
			case "hook_prompt": HookPrompt;
			case "command_execution": CommandExecution;
			case "file_change": FileChange;
			case "mcp_tool_call": McpToolCall;
			case "dynamic_tool_call": DynamicToolCall;
			case "web_search": WebSearch;
			case "image_view": ImageView;
			case "image_generation": ImageGeneration;
			case "entered_review_mode": EnteredReviewMode;
			case "exited_review_mode": ExitedReviewMode;
			case "context_compaction": ContextCompaction;
			case _: Unknown;
		}
	}
}
