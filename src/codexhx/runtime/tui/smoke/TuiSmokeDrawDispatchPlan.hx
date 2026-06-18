package codexhx.runtime.tui.smoke;

typedef TuiSmokeDrawDispatchPlanFields = {
	final allowLiveDispatch:Bool;
	final event:TuiSmokeDrawDispatchEventKind;
	final renderMode:TuiSmokeDrawDispatchRenderMode;
	final resizeReflowEnabled:Bool;
	final preRender:Bool;
	final sizeChanged:Bool;
	final statusRefresh:Bool;
	final clearPendingHistory:Bool;
	final reflowDue:Bool;
	final reflowRan:Bool;
	final rearmDelayMs:Int;
	final overlayActive:Bool;
	final overlayHandled:Bool;
	final backtrackRenderPending:Bool;
	final backtrackRebuilt:Bool;
	final pendingNotification:Bool;
	final pasteBurstFlushed:Bool;
	final pasteBurstCapturing:Bool;
	final pasteBurstSkippedFrame:Bool;
	final pasteBurstFollowupMs:Int;
	final preDrawTick:Bool;
	final desiredHeight:Int;
	final renderedWidth:Int;
	final renderedHeight:Int;
	final cursorSet:Bool;
	final ambientPetDraw:Bool;
	final petPreviewDraw:Bool;
	final petPreviewClear:Bool;
	final externalEditorLaunch:Bool;
	final followUpFrame:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeDrawDispatchPlan {
	public final allowLiveDispatch:Bool;
	public final event:TuiSmokeDrawDispatchEventKind;
	public final renderMode:TuiSmokeDrawDispatchRenderMode;
	public final resizeReflowEnabled:Bool;
	public final preRender:Bool;
	public final sizeChanged:Bool;
	public final statusRefresh:Bool;
	public final clearPendingHistory:Bool;
	public final reflowDue:Bool;
	public final reflowRan:Bool;
	public final rearmDelayMs:Int;
	public final overlayActive:Bool;
	public final overlayHandled:Bool;
	public final backtrackRenderPending:Bool;
	public final backtrackRebuilt:Bool;
	public final pendingNotification:Bool;
	public final pasteBurstFlushed:Bool;
	public final pasteBurstCapturing:Bool;
	public final pasteBurstSkippedFrame:Bool;
	public final pasteBurstFollowupMs:Int;
	public final preDrawTick:Bool;
	public final desiredHeight:Int;
	public final renderedWidth:Int;
	public final renderedHeight:Int;
	public final cursorSet:Bool;
	public final ambientPetDraw:Bool;
	public final petPreviewDraw:Bool;
	public final petPreviewClear:Bool;
	public final externalEditorLaunch:Bool;
	public final followUpFrame:Bool;
	public final failureCode:String;


	public function enabled():Bool {
		return !allowLiveDispatch
			&& event != TuiSmokeDrawDispatchEventKind.Unknown
			&& renderMode != TuiSmokeDrawDispatchRenderMode.Unknown;
	}

	public function renderedAreaText():String {
		if (renderedWidth <= 0 || renderedHeight <= 0) return "none";
		return renderedWidth + "x" + renderedHeight;
	}
}
