package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerEditingModeKind(String) to String {
	final Insert = "insert";
	final Normal = "normal";
	final OperatorPending = "operator_pending";
	final Bash = "bash";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerEditingModeKind {
		return switch value {
			case "insert": Insert;
			case "normal": Normal;
			case "operator_pending": OperatorPending;
			case "bash": Bash;
			case _: Unknown;
		}
	}
}
