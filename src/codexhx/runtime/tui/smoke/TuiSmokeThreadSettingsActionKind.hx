package codexhx.runtime.tui.smoke;

/** Fixture action kinds for upstream ChatWidget thread-settings notifications. */
enum abstract TuiSmokeThreadSettingsActionKind(String) to String {
	final VisibleUpdate = "visible_update";
	final WrongThreadIgnored = "wrong_thread_ignored";
	final PlanDefaultPreserved = "plan_default_preserved";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadSettingsActionKind {
		return switch value {
			case "visible_update": VisibleUpdate;
			case "wrong_thread_ignored": WrongThreadIgnored;
			case "plan_default_preserved": PlanDefaultPreserved;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
