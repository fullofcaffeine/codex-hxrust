package codexhx.runtime.tui.terminal;

/**
	Production redraw scheduler input for the minimal live TUI shell.
**/
enum TerminalSchedulerEvent {
	Resize(size:TerminalSize);
	DrawRequested;
	Tick;
	AppExit(reason:TerminalExitReason);
}
