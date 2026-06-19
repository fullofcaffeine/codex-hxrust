package codexhx.runtime.model.streamitem;

class ModelTerminalResizeReflowOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final clearUiHeaderRequestId:String;
	public final decisionKind:ModelTerminalResizeReflowDecisionKind;
	public final requestKind:ModelTerminalResizeReflowRequestKind;
	public final maxRowsKind:ModelTerminalResizeReflowMaxRowsKind;
	public final maxRows:Int;
	public final terminalWidth:Int;
	public final historyWrapWidth:Int;
	public final petReservedColumns:Int;
	public final transcriptCellCount:Int;
	public final renderedLines:Array<String>;
	public final retainedReplayRows:Array<String>;
	public final renderedLineCount:Int;
	public final trimmedLineCount:Int;
	public final rowCapApplied:Bool;
	public final recentSuffixOnly:Bool;
	public final allCellsRendered:Bool;
	public final petReservedWidthApplied:Bool;
	public final petWrappedEarlier:Bool;
	public final initialReplayBufferStarted:Bool;
	public final initialReplayRowsTrimmed:Bool;
	public final threadSwitchTailMode:Bool;
	public final threadSwitchBufferDisabled:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, clearUiHeaderRequestId:String, decisionKind:ModelTerminalResizeReflowDecisionKind,
			requestKind:ModelTerminalResizeReflowRequestKind, maxRowsKind:ModelTerminalResizeReflowMaxRowsKind, maxRows:Int, terminalWidth:Int,
			historyWrapWidth:Int, petReservedColumns:Int, transcriptCellCount:Int, renderedLines:Array<String>, retainedReplayRows:Array<String>,
			renderedLineCount:Int, trimmedLineCount:Int, rowCapApplied:Bool, recentSuffixOnly:Bool, allCellsRendered:Bool, petReservedWidthApplied:Bool,
			petWrappedEarlier:Bool, initialReplayBufferStarted:Bool, initialReplayRowsTrimmed:Bool, threadSwitchTailMode:Bool,
			threadSwitchBufferDisabled:Bool, eventOrderingPreserved:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code == null ? "" : code;
		this.requestId = requestId == null ? "" : requestId;
		this.clearUiHeaderRequestId = clearUiHeaderRequestId == null ? "" : clearUiHeaderRequestId;
		this.decisionKind = decisionKind == null ? ModelTerminalResizeReflowDecisionKind.UncappedAllCells : decisionKind;
		this.requestKind = requestKind == null ? ModelTerminalResizeReflowRequestKind.RenderTranscript : requestKind;
		this.maxRowsKind = maxRowsKind == null ? ModelTerminalResizeReflowMaxRowsKind.Disabled : maxRowsKind;
		this.maxRows = maxRows < 0 ? 0 : maxRows;
		this.terminalWidth = terminalWidth < 1 ? 1 : terminalWidth;
		this.historyWrapWidth = historyWrapWidth < 1 ? 1 : historyWrapWidth;
		this.petReservedColumns = petReservedColumns < 0 ? 0 : petReservedColumns;
		this.transcriptCellCount = transcriptCellCount < 0 ? 0 : transcriptCellCount;
		this.renderedLines = renderedLines == null ? [] : renderedLines.copy();
		this.retainedReplayRows = retainedReplayRows == null ? [] : retainedReplayRows.copy();
		this.renderedLineCount = renderedLineCount < 0 ? 0 : renderedLineCount;
		this.trimmedLineCount = trimmedLineCount < 0 ? 0 : trimmedLineCount;
		this.rowCapApplied = rowCapApplied;
		this.recentSuffixOnly = recentSuffixOnly;
		this.allCellsRendered = allCellsRendered;
		this.petReservedWidthApplied = petReservedWidthApplied;
		this.petWrappedEarlier = petWrappedEarlier;
		this.initialReplayBufferStarted = initialReplayBufferStarted;
		this.initialReplayRowsTrimmed = initialReplayRowsTrimmed;
		this.threadSwitchTailMode = threadSwitchTailMode;
		this.threadSwitchBufferDisabled = threadSwitchBufferDisabled;
		this.eventOrderingPreserved = eventOrderingPreserved;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";clearUiHeaderRequest=" + noneIfEmpty(clearUiHeaderRequestId)
			+ ";decisionKind=" + decisionKind + ";requestKind=" + requestKind + ";maxRowsKind=" + maxRowsKind + ";maxRows=" + maxRows + ";terminalWidth="
			+ terminalWidth + ";historyWrapWidth=" + historyWrapWidth + ";petReservedColumns=" + petReservedColumns + ";transcriptCellCount="
			+ transcriptCellCount + ";renderedLineCount=" + renderedLineCount + ";trimmedLineCount=" + trimmedLineCount + ";renderedLines="
			+ lineSummary(renderedLines) + ";retainedReplayRows=" + lineSummary(retainedReplayRows) + ";rowCapApplied=" + boolText(rowCapApplied)
			+ ";recentSuffixOnly=" + boolText(recentSuffixOnly) + ";allCellsRendered=" + boolText(allCellsRendered) + ";petReservedWidthApplied="
			+ boolText(petReservedWidthApplied) + ";petWrappedEarlier=" + boolText(petWrappedEarlier) + ";initialReplayBufferStarted="
			+ boolText(initialReplayBufferStarted) + ";initialReplayRowsTrimmed=" + boolText(initialReplayRowsTrimmed) + ";threadSwitchTailMode="
			+ boolText(threadSwitchTailMode) + ";threadSwitchBufferDisabled=" + boolText(threadSwitchBufferDisabled) + ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function lineSummary(lines:Array<String>):String {
		if (lines == null || lines.length == 0)
			return "none";
		return lines.join("|");
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
