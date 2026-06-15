package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapListConflictDecisionKind(String) to String {
	final KeymapListConflictRejected = "keymap_list_conflict_rejected";
	final KeymapListConflictMissed = "keymap_list_conflict_missed";
}
