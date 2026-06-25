package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeAgentStatusActionKind(String) to String {
	final Empty = "empty";
	final Item = "item";
	final Thread = "thread";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeAgentStatusActionKind {
		return switch value {
			case "empty": Empty;
			case "item": Item;
			case "thread": Thread;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
