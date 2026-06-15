package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapEditorConflictDecisionKind(String) to String {
	final KeymapEditorConflictRejected = "keymap_editor_conflict_rejected";
	final KeymapEditorConflictMissed = "keymap_editor_conflict_missed";
}
