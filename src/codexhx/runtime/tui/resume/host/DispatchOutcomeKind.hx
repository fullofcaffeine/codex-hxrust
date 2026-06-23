package codexhx.runtime.tui.resume.host;

enum abstract DispatchOutcomeKind(String) to String {
	final ResolveSent = "resolve_sent";
	final RejectSent = "reject_sent";
	final LocalNoop = "local_noop";
	final LateDuplicateRefused = "late_duplicate_refused";
	final SerializationRefused = "serialization_refused";
	final Unknown = "unknown";
}
