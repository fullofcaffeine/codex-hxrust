package codexhx.runtime.model.streamitem;

class ModelTerminalResizeReflowPolicy {
	public static function apply(request:ModelTerminalResizeReflowRequest):ModelTerminalResizeReflowOutcome {
		if (request == null) return failure("", "", "missing terminal resize reflow request");
		final clearUiHeaderRequestId = request.clearUiHeaderOutcome == null ? "" : request.clearUiHeaderOutcome.requestId;
		if (request.clearUiHeaderOutcome == null) return failure(request.requestId, "", "missing clear UI header outcome");
		if (!request.clearUiHeaderOutcome.ok) return failure(request.requestId, clearUiHeaderRequestId, "clear UI header outcome was not successful");

		final historyWrapWidth = wrapWidth(request.terminalWidth, request.petReservedColumns);
		final renderedLines = renderTranscriptRows(request.transcriptRows, historyWrapWidth, request.maxRowsKind, request.maxRows);
		final fullRenderedLines = renderTranscriptRows(request.transcriptRows, historyWrapWidth, ModelTerminalResizeReflowMaxRowsKind.Disabled, 0);
		final noPetLines = renderTranscriptRows(request.transcriptRows, request.terminalWidth, ModelTerminalResizeReflowMaxRowsKind.Disabled, 0);
		final retainedReplayRows = retainedRows(request.replayRows, request.maxRowsKind, request.maxRows);
		final trimmedLineCount = fullRenderedLines.length > renderedLines.length ? fullRenderedLines.length - renderedLines.length : 0;
		final rowCapApplied = request.maxRowsKind == ModelTerminalResizeReflowMaxRowsKind.Limit;
		final recentSuffixOnly = rowCapApplied && trimmedLineCount > 0;
		final allCellsRendered = !recentSuffixOnly;
		final initialReplayBufferStarted = request.requestKind == ModelTerminalResizeReflowRequestKind.InitialReplayBuffer
			&& request.terminalResizeReflowEnabled
			&& !request.overlayActive;
		final threadSwitchTailMode = request.requestKind == ModelTerminalResizeReflowRequestKind.ThreadSwitchReplayBuffer
			&& request.terminalResizeReflowEnabled
			&& rowCapApplied
			&& !request.overlayActive;
		final threadSwitchBufferDisabled = request.requestKind == ModelTerminalResizeReflowRequestKind.ThreadSwitchReplayBuffer && !threadSwitchTailMode;
		final petReservedWidthApplied = request.petReservedColumns > 0 && historyWrapWidth < request.terminalWidth;
		final petWrappedEarlier = petReservedWidthApplied && renderedLines.length > noPetLines.length;
		final ordered = request.clearUiHeaderOutcome.eventOrderingPreserved && request.eventOrderIndex == request.previousEventCount + 1;

		return new ModelTerminalResizeReflowOutcome(
			true,
			"terminal_resize_reflow_modeled",
			request.requestId,
			clearUiHeaderRequestId,
			decisionKind(request, recentSuffixOnly, allCellsRendered, petWrappedEarlier, initialReplayBufferStarted, threadSwitchTailMode, threadSwitchBufferDisabled),
			request.requestKind,
			request.maxRowsKind,
			request.maxRows,
			request.terminalWidth,
			historyWrapWidth,
			request.petReservedColumns,
			request.transcriptRows.length,
			renderedLines,
			retainedReplayRows,
			renderedLines.length,
			trimmedLineCount,
			rowCapApplied,
			recentSuffixOnly,
			allCellsRendered,
			petReservedWidthApplied,
			petWrappedEarlier,
			initialReplayBufferStarted,
			initialReplayBufferStarted && request.replayRows.length > retainedReplayRows.length,
			threadSwitchTailMode,
			threadSwitchBufferDisabled,
			ordered,
			request.clearUiHeaderOutcome.liveNetworkAttempted,
			request.clearUiHeaderOutcome.realFilesystemMutated,
			request.clearUiHeaderOutcome.toolExecutedOutsideFixture,
			""
		);
	}

