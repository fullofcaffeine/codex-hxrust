package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeSessionFlowActionKind(String) to String {
	final ConfigureSession = "configure_session";
	final SessionHeader = "session_header";
	final SkillsConnectors = "skills_connectors";
	final InitialUserMessage = "initial_user_message";
	final ForkedThreadEvent = "forked_thread_event";
	final ThreadNameUpdated = "thread_name_updated";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeSessionFlowActionKind {
		return switch value {
			case "configure_session": ConfigureSession;
			case "session_header": SessionHeader;
			case "skills_connectors": SkillsConnectors;
			case "initial_user_message": InitialUserMessage;
			case "forked_thread_event": ForkedThreadEvent;
			case "thread_name_updated": ThreadNameUpdated;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
