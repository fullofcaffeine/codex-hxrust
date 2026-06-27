package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadTranscriptCellKind(String) to String {
	final User = "User";
	final AgentMarkdown = "AgentMarkdown";
	final Plan = "Plan";
	final Reasoning = "Reasoning";
	final Plain = "Plain";
	final Unknown = "Unknown";

	public static function fromString(value:String):TuiSmokeThreadTranscriptCellKind {
		return switch value {
			case "User": User;
			case "AgentMarkdown": AgentMarkdown;
			case "Plan": Plan;
			case "Reasoning": Reasoning;
			case "Plain": Plain;
			case _: Unknown;
		}
	}
}
