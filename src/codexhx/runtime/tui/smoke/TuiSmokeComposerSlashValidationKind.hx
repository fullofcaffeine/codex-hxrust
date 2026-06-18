package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerSlashValidationKind(String) to String {
	final Immediate = "immediate";
	final Deferred = "deferred";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerSlashValidationKind {
		return switch value {
			case "immediate": Immediate;
			case "deferred": Deferred;
			case _: Unknown;
		}
	}
}
