package codexhx.runtime.tui.chatwidget;

import codexhx.runtime.tui.terminal.TerminalFrame;
import codexhx.runtime.tui.terminal.TerminalSize;

/**
	Renders the minimal ChatWidget shell into a terminal frame.
**/
class ChatWidgetShellRenderer {
	public static function render(state:ChatWidgetShellState, size:TerminalSize):TerminalFrame {
		final safeState = state == null ? ChatWidgetShellState.initial("model pending") : state;
		final safeSize = size == null || !size.valid() ? TerminalSize.of(80, 24) : size;
		final lines:Array<String> = [];
		lines.push(headerLine(safeState));
		lines.push(separatorLine(safeSize));
		appendTranscriptLines(lines, safeState, bodyCapacity(safeSize));
		lines.push(separatorLine(safeSize));
		lines.push(footerLine(safeState));
		lines.push(composerLine(safeState));
		final cursorRow = lines.length - 1;
		final cursorColumn = composerCursorColumn(safeState);
		return new TerminalFrame(safeSize, "Codex", lines, cursorRow, cursorColumn);
	}

	static function appendTranscriptLines(lines:Array<String>, state:ChatWidgetShellState, capacity:Int):Void {
		if (capacity <= 0)
			return;
		if (state.transcriptCount() == 0) {
			lines.push("system> ready");
			return;
		}
		final start = state.transcriptCount() > capacity ? state.transcriptCount() - capacity : 0;
		for (index in start...state.transcriptCount()) {
			lines.push(state.transcriptAt(index).renderText());
		}
	}

	static function headerLine(state:ChatWidgetShellState):String {
		return "Codex | model: " + state.modelLabel() + " | status: " + state.statusText();
	}

	static function footerLine(state:ChatWidgetShellState):String {
		return "status: " + ChatWidgetShellState.statusKindText(state.statusKind()) + " | rows: " + Std.string(state.transcriptCount()) + " | rev: "
			+ Std.string(state.revision());
	}

	static function composerLine(state:ChatWidgetShellState):String {
		return "input> " + state.composer().buffer();
	}

	static function composerCursorColumn(state:ChatWidgetShellState):Int {
		return "input> ".length + state.composer().cursor();
	}

	static function separatorLine(size:TerminalSize):String {
		final count = size.columns < 8 ? size.columns : 8;
		var out = "";
		for (_ in 0...count)
			out = out + "-";
		return out;
	}

	static function bodyCapacity(size:TerminalSize):Int {
		final capacity = size.rows - 5;
		return capacity < 1 ? 1 : capacity;
	}
}
