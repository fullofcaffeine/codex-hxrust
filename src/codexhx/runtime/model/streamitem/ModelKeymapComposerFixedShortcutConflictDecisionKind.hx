package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapComposerFixedShortcutConflictDecisionKind(String) to String {
	final KeymapComposerFixedShortcutConflictRejected = "keymap_composer_fixed_shortcut_conflict_rejected";
	final KeymapComposerFixedShortcutConflictMissed = "keymap_composer_fixed_shortcut_conflict_missed";
}
