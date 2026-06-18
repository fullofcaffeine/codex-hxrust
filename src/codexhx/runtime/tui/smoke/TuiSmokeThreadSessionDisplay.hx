package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadSessionDisplay(String) to String {
	final Normal = "normal";
	final Quiet = "quiet";
	final SideConversation = "side_conversation";
	final None = "none";

	public static function fromString(value:String):TuiSmokeThreadSessionDisplay {
		return switch value {
			case "normal": Normal;
			case "quiet": Quiet;
			case "side_conversation": SideConversation;
			case _: None;
		}
	}
}
