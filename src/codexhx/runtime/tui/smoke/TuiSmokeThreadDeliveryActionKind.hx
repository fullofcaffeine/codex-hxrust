package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadDeliveryActionKind(String) to String {
	final DrainActive = "drain_active";
	final SwitchActive = "switch_active";
	final EvictQueued = "evict_queued";
	final EvictNotification = "evict_notification";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeThreadDeliveryActionKind {
		return switch value {
			case "drain_active": DrainActive;
			case "switch_active": SwitchActive;
			case "evict_queued": EvictQueued;
			case "evict_notification": EvictNotification;
			case _: Unknown;
		}
	}
}
