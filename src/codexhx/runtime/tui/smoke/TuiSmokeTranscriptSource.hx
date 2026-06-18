package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeTranscriptSource(String) to String {
	final System = "system";
	final User = "user";
	final Assistant = "assistant";
	final Tool = "tool";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeTranscriptSource {
		return switch value {
			case "system": System;
			case "user": User;
			case "assistant": Assistant;
			case "tool": Tool;
			case _: Unknown;
		}
	}
}
