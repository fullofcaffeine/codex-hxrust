package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeUnifiedExecFooterActionKind(String) to String {
	final SetProcesses = "set_processes";
	final Summary = "summary";
	final Render = "render";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeUnifiedExecFooterActionKind {
		return switch value {
			case "set_processes": SetProcesses;
			case "summary": Summary;
			case "render": Render;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
