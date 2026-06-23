package codexhx.runtime.tui.resume.host;

enum abstract RequestResponseIntentKind(String) to String {
	final Resolved = "resolved";
	final Refused = "refused";
	final Unknown = "unknown";
}
