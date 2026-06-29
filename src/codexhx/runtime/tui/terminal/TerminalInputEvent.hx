package codexhx.runtime.tui.terminal;

/**
	Semantic input events consumed by the minimal live TUI composer.
**/
enum TerminalInputEvent {
	Text(value:String);
	Submit;
	Cancel;
	Interrupt;
	DeleteBackward;
	MoveLeft;
	MoveRight;
	HistoryPrevious;
	HistoryNext;
}
