package codexhx.runtime.model.streamitem;

enum abstract ModelThreadBufferedRequestEvictionKind(String) to String {
	final BufferedRequestRetained = "buffered_request_retained";
	final PendingPromptRemoved = "pending_prompt_removed";
	final ReplaySkippedAfterEviction = "replay_skipped_after_eviction";
	final NonRequestEvictionIgnored = "non_request_eviction_ignored";
	final InvalidCapacityRefused = "invalid_capacity_refused";
}
