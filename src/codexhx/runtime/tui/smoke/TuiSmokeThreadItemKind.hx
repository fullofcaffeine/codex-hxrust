package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadItemKind(String) to String {
	final UserMessage = "user_message";
	final AgentMessage = "agent_message";
	final Reasoning = "reasoning";
	final Tool = "tool";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadItemKind {
		return switch value {
			case "user_message": UserMessage;
			case "agent_message": AgentMessage;
			case "reasoning": Reasoning;
			case "tool": Tool;
			case _: Unknown;
		}
	}
}
