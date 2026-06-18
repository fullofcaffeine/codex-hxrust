package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeResumeActionKind(String) to String {
	final None = "none";
	final RealignInline = "realign_inline";
	final RestoreAlt = "restore_alt";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeResumeActionKind {
		return switch value {
			case "none": None;
			case "realign_inline": RealignInline;
			case "restore_alt": RestoreAlt;
			case _: Unknown;
		}
	}
}
