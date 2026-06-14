package codexhx.runtime.model.streamitem;

enum abstract ModelAppServerRequestEnqueueRouteKind(String) to String {
	final PrimaryPendingQueue = "primary_pending_queue";
	final PrimaryThreadQueue = "primary_thread_queue";
	final BackgroundThreadQueue = "background_thread_queue";
	final ThreadlessIgnored = "threadless_ignored";
	final UnsupportedRejectedSkip = "unsupported_rejected_skip";
	final EnqueueFailure = "enqueue_failure";
}
