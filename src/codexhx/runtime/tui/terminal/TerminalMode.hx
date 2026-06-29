package codexhx.runtime.tui.terminal;

/**
	Terminal ownership mode requested by the production TUI shell.
**/
enum abstract TerminalMode(String) to String {
	final Headless = "headless";
	final Live = "live";
}
