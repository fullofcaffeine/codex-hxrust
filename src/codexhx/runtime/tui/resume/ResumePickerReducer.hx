package codexhx.runtime.tui.resume;

class ResumePickerReducer {
	public static function run(commands:Array<ResumePickerCommand>, planCount:Int):ResumePickerKernelReport {
		var state = ResumePickerState.initial();
		for (command in commands) {
			state = apply(state, command);
		}
		return new ResumePickerKernelReport(planCount, state);
	}

	public static function apply(state:ResumePickerState, command:ResumePickerCommand):ResumePickerState {
		if (command == null) return state;
		final next = state.copy();
		next.commandCount = next.commandCount + 1;

		switch command.kind {
			case ResumePickerCommandKind.PickerOpen:
				next.opened = true;
				next.action = command.action;
				next.showAll = command.showAll;
				next.includeNonInteractive = command.includeNonInteractive;
				next.remoteWorkspace = command.remoteWorkspace;
				next.altScreenEntered = command.altScreenEntered;
				next.pickerOpenCount = next.pickerOpenCount + 1;
			case ResumePickerCommandKind.PageRequest:
				next.requestToken = command.requestToken;
				next.searchToken = command.searchToken;
				next.query = command.query;
				next.nextCursor = command.cursor;
				next.cwdFilter = command.cwdFilter;
				next.showAll = command.showAll;
				next.sortKey = command.sortKey;
				next.searchActive = command.searchActive;
				next.addEffect(ResumePickerEffectKind.RequestPage, command.cursor, command.query);
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.PageIngest:
				if (command.staleIgnored) {
					next.staleIngests = next.staleIngests + 1;
				} else {
					next.scannedRows = next.scannedRows + command.scannedRows;
					next.acceptedRows = next.acceptedRows + command.acceptedRows;
					next.invalidRows = next.invalidRows + command.invalidRows;
					next.loadedRows = command.loadedRows;
					next.filteredRows = command.filteredRows;
					next.nextCursor = command.nextCursor;
					next.nextCursorPresent = command.nextCursorPresent;
					next.reachedScanCap = command.reachedScanCap;
					next.pendingPageDownCompleted = command.pendingPageDownCompleted;
				}
			case ResumePickerCommandKind.SearchContinue:
				next.searchToken = command.searchToken;
				next.query = command.query;
				next.filteredRows = command.filteredRows;
				next.nextCursorPresent = command.nextCursorPresent;
				next.reachedScanCap = command.reachedScanCap;
				next.searchActive = command.searchActive;
				if (command.lookupRequested) next.addEffect(ResumePickerEffectKind.RequestPage, command.nextCursor, command.query);
			case ResumePickerCommandKind.SortToggle:
				next.sortKey = command.sortKeyAfter;
				next.loadedRows = command.loadedRows;
				next.filteredRows = command.filteredRows;
				if (command.lookupRequested) next.addEffect(ResumePickerEffectKind.ResetPage, "sort", Std.string(command.sortKeyAfter));
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.FilterToggle:
				next.filterMode = command.filterModeAfter;
				next.cwdFilter = command.cwdFilter;
				next.showAll = command.showAll;
				if (command.lookupRequested) next.addEffect(ResumePickerEffectKind.ResetPage, "filter", Std.string(command.filterModeAfter));
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.PreviewToggle:
				next.selectedIndex = command.selectedIndex;
				next.expandedThreadId = command.expandedThreadId;
				next.previewState = command.previewCacheAfter;
				if (command.cacheInserted) next.addEffect(ResumePickerEffectKind.RequestPreview, command.threadId, "toggle");
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.PreviewRequest:
				if (command.includeTurns && command.threadReadRequested && command.appServerStarted) {
					next.addEffect(ResumePickerEffectKind.RequestPreview, command.threadId, "thread_read");
				}
			case ResumePickerCommandKind.PreviewComplete:
				next.previewState = command.previewCacheAfter;
				next.previewLineCount = command.previewLineCount;
				next.previewUserLineCount = command.userLineCount;
				next.previewAssistantLineCount = command.assistantLineCount;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.PreviewRender:
				next.previewRendered = command.previewRendered;
				next.previewLineCount = command.previewLineCount;
			case ResumePickerCommandKind.TranscriptOpen:
				next.selectedIndex = command.selectedIndex;
				next.pendingThreadId = command.pendingThreadId;
				next.transcriptState = command.transcriptCacheAfter;
				next.transcriptLoadingFrameShown = command.loadingFrameShown;
				if (command.transcriptCacheAfter == "loading") next.addEffect(ResumePickerEffectKind.RequestTranscript, command.threadId, "open");
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.TranscriptRequest:
				if (command.includeTurns && command.threadReadRequested && command.appServerStarted) {
					next.addEffect(ResumePickerEffectKind.RequestTranscript, command.threadId, "thread_read");
				}
			case ResumePickerCommandKind.TranscriptLoadingFrame:
				next.pendingThreadId = command.pendingThreadId;
				next.transcriptLoadingFrameShown = command.loadingFrameShown;
				next.overlayOpen = command.overlayOpened;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.TranscriptComplete:
				next.transcriptState = command.transcriptCacheAfter;
				next.transcriptCellCount = command.transcriptCellCount;
				next.transcriptUserCellCount = command.userLineCount;
				next.transcriptAssistantCellCount = command.assistantLineCount;
				next.transcriptPlanCellCount = command.planCellCount;
				next.transcriptReasoningCellCount = command.reasoningCellCount;
				next.transcriptFallbackCellCount = command.fallbackCellCount;
				next.pendingThreadId = command.pendingThreadId;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.TranscriptOverlayOpen:
				next.pendingThreadId = command.pendingThreadId;
				next.transcriptState = command.transcriptState;
				next.overlayOpen = command.overlayOpened;
				next.transcriptCellCount = command.transcriptCellCount;
				if (command.overlayOpened) next.addEffect(ResumePickerEffectKind.OpenTranscriptOverlay, command.threadId, Std.string(command.transcriptCellCount));
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.KeyboardMove:
				next.selectedIndex = command.selectedAfter;
				next.scrollTop = command.scrollTopAfter;
				next.viewRows = command.viewRows;
				next.loadedRows = command.loadedRows;
				if (command.loadMoreRequested) next.addEffect(ResumePickerEffectKind.LoadMore, command.nextCursor, command.keyName);
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.QueryClear:
				next.query = command.queryAfter;
				next.selectedIndex = command.selectedAfter;
				if (command.startFresh) next.addEffect(ResumePickerEffectKind.StartFresh, "query", command.keyName);
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.LoadMoreTrigger:
				if (command.loadMoreRequested) next.addEffect(ResumePickerEffectKind.LoadMore, command.nextCursor, command.keyName);
				next.searchActive = command.searchActive;
				next.selectedIndex = command.selectedAfter;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.TranscriptLoadingKey:
				next.pendingThreadId = command.pendingThreadId;
				next.lastKeyConsumed = command.keyConsumed;
				next.altScreenExited = command.altScreenExited;
			case ResumePickerCommandKind.OverlayClose:
				next.overlayOpen = command.overlayClosed;
				next.overlayCloseCount = next.overlayCloseCount + 1;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.MetadataFailure:
				next.inlineErrorShown = true;
				next.lastError = command.errorMessage;
				next.addEffect(ResumePickerEffectKind.SurfaceError, command.targetPath, command.errorMessage);
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.DensityToggle:
				next.density = command.densityAfter;
				next.inlineErrorShown = command.inlineErrorShown;
				if (command.persistenceAttempted) next.addEffect(ResumePickerEffectKind.PersistDensity, Std.string(command.densityAfter), command.persistenceSucceeded ? "ok" : "failed");
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.ToolbarFocus:
				next.toolbarFocus = command.toolbarFocusAfter;
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.ToolbarActivate:
				next.toolbarFocus = command.toolbarFocusBefore;
				next.sortKey = command.sortKeyAfter;
				next.filterMode = command.filterModeAfter;
				next.cwdFilter = command.cwdFilter;
				next.showAll = command.showAll;
				if (command.lookupRequested) next.addEffect(ResumePickerEffectKind.ResetPage, Std.string(command.toolbarFocusBefore), command.keyName);
				addFrameIfRequested(next, command);
			case ResumePickerCommandKind.ToolbarRender:
				next.toolbarFocus = command.toolbarFocusAfter;
				next.sortKey = command.sortKey;
				next.filterMode = command.filterModeAfter;
				next.toolbarRenderMode = command.toolbarRenderMode;
			case ResumePickerCommandKind.FooterProgress:
				next.footerProgressLabel = command.footerProgressLabel;
				next.footerPercent = command.footerPercent;
				next.frozenFooterPercent = command.frozenFooterPercent;
				next.loadingPending = command.loadingPending;
				next.footerWidth = command.footerWidth;
			case ResumePickerCommandKind.FooterHints:
				next.footerHintMode = command.footerHintMode;
				next.query = command.query;
				next.loadingPending = command.loadingPending;
				next.compactFallback = command.compactFallback;
				next.keyOnlyFallback = command.keyOnlyFallback;
				next.footerWidth = command.footerWidth;
			case ResumePickerCommandKind.ListRenderState:
				next.moreAbove = command.moreAbove;
				next.moreBelow = command.moreBelow;
				next.loadingPending = command.loadingPending;
				next.loadingOlderShown = command.loadingOlderShown;
				next.loadedRows = command.loadedRows;
				next.viewRows = command.viewRows;
			case ResumePickerCommandKind.EmptyState:
				next.emptyStateMessage = command.emptyStateMessage;
				next.query = command.query;
				next.searchActive = command.searchActive;
				next.loadingPending = command.loadingPending;
				next.reachedScanCap = command.reachedScanCap;
				next.scannedRows = command.scannedRows;
			case ResumePickerCommandKind.TranscriptLoadingOverlay:
				next.loadingOverlayMessage = command.loadingOverlayMessage;
				next.pendingThreadId = command.pendingThreadId;
				next.transcriptLoadingFrameShown = command.loadingFrameShown;
			case ResumePickerCommandKind.Selection:
				next.action = command.action;
				next.selectedThreadId = command.threadId;
				next.selectedLabel = command.targetLabel;
				next.loadedRows = command.loadedRows;
				next.pageSize = command.pageSize;
				next.altScreenExited = command.altScreenExited;
			case ResumePickerCommandKind.Failure:
				next.failureCount = next.failureCount + 1;
				next.lastFailureCode = command.failureCode;
				next.lastError = command.errorMessage;
				if (command.unsupportedRejected) next.addEffect(ResumePickerEffectKind.SurfaceError, command.failureCode, command.errorMessage);
			case ResumePickerCommandKind.Other:
				// Non-picker resume/fork lifecycle actions are intentionally outside this pure picker kernel.
			case ResumePickerCommandKind.Unknown:
				next.unknownCount = next.unknownCount + 1;
		}

		return next;
	}

	static function addFrameIfRequested(state:ResumePickerState, command:ResumePickerCommand):Void {
		if (command.frameScheduled) {
			state.addEffect(ResumePickerEffectKind.RequestFrame, Std.string(command.kind), command.keyName);
		}
	}
}
