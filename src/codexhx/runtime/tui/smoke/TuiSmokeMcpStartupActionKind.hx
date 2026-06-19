package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeMcpStartupActionKind(String) to String {
	final SetExpectedServers = "set_expected_servers";
	final StatusUpdate = "status_update";
	final FinishAfterLag = "finish_after_lag";
	final FinishStartup = "finish_startup";
	final PendingRoundPromotion = "pending_round_promotion";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeMcpStartupActionKind {
		return switch value {
			case "set_expected_servers": SetExpectedServers;
			case "status_update": StatusUpdate;
			case "finish_after_lag": FinishAfterLag;
			case "finish_startup": FinishStartup;
			case "pending_round_promotion": PendingRoundPromotion;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
