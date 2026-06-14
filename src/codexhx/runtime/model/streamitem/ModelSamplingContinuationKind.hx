package codexhx.runtime.model.streamitem;

enum abstract ModelSamplingContinuationKind(String) to String {
	var None = "none";
	var ModelFollowUp = "model_follow_up";
	var PendingInput = "pending_input";
	var ModelFollowUpAndPendingInput = "model_follow_up_and_pending_input";
	var TokenLimitCompaction = "token_limit_compaction";
}
