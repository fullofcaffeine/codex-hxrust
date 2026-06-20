package codexhx.runtime.tui.resume.host;

enum abstract ResumePickerAppServerTypedResponseRefreshApplicationKind(String) to String {
	final Applied = "applied";
	final IgnoredNoRefresh = "ignored_no_refresh";
	final Unknown = "unknown";
}
