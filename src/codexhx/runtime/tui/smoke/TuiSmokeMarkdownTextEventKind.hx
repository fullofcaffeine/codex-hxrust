package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMarkdownTextEventKind(String) to String {
	final Text = "Text";
	final Start = "Start";
	final End = "End";
	final SoftBreak = "SoftBreak";
	final Html = "Html";
	final Code = "Code";
	final Unknown = "Unknown";

	public static function fromString(value:String):TuiSmokeMarkdownTextEventKind {
		return switch value {
			case "Text": Text;
			case "Start": Start;
			case "End": End;
			case "SoftBreak": SoftBreak;
			case "Html": Html;
			case "Code": Code;
			case _: Unknown;
		}
	}
}
