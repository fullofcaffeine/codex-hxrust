package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeGoalMenuActionKind(String) to String {
	final Summary = "summary";
	final Indicator = "indicator";
	final EditPrompt = "edit_prompt";
	final ResumePrompt = "resume_prompt";
	final Validation = "validation";
	final InterruptPause = "interrupt_pause";
	final Clear = "clear";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeGoalMenuActionKind {
		return switch value {
			case "summary": Summary;
			case "indicator": Indicator;
			case "edit_prompt": EditPrompt;
			case "resume_prompt": ResumePrompt;
			case "validation": Validation;
			case "interrupt_pause": InterruptPause;
			case "clear": Clear;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