	static function decisionKind(
		request:ModelTerminalResizeReflowRequest,
		recentSuffixOnly:Bool,
		allCellsRendered:Bool,
		petWrappedEarlier:Bool,
		initialReplayBufferStarted:Bool,
		threadSwitchTailMode:Bool,
		threadSwitchBufferDisabled:Bool
	):ModelTerminalResizeReflowDecisionKind {
		if (initialReplayBufferStarted) return ModelTerminalResizeReflowDecisionKind.InitialReplayBufferTail;
		if (threadSwitchTailMode) return ModelTerminalResizeReflowDecisionKind.ThreadSwitchTailMode;
		if (threadSwitchBufferDisabled) return ModelTerminalResizeReflowDecisionKind.ThreadSwitchBufferDisabled;
		if (petWrappedEarlier) return ModelTerminalResizeReflowDecisionKind.PetWrappedEarlier;
		if (recentSuffixOnly) return ModelTerminalResizeReflowDecisionKind.CappedRecentSuffix;
		if (allCellsRendered && request.maxRowsKind == ModelTerminalResizeReflowMaxRowsKind.Limit) return ModelTerminalResizeReflowDecisionKind.UnderLimitAllCells;
		return ModelTerminalResizeReflowDecisionKind.UncappedAllCells;
	}

	static function renderTranscriptRows(
		transcriptRows:Array<String>,
		width:Int,
		maxRowsKind:ModelTerminalResizeReflowMaxRowsKind,
		maxRows:Int
	):Array<String> {
		final full:Array<String> = [];
		if (transcriptRows != null) {
			for (index in 0...transcriptRows.length) {
				if (index > 0) full.push("");
				final wrapped = wrapLine(transcriptRows[index], width);
				for (line in wrapped) full.push(line);
			}
		}
		return retainedRows(full, maxRowsKind, maxRows);
	}

	static function retainedRows(rows:Array<String>, maxRowsKind:ModelTerminalResizeReflowMaxRowsKind, maxRows:Int):Array<String> {
		final out:Array<String> = [];
		if (rows == null) return out;
		final cap = maxRows < 0 ? 0 : maxRows;
		final start = maxRowsKind == ModelTerminalResizeReflowMaxRowsKind.Limit && rows.length > cap ? rows.length - cap : 0;
		for (index in start...rows.length) out.push(rows[index] == null ? "" : rows[index]);
		return out;
	}

	static function wrapLine(text:String, width:Int):Array<String> {
		final safeText = text == null ? "" : text;
		final safeWidth = width < 1 ? 1 : width;
		final words = safeText.split(" ");
		final lines:Array<String> = [];
		var current = "";
		for (word in words) {
			if (current.length == 0) {
				current = word;
			} else if (current.length + 1 + word.length <= safeWidth) {
				current = current + " " + word;
			} else {
				lines.push(current);
				current = word;
			}
		}
		if (current.length > 0 || safeText.length == 0) lines.push(current);
		return lines;
	}

	static function wrapWidth(terminalWidth:Int, petReservedColumns:Int):Int {
		final width = terminalWidth - petReservedColumns;
		return width < 1 ? 1 : width;
	}

	static function failure(requestId:String, clearUiHeaderRequestId:String, errorMessage:String):ModelTerminalResizeReflowOutcome {
		return new ModelTerminalResizeReflowOutcome(
			false,
			"terminal_resize_reflow_failed",
			requestId,
			clearUiHeaderRequestId,
			ModelTerminalResizeReflowDecisionKind.UncappedAllCells,
			ModelTerminalResizeReflowRequestKind.RenderTranscript,
			ModelTerminalResizeReflowMaxRowsKind.Disabled,
			0,
			1,
			1,
			0,
			0,
			[],
			[],
			0,
			0,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			false,
			errorMessage
		);
	}
}
