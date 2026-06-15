package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapFixedShortcutDecisionKind(String) to String {
	final KeymapFixedShortcutConflictPreserved = "keymap_fixed_shortcut_conflict_preserved";
	final KeymapFixedShortcutConflictRejected = "keymap_fixed_shortcut_conflict_rejected";
}
