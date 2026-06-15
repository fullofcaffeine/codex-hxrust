package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapEditorUnbindConflictDecisionKind(String) to String {
	final KeymapEditorUnbindConflictPreserved = "keymap_editor_unbind_conflict_preserved";
	final KeymapEditorUnbindConflictRejected = "keymap_editor_unbind_conflict_rejected";
}
