package codexhx.runtime.tui.terminal;

/**
	Typed terminal event stream consumed by the production TUI loop.
**/
enum TerminalEvent {
	NoEvent;
	Tick;
	DrawRequested;
	Key(key:TerminalKey);
	Resize(size:TerminalSize);
	Exit(reason:TerminalExitReason);
}
