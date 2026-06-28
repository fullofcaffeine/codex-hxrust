package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeActiveThreadShutdownRoute(String) to String {
	final NonPrimaryFailover = "non_primary_failover";
	final PendingExitCompletion = "pending_exit_completion";
	final PrimaryClosedNoFailover = "primary_closed_no_failover";
	final NonShutdownPassThrough = "non_shutdown_pass_through";
	final StaleShutdownIgnored = "stale_shutdown_ignored";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeActiveThreadShutdownRoute {
		return switch value {
			case "non_primary_failover": NonPrimaryFailover;
			case "pending_exit_completion": PendingExitCompletion;
			case "primary_closed_no_failover": PrimaryClosedNoFailover;
			case "non_shutdown_pass_through": NonShutdownPassThrough;
			case "stale_shutdown_ignored": StaleShutdownIgnored;
			case _: Unknown;
		}
	}
}
