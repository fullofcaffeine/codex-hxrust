package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapApprovalConflictDecisionKind(String) to String {
	final KeymapApprovalConflictRejected = "keymap_approval_conflict_rejected";
	final KeymapApprovalConflictMissed = "keymap_approval_conflict_missed";
}
