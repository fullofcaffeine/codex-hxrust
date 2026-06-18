package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeOverlayKind(String) to String {
	final Transcript = "transcript";
	final StaticPager = "static";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeOverlayKind {
		return switch value {
			case "transcript": Transcript;
			case "static": StaticPager;
			case _: Unknown;
		}
	}
}
