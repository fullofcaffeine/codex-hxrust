package codexhx.runtime.model.streamitem;

enum abstract ModelInFlightToolDrainOutcomeKind(String) to String {
	final NoInFlight = "no_in_flight";
	final Drained = "drained";
	final FatalFailure = "fatal_failure";
}
