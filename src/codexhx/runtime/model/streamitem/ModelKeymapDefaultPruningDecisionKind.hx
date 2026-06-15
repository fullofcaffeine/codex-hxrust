package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapDefaultPruningDecisionKind(String) to String {
	final KeymapDefaultPruningPreserved = "keymap_default_pruning_preserved";
	final KeymapDefaultPruningRejected = "keymap_default_pruning_rejected";
}
