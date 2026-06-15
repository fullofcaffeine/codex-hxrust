package codexhx.runtime.model.streamitem;

enum abstract ModelTuiActiveTurnErrorRequestKind(String) from String to String {
	final ActiveTurnNotSteerable = "active_turn_not_steerable";
	final SteerRace = "steer_race";
	final InterruptRace = "interrupt_race";
	final SessionStart = "session_start";
}
