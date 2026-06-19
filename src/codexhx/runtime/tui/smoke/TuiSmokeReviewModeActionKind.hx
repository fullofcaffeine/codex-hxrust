package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeReviewModeActionKind(String) to String {
	final Popup = "popup";
	final Picker = "picker";
	final CustomPrompt = "custom_prompt";
	final EnterExit = "enter_exit";
	final SteerQueue = "steer_queue";
	final Warning = "warning";
	final TokenRestore = "token_restore";
	final Guardian = "guardian";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeReviewModeActionKind {
		return switch value {
			case "popup": Popup;
			case "picker": Picker;
			case "custom_prompt": CustomPrompt;
			case "enter_exit": EnterExit;
			case "steer_queue": SteerQueue;
			case "warning": Warning;
			case "token_restore": TokenRestore;
			case "guardian": Guardian;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
