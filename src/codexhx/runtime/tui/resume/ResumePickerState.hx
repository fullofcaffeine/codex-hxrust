package codexhx.runtime.tui.resume;

typedef ResumePickerStateFields = {
	final opened:Bool;
	final action:ResumePickerActionKind;
	final commandCount:Int;
	final pickerOpenCount:Int;
	final unknownCount:Int;
	final failureCount:Int;
	final staleIngests:Int;
	final requestToken:Int;
	final searchToken:Int;
	final query:String;
	final nextCursor:String;
	final cwdFilter:String;
	final showAll:Bool;
	final includeNonInteractive:Bool;
	final remoteWorkspace:Bool;
	final altScreenEntered:Bool;
	final altScreenExited:Bool;
	final searchActive:Bool;
	final sortKey:ResumePickerSortKey;
	final filterMode:ResumePickerFilterMode;
	final density:ResumePickerDensity;
	final toolbarFocus:ResumePickerToolbarFocus;
	final toolbarRenderMode:String;
	final scannedRows:Int;
	final acceptedRows:Int;
	final invalidRows:Int;
	final loadedRows:Int;
	final filteredRows:Int;
	final selectedIndex:Int;
	final scrollTop:Int;
	final viewRows:Int;
	final pageSize:Int;
	final nextCursorPresent:Bool;
	final reachedScanCap:Bool;
	final pendingPageDownCompleted:Bool;
	final expandedThreadId:String;
	final previewState:String;
	final previewRendered:Bool;
	final previewLineCount:Int;
	final previewUserLineCount:Int;
	final previewAssistantLineCount:Int;
	final pendingThreadId:String;
	final transcriptState:String;
	final transcriptLoadingFrameShown:Bool;
	final transcriptCellCount:Int;
	final transcriptUserCellCount:Int;
	final transcriptAssistantCellCount:Int;
	final transcriptPlanCellCount:Int;
	final transcriptReasoningCellCount:Int;
	final transcriptFallbackCellCount:Int;
	final transcriptCells:Array<String>;
	final overlayOpen:Bool;
	final overlayCloseCount:Int;
	final lastKeyConsumed:Bool;
	final inlineErrorShown:Bool;
	final lastError:String;
	final lastFailureCode:String;
	final configPersistenceStatus:String;
	final configPersistencePath:String;
	final selectedThreadId:String;
	final selectedLabel:String;
	final footerProgressLabel:String;
	final footerPercent:Int;
	final frozenFooterPercent:Int;
	final footerHintMode:String;
	final footerWidth:Int;
	final emptyStateMessage:String;
	final loadingOverlayMessage:String;
	final loadingPending:Bool;
	final compactFallback:Bool;
	final keyOnlyFallback:Bool;
	final moreAbove:Bool;
	final moreBelow:Bool;
	final loadingOlderShown:Bool;
	final visibleRows:Array<ResumePickerVisibleRow>;
	final effects:Array<ResumePickerEffect>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerState {
	public var opened:Bool;
	@:recordDefault(ResumePickerActionKind.Unknown)
	public var action:ResumePickerActionKind;
	public var commandCount:Int;
	public var pickerOpenCount:Int;
	public var unknownCount:Int;
	public var failureCount:Int;
	public var staleIngests:Int;
	public var requestToken:Int;
	public var searchToken:Int;
	public var query:String;
	public var nextCursor:String;
	public var cwdFilter:String;
	public var showAll:Bool;
	public var includeNonInteractive:Bool;
	public var remoteWorkspace:Bool;
	public var altScreenEntered:Bool;
	public var altScreenExited:Bool;
	public var searchActive:Bool;
	@:recordDefault(ResumePickerSortKey.Unknown)
	public var sortKey:ResumePickerSortKey;
	@:recordDefault(ResumePickerFilterMode.Unknown)
	public var filterMode:ResumePickerFilterMode;
	@:recordDefault(ResumePickerDensity.Unknown)
	public var density:ResumePickerDensity;
	@:recordDefault(ResumePickerToolbarFocus.Unknown)
	public var toolbarFocus:ResumePickerToolbarFocus;
	public var toolbarRenderMode:String;
	public var scannedRows:Int;
	public var acceptedRows:Int;
	public var invalidRows:Int;
	public var loadedRows:Int;
	public var filteredRows:Int;
	public var selectedIndex:Int;
	public var scrollTop:Int;
	public var viewRows:Int;
	public var pageSize:Int;
	public var nextCursorPresent:Bool;
	public var reachedScanCap:Bool;
	public var pendingPageDownCompleted:Bool;
	public var expandedThreadId:String;
	public var previewState:String;
	public var previewRendered:Bool;
	public var previewLineCount:Int;
	public var previewUserLineCount:Int;
	public var previewAssistantLineCount:Int;
	public var pendingThreadId:String;
	public var transcriptState:String;
	public var transcriptLoadingFrameShown:Bool;
	public var transcriptCellCount:Int;
	public var transcriptUserCellCount:Int;
	public var transcriptAssistantCellCount:Int;
	public var transcriptPlanCellCount:Int;
	public var transcriptReasoningCellCount:Int;
	public var transcriptFallbackCellCount:Int;
	public var transcriptCells:Array<String>;
	public var overlayOpen:Bool;
	public var overlayCloseCount:Int;
	public var lastKeyConsumed:Bool;
	public var inlineErrorShown:Bool;
	public var lastError:String;
	public var lastFailureCode:String;
	public var configPersistenceStatus:String;
	public var configPersistencePath:String;
	public var selectedThreadId:String;
	public var selectedLabel:String;
	public var footerProgressLabel:String;
	public var footerPercent:Int;
	public var frozenFooterPercent:Int;
	public var footerHintMode:String;
	public var footerWidth:Int;
	public var emptyStateMessage:String;
	public var loadingOverlayMessage:String;
	public var loadingPending:Bool;
	public var compactFallback:Bool;
	public var keyOnlyFallback:Bool;
	public var moreAbove:Bool;
	public var moreBelow:Bool;
	public var loadingOlderShown:Bool;
	public var visibleRows:Array<ResumePickerVisibleRow>;
	public var effects:Array<ResumePickerEffect>;

	public static function initial():ResumePickerState {
		return new ResumePickerState({
			opened: false,
			action: ResumePickerActionKind.Unknown,
			commandCount: 0,
			pickerOpenCount: 0,
			unknownCount: 0,
			failureCount: 0,
			staleIngests: 0,
			requestToken: 0,
			searchToken: 0,
			query: "",
			nextCursor: "",
			cwdFilter: "",
			showAll: false,
			includeNonInteractive: false,
			remoteWorkspace: false,
			altScreenEntered: false,
			altScreenExited: false,
			searchActive: false,
			sortKey: ResumePickerSortKey.UpdatedAt,
			filterMode: ResumePickerFilterMode.Cwd,
			density: ResumePickerDensity.Comfortable,
			toolbarFocus: ResumePickerToolbarFocus.Filter,
			toolbarRenderMode: "",
			scannedRows: 0,
			acceptedRows: 0,
			invalidRows: 0,
			loadedRows: 0,
			filteredRows: 0,
			selectedIndex: 0,
			scrollTop: 0,
			viewRows: 0,
			pageSize: 0,
			nextCursorPresent: false,
			reachedScanCap: false,
			pendingPageDownCompleted: false,
			expandedThreadId: "",
			previewState: "",
			previewRendered: false,
			previewLineCount: 0,
			previewUserLineCount: 0,
			previewAssistantLineCount: 0,
			pendingThreadId: "",
			transcriptState: "",
			transcriptLoadingFrameShown: false,
			transcriptCellCount: 0,
			transcriptUserCellCount: 0,
			transcriptAssistantCellCount: 0,
			transcriptPlanCellCount: 0,
			transcriptReasoningCellCount: 0,
			transcriptFallbackCellCount: 0,
			transcriptCells: [],
			overlayOpen: false,
			overlayCloseCount: 0,
			lastKeyConsumed: false,
			inlineErrorShown: false,
			lastError: "",
			lastFailureCode: "",
			configPersistenceStatus: "",
			configPersistencePath: "",
			selectedThreadId: "",
			selectedLabel: "",
			footerProgressLabel: "",
			footerPercent: 0,
			frozenFooterPercent: 0,
			footerHintMode: "",
			footerWidth: 0,
			emptyStateMessage: "",
			loadingOverlayMessage: "",
			loadingPending: false,
			compactFallback: false,
			keyOnlyFallback: false,
			moreAbove: false,
			moreBelow: false,
			loadingOlderShown: false,
			visibleRows: [],
			effects: []
		});
	}

	public function copy():ResumePickerState {
		return new ResumePickerState({
			opened: opened,
			action: action,
			commandCount: commandCount,
			pickerOpenCount: pickerOpenCount,
			unknownCount: unknownCount,
			failureCount: failureCount,
			staleIngests: staleIngests,
			requestToken: requestToken,
			searchToken: searchToken,
			query: query,
			nextCursor: nextCursor,
			cwdFilter: cwdFilter,
			showAll: showAll,
			includeNonInteractive: includeNonInteractive,
			remoteWorkspace: remoteWorkspace,
			altScreenEntered: altScreenEntered,
			altScreenExited: altScreenExited,
			searchActive: searchActive,
			sortKey: sortKey,
			filterMode: filterMode,
			density: density,
			toolbarFocus: toolbarFocus,
			toolbarRenderMode: toolbarRenderMode,
			scannedRows: scannedRows,
			acceptedRows: acceptedRows,
			invalidRows: invalidRows,
			loadedRows: loadedRows,
			filteredRows: filteredRows,
			selectedIndex: selectedIndex,
			scrollTop: scrollTop,
			viewRows: viewRows,
			pageSize: pageSize,
			nextCursorPresent: nextCursorPresent,
			reachedScanCap: reachedScanCap,
			pendingPageDownCompleted: pendingPageDownCompleted,
			expandedThreadId: expandedThreadId,
			previewState: previewState,
			previewRendered: previewRendered,
			previewLineCount: previewLineCount,
			previewUserLineCount: previewUserLineCount,
			previewAssistantLineCount: previewAssistantLineCount,
			pendingThreadId: pendingThreadId,
			transcriptState: transcriptState,
			transcriptLoadingFrameShown: transcriptLoadingFrameShown,
			transcriptCellCount: transcriptCellCount,
			transcriptUserCellCount: transcriptUserCellCount,
			transcriptAssistantCellCount: transcriptAssistantCellCount,
			transcriptPlanCellCount: transcriptPlanCellCount,
			transcriptReasoningCellCount: transcriptReasoningCellCount,
			transcriptFallbackCellCount: transcriptFallbackCellCount,
			transcriptCells: transcriptCells.copy(),
			overlayOpen: overlayOpen,
			overlayCloseCount: overlayCloseCount,
			lastKeyConsumed: lastKeyConsumed,
			inlineErrorShown: inlineErrorShown,
			lastError: lastError,
			lastFailureCode: lastFailureCode,
			configPersistenceStatus: configPersistenceStatus,
			configPersistencePath: configPersistencePath,
			selectedThreadId: selectedThreadId,
			selectedLabel: selectedLabel,
			footerProgressLabel: footerProgressLabel,
			footerPercent: footerPercent,
			frozenFooterPercent: frozenFooterPercent,
			footerHintMode: footerHintMode,
			footerWidth: footerWidth,
			emptyStateMessage: emptyStateMessage,
			loadingOverlayMessage: loadingOverlayMessage,
			loadingPending: loadingPending,
			compactFallback: compactFallback,
			keyOnlyFallback: keyOnlyFallback,
			moreAbove: moreAbove,
			moreBelow: moreBelow,
			loadingOlderShown: loadingOlderShown,
			visibleRows: visibleRows.copy(),
			effects: effects.copy()
		});
	}

	public function addEffect(kind:ResumePickerEffectKind, target:String, detail:String):Void {
		effects.push(new ResumePickerEffect({
			kind: kind,
			target: target,
			detail: detail
		}));
	}

	public function countEffect(kind:ResumePickerEffectKind):Int {
		var count = 0;
		for (effect in effects) {
			if (effect.kind == kind) count = count + 1;
		}
		return count;
	}

	public function summary():String {
		return "opened=" + opened
			+ ":action=" + action
			+ ":loaded=" + loadedRows
			+ ":filtered=" + filteredRows
			+ ":selected=" + selectedIndex
			+ ":scroll=" + scrollTop
			+ ":sort=" + sortKey
			+ ":filter=" + filterMode
			+ ":density=" + density
			+ ":toolbar=" + toolbarFocus
			+ ":footer=" + footerProgressLabel
			+ ":empty=" + emptyStateMessage
			+ ":pending=" + pendingThreadId
			+ ":overlay=" + overlayOpen
			+ ":effects=" + effects.length;
	}
}
