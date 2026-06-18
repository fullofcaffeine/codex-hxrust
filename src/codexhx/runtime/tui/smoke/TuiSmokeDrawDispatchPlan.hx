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

	public function new(fields:TuiSmokeDrawDispatchPlanFields) {
		this.allowLiveDispatch = fields.allowLiveDispatch;
		this.event = fields.event == null ? TuiSmokeDrawDispatchEventKind.Unknown : fields.event;
		this.renderMode = fields.renderMode == null ? TuiSmokeDrawDispatchRenderMode.Unknown : fields.renderMode;
		this.resizeReflowEnabled = fields.resizeReflowEnabled;
		this.preRender = fields.preRender;
		this.sizeChanged = fields.sizeChanged;
		this.statusRefresh = fields.statusRefresh;
		this.clearPendingHistory = fields.clearPendingHistory;
		this.reflowDue = fields.reflowDue;
		this.reflowRan = fields.reflowRan;
		this.rearmDelayMs = fields.rearmDelayMs;
		this.overlayActive = fields.overlayActive;
		this.overlayHandled = fields.overlayHandled;
		this.backtrackRenderPending = fields.backtrackRenderPending;
		this.backtrackRebuilt = fields.backtrackRebuilt;
		this.pendingNotification = fields.pendingNotification;
		this.pasteBurstFlushed = fields.pasteBurstFlushed;
		this.pasteBurstCapturing = fields.pasteBurstCapturing;
		this.pasteBurstSkippedFrame = fields.pasteBurstSkippedFrame;
		this.pasteBurstFollowupMs = fields.pasteBurstFollowupMs;
		this.preDrawTick = fields.preDrawTick;
		this.desiredHeight = fields.desiredHeight;
		this.renderedWidth = fields.renderedWidth;
		this.renderedHeight = fields.renderedHeight;
		this.cursorSet = fields.cursorSet;
		this.ambientPetDraw = fields.ambientPetDraw;
		this.petPreviewDraw = fields.petPreviewDraw;
		this.petPreviewClear = fields.petPreviewClear;
		this.externalEditorLaunch = fields.externalEditorLaunch;
		this.followUpFrame = fields.followUpFrame;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
	}

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
