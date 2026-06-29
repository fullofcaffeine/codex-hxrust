package codexhx.runtime.tui.terminal;

/**
	Strict key events understood by the first live TUI shell.
**/
enum TerminalKey {
	Character(value:String);
	Enter;
	Escape;
	CtrlC;
	Backspace;
	ArrowUp;
	ArrowDown;
	ArrowLeft;
	ArrowRight;
	AgentPrevious;
	AgentNext;
}
