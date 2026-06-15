package codexhx.runtime.model.streamitem;

enum abstract ModelBacktrackTranscriptCellKind(String) to String {
	final SessionHeader = "session_header";
	final User = "user";
	final Agent = "agent";
}
