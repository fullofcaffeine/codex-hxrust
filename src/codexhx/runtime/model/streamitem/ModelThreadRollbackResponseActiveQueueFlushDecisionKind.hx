package codexhx.runtime.model.streamitem;

enum abstract ModelThreadRollbackResponseActiveQueueFlushDecisionKind(String) to String {
	final ActiveQueueFlushed = "active_queue_flushed";
	final ActiveQueueUnchanged = "active_queue_unchanged";
}
