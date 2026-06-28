package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetInterruptKeyRouteKind(String) to String {
	final PendingSteersInterrupt = "pending_steers_interrupt";
	final RemappedBindingIgnored = "remapped_binding_ignored";
	final ReviewQueuedSteersWarning = "review_queued_steers_warning";
	final NoPendingSteersPassthrough = "no_pending_steers_passthrough";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetInterruptKeyRouteKind {
		return switch value {
			case "pending_steers_interrupt": PendingSteersInterrupt;
			case "remapped_binding_ignored": RemappedBindingIgnored;
			case "review_queued_steers_warning": ReviewQueuedSteersWarning;
			case "no_pending_steers_passthrough": NoPendingSteersPassthrough;
			case _: Unknown;
		}
	}
}
