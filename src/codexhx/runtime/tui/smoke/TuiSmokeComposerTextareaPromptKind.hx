package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerTextareaPromptKind(String) to String {
	final Normal = "normal";
	final Bash = "bash";
	final Disabled = "disabled";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerTextareaPromptKind {
		return switch value {
			case "normal": Normal;
			case "bash": Bash;
			case "disabled": Disabled;
			case _: Unknown;
		}
	}
}
