package codexhx.runtime.model.streamitem;

enum abstract ModelKeymapBindingInputDecisionKind(String) to String {
	final KeymapBindingInputsPreserved = "keymap_binding_inputs_preserved";
	final KeymapBindingInputsRejected = "keymap_binding_inputs_rejected";
}
