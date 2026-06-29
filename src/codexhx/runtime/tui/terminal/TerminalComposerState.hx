package codexhx.runtime.tui.terminal;

/**
	Small editable input line for the first live terminal shell.

	This intentionally stops before ChatWidget ownership. It proves the typed
	input path can mutate composer state and emit semantic effects without a
	nullable key/event record.
**/
class TerminalComposerState {
	var bufferValue:String;
	var cursorValue:Int;
	final submittedTexts:Array<String>;
	var historyIndexValue:Int;
	var exitRequestedValue:Bool;
	var exitReasonValue:TerminalExitReason;
	var drawRequestCountValue:Int;

	public function new() {
		this.bufferValue = "";
		this.cursorValue = 0;
		this.submittedTexts = [];
		this.historyIndexValue = -1;
		this.exitRequestedValue = false;
		this.exitReasonValue = TerminalExitReason.Requested;
		this.drawRequestCountValue = 0;
	}

	public function apply(input:TerminalInputEvent):Array<TerminalComposerEffect> {
		return switch input {
			case Text(value):
				insertText(value);
			case Submit:
				submit();
			case Cancel:
				requestExit(TerminalExitReason.Escape);
			case Interrupt:
				requestExit(TerminalExitReason.CtrlC);
			case DeleteBackward:
				deleteBackward();
			case MoveLeft:
				moveLeft();
			case MoveRight:
				moveRight();
			case HistoryPrevious:
				historyPrevious();
			case HistoryNext:
				historyNext();
		}
	}

	public function buffer():String {
		return bufferValue;
	}

	public function cursor():Int {
		return cursorValue;
	}

	public function submittedCount():Int {
		return submittedTexts.length;
	}

	public function submittedAt(index:Int):String {
		if (index < 0 || index >= submittedTexts.length)
			return "";
		return submittedTexts[index];
	}

	public function historyIndex():Int {
		return historyIndexValue;
	}

	public function exitRequested():Bool {
		return exitRequestedValue;
	}

	public function exitReason():TerminalExitReason {
		return exitReasonValue;
	}

	public function drawRequestCount():Int {
		return drawRequestCountValue;
	}

	function insertText(value:String):Array<TerminalComposerEffect> {
		if (exitRequestedValue || value.length == 0)
			return [];
		final before = bufferValue.substr(0, cursorValue);
		final after = bufferValue.substr(cursorValue);
		bufferValue = before + value + after;
		cursorValue = cursorValue + value.length;
		historyIndexValue = -1;
		return drawRequested();
	}

	function submit():Array<TerminalComposerEffect> {
		if (exitRequestedValue)
			return [];
		final submitted = bufferValue;
		submittedTexts.push(submitted);
		bufferValue = "";
		cursorValue = 0;
		historyIndexValue = -1;
		drawRequestCountValue = drawRequestCountValue + 1;
		return [Submitted(submitted), DrawRequested];
	}

	function deleteBackward():Array<TerminalComposerEffect> {
		if (exitRequestedValue || cursorValue <= 0)
			return [];
		final before = bufferValue.substr(0, cursorValue - 1);
		final after = bufferValue.substr(cursorValue);
		bufferValue = before + after;
		cursorValue = cursorValue - 1;
		historyIndexValue = -1;
		return drawRequested();
	}

	function moveLeft():Array<TerminalComposerEffect> {
		if (exitRequestedValue || cursorValue <= 0)
			return [];
		cursorValue = cursorValue - 1;
		return drawRequested();
	}

	function moveRight():Array<TerminalComposerEffect> {
		if (exitRequestedValue || cursorValue >= bufferValue.length)
			return [];
		cursorValue = cursorValue + 1;
		return drawRequested();
	}

	function historyPrevious():Array<TerminalComposerEffect> {
		if (exitRequestedValue || submittedTexts.length == 0)
			return [];
		if (historyIndexValue < 0)
			historyIndexValue = submittedTexts.length - 1;
		else if (historyIndexValue > 0)
			historyIndexValue = historyIndexValue - 1;
		bufferValue = submittedTexts[historyIndexValue];
		cursorValue = bufferValue.length;
		return drawRequested();
	}

	function historyNext():Array<TerminalComposerEffect> {
		if (exitRequestedValue || historyIndexValue < 0)
			return [];
		if (historyIndexValue < submittedTexts.length - 1) {
			historyIndexValue = historyIndexValue + 1;
			bufferValue = submittedTexts[historyIndexValue];
			cursorValue = bufferValue.length;
		} else {
			historyIndexValue = -1;
			bufferValue = "";
			cursorValue = 0;
		}
		return drawRequested();
	}

	function requestExit(reason:TerminalExitReason):Array<TerminalComposerEffect> {
		exitRequestedValue = true;
		exitReasonValue = reason;
		drawRequestCountValue = drawRequestCountValue + 1;
		return [ExitRequested(reason), DrawRequested];
	}

	function drawRequested():Array<TerminalComposerEffect> {
		drawRequestCountValue = drawRequestCountValue + 1;
		return [DrawRequested];
	}
}
