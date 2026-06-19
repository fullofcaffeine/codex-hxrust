package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetComposerRenderActionFields = {
	final kind:TuiSmokeChatWidgetComposerRenderActionKind;
	final inputResult:TuiSmokeComposerSubmissionResultKind;
	final queuedAction:TuiSmokeComposerQueuedActionKind;
	final cursorStyle:String;
	final text:String;
	final failureCode:String;
	final width:Int;
	final height:Int;
	final rightReserve:Int;
	final bottomPaneInsetTop:Int;
	final bottomPaneDesiredHeight:Int;
	final activeCellDesiredHeight:Int;
	final activeHookDesiredHeight:Int;
	final transcriptAreaWidth:Int;
	final transcriptAreaHeight:Int;
	final transcriptScrollOffset:Int;
	final cursorX:Int;
	final cursorY:Int;
	final queuedBefore:Int;
	final queuedAfter:Int;
	final pendingSteers:Int;
	final rejectedSteers:Int;
	final queuedHistoryRecords:Int;
	final rejectedHistoryRecords:Int;
	final pendingSteerHistoryRecords:Int;
	final pendingSteerCompareKeys:Int;
	final userTurnPendingBefore:Bool;
	final userTurnPendingAfter:Bool;
	final submitPendingSteersAfterInterruptBefore:Bool;
	final submitPendingSteersAfterInterruptAfter:Bool;
	final suppressAutosendBefore:Bool;
	final suppressAutosendAfter:Bool;
	final queuedFollowUps:Bool;
	final missingHistoryFallback:Bool;
	final previewQueuedText:String;
	final previewPendingText:String;
	final previewRejectedText:String;
	final activeCellPresent:Bool;
	final activeHookPresent:Bool;
	final activeHookShouldRender:Bool;
	final cursorVisible:Bool;
	final inputEnabled:Bool;
	final taskRunning:Bool;
	final sessionConfigured:Bool;
	final planStreaming:Bool;
	final userTurnPending:Bool;
	final onlyUserShellCommandsRunning:Bool;
	final hadModalOrPopup:Bool;
	final modalCleared:Bool;
	final shouldSubmitNow:Bool;
	final previewUpdated:Bool;
	final autosendSuppressed:Bool;
	final followupSubmitted:Bool;
	final statusWorking:Bool;
	final reasoningCleared:Bool;
	final commandDispatched:Bool;
	final serviceTierDispatched:Bool;
	final slashArgsDispatched:Bool;
	final frameScheduled:Bool;
	final preDrawTick:Bool;
	final bottomPaneTick:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final noLiveDispatch:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeChatWidgetComposerRenderAction {
	public final kind:TuiSmokeChatWidgetComposerRenderActionKind;
	public final inputResult:TuiSmokeComposerSubmissionResultKind;
	public final queuedAction:TuiSmokeComposerQueuedActionKind;
	public final cursorStyle:String;
	public final text:String;
	public final failureCode:String;
	public final width:Int;
	public final height:Int;
	public final rightReserve:Int;
	public final bottomPaneInsetTop:Int;
	public final bottomPaneDesiredHeight:Int;
	public final activeCellDesiredHeight:Int;
	public final activeHookDesiredHeight:Int;
	public final transcriptAreaWidth:Int;
	public final transcriptAreaHeight:Int;
	public final transcriptScrollOffset:Int;
	public final cursorX:Int;
	public final cursorY:Int;
	public final queuedBefore:Int;
	public final queuedAfter:Int;
	public final pendingSteers:Int;
	public final rejectedSteers:Int;
	public final queuedHistoryRecords:Int;
	public final rejectedHistoryRecords:Int;
	public final pendingSteerHistoryRecords:Int;
	public final pendingSteerCompareKeys:Int;
	public final userTurnPendingBefore:Bool;
	public final userTurnPendingAfter:Bool;
	public final submitPendingSteersAfterInterruptBefore:Bool;
	public final submitPendingSteersAfterInterruptAfter:Bool;
	public final suppressAutosendBefore:Bool;
	public final suppressAutosendAfter:Bool;
	public final queuedFollowUps:Bool;
	public final missingHistoryFallback:Bool;
	public final previewQueuedText:String;
	public final previewPendingText:String;
	public final previewRejectedText:String;
	public final activeCellPresent:Bool;
	public final activeHookPresent:Bool;
	public final activeHookShouldRender:Bool;
	public final cursorVisible:Bool;
	public final inputEnabled:Bool;
	public final taskRunning:Bool;
	public final sessionConfigured:Bool;
	public final planStreaming:Bool;
	public final userTurnPending:Bool;
	public final onlyUserShellCommandsRunning:Bool;
	public final hadModalOrPopup:Bool;
	public final modalCleared:Bool;
	public final shouldSubmitNow:Bool;
	public final previewUpdated:Bool;
	public final autosendSuppressed:Bool;
	public final followupSubmitted:Bool;
	public final statusWorking:Bool;
	public final reasoningCleared:Bool;
	public final commandDispatched:Bool;
	public final serviceTierDispatched:Bool;
	public final slashArgsDispatched:Bool;
	public final frameScheduled:Bool;
	public final preDrawTick:Bool;
	public final bottomPaneTick:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final noLiveDispatch:Bool;
	public final unsupportedRejected:Bool;


	public function areaText():String {
		return width + "x" + height;
	}

	public function queueTransitionText():String {
		return queuedBefore + "->" + queuedAfter;
	}

	public function cursorText():String {
		return cursorVisible ? cursorX + "," + cursorY : "hidden";
	}
}
