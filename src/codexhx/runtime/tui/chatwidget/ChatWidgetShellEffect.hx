package codexhx.runtime.tui.chatwidget;

import codexhx.runtime.tui.terminal.TerminalExitReason;

/**
	Typed effects emitted by the minimal ChatWidget shell reducer.
**/
enum ChatWidgetShellEffect {
	DrawRequested;
	PromptSubmitted(text:String);
	ExitRequested(reason:TerminalExitReason);
}
