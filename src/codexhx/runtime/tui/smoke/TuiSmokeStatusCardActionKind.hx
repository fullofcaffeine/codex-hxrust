package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeStatusCardActionKind(String) to String {
	final Summary = "summary";
	final ModelProvider = "model_provider";
	final Permissions = "permissions";
	final ThreadSession = "thread_session";
	final TokenUsage = "token_usage";
	final RateLimit = "rate_limit";
	final Refresh = "refresh";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeStatusCardActionKind {
		return switch value {
			case "summary": Summary;
			case "model_provider": ModelProvider;
			case "permissions": Permissions;
			case "thread_session": ThreadSession;
			case "token_usage": TokenUsage;
			case "rate_limit": RateLimit;
			case "refresh": Refresh;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
