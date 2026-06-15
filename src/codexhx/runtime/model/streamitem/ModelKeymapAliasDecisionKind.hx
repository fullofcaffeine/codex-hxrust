package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapAliasDecisionKind(String) to String {
	final KeymapAliasesPreserved = "keymap_aliases_preserved";
	final KeymapAliasesRejected = "keymap_aliases_rejected";
}
