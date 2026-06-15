package codexhx.runtime.model.streamitem;

enum abstract ModelThreadSideThreadInterruptKind(String) to String {
	var None = "none";
	var TurnInterrupt = "turn_interrupt";
	var StartupInterrupt = "startup_interrupt";
}
