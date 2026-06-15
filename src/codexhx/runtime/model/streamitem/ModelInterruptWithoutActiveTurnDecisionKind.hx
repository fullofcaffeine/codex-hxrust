package codexhx.runtime.model.streamitem;

enum abstract ModelInterruptWithoutActiveTurnDecisionKind(String) to String {
	final StartupInterruptSubmitted = "startup_interrupt_submitted";
	final ActiveTurnInterruptSubmitted = "active_turn_interrupt_submitted";
	final InterruptNotHandled = "interrupt_not_handled";
}
