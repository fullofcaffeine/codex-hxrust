package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapPagerConflictDecisionKind(String) to String {
	final KeymapPagerConflictRejected = "keymap_pager_conflict_rejected";
	final KeymapPagerConflictMissed = "keymap_pager_conflict_missed";
}
