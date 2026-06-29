package codexhx.runtime.tui.terminal;

/**
	Typed terminal side effects emitted by `TerminalRedrawScheduler`.
**/
enum TerminalSchedulerEffect {
	ResizeBackend(size:TerminalSize);
	DrawFrame(frame:TerminalFrame);
	RequestExit(reason:TerminalExitReason);
}
