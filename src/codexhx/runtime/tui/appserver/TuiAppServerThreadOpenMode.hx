package codexhx.runtime.tui.appserver;

/** Selects the upstream app-server operation that establishes the TUI thread. */
enum abstract TuiAppServerThreadOpenMode(String) to String {
	var Start = "thread/start";
	var Resume = "thread/resume";
}
