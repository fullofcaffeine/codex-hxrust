package codexhx.runtime.model.streamitem;

enum abstract ModelAppServerQueuedRequestDeliveryKind(String) to String {
	final ActiveThreadDelivered = "active_thread_delivered";
	final BackgroundBufferedDelivered = "background_buffered_delivered";
	final PendingPrimaryDeferred = "pending_primary_deferred";
	final NonPendingSkipped = "non_pending_skipped";
	final ReplayDelivered = "replay_delivered";
	final NotQueuedSkipped = "not_queued_skipped";
}
