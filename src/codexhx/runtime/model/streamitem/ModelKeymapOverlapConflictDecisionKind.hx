package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapOverlapConflictDecisionKind(String) to String {
	final KeymapOverlapConflictsPreserved = "keymap_overlap_conflicts_preserved";
	final KeymapOverlapConflictsRejected = "keymap_overlap_conflicts_rejected";
}
