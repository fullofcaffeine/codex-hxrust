package codexhx.runtime.model.streamitem;

enum abstract ModelInterruptBacktrackKeymapDecisionKind(String) to String {
	final InterruptBacktrackKeymapAccepted = "interrupt_backtrack_keymap_accepted";
	final InterruptBacktrackKeymapRejected = "interrupt_backtrack_keymap_rejected";
}
