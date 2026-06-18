package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeThreadBufferedEventKind(String) to String {
	final Request = "request";
	final Notification = "notification";
	final Unknown = "unknown";
}
