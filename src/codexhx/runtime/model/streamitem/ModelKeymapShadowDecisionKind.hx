package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapShadowDecisionKind(String) to String {
	final KeymapShadowConflictsRejected = "keymap_shadow_conflicts_rejected";
	final KeymapShadowConflictsMissed = "keymap_shadow_conflicts_missed";
}
