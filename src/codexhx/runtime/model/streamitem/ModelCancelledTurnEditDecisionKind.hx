package codexhx.runtime.model.streamitem;

enum abstract ModelCancelledTurnEditDecisionKind(String) to String {
	final RestoredPromptWithLocalRollback = "restored_prompt_with_local_rollback";
	final RestoredFirstPromptWithoutLocalHistory = "restored_first_prompt_without_local_history";
	final PendingRollbackRejected = "pending_rollback_rejected";
}
