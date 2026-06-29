package codexhx.runtime.tui.terminal;

/**
	Production terminal boundary shared by headless tests and future live backends.
**/
interface TerminalBackend {
	function setup(request:TerminalSetup):TerminalOperation;
	function draw(frame:TerminalFrame):TerminalOperation;
	function pollEvent():TerminalEvent;
	function resize(size:TerminalSize):TerminalOperation;
	function requestExit(reason:TerminalExitReason):TerminalOperation;
	function restore(reason:TerminalRestoreReason):TerminalRestoreReport;
	function isActive():Bool;
	function wasRestored():Bool;
}
