package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeChatWidgetRestoreMergeOrder(String) to String {
	final RejectedPendingQueuedComposer = "rejected_pending_queued_composer";
	final PendingOnlySubmit = "pending_only_submit";
	final QueuedComposer = "queued_composer";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeChatWidgetRestoreMergeOrder {
		return switch value {
			case "rejected_pending_queued_composer": RejectedPendingQueuedComposer;
			case "pending_only_submit": PendingOnlySubmit;
			case "queued_composer": QueuedComposer;
			case _: Unknown;
		}
	}
}
