package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerHostOutcomeKind(String) to String {
	final Accepted = "accepted";
	final Rendered = "rendered";
	final Persisted = "persisted";
	final Scheduled = "scheduled";
	final Failed = "failed";
	final Unsupported = "unsupported";
	final Unknown = "unknown";
}
