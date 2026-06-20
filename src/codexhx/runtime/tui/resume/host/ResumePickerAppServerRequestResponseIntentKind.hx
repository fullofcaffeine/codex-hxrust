package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerRequestResponseIntentKind(String) to String {
	final Resolved = "resolved";
	final Refused = "refused";
	final Unknown = "unknown";
}
