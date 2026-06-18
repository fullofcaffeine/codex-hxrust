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

	public function new(fields:TuiSmokeChatWidgetComposerRenderActionFields) {
		this.kind = fields.kind == null ? TuiSmokeChatWidgetComposerRenderActionKind.Unknown : fields.kind;
		this.inputResult = fields.inputResult == null ? TuiSmokeComposerSubmissionResultKind.Unknown : fields.inputResult;
		this.queuedAction = fields.queuedAction == null ? TuiSmokeComposerQueuedActionKind.Unknown : fields.queuedAction;
		this.cursorStyle = fields.cursorStyle == null ? "" : fields.cursorStyle;
		this.text = fields.text == null ? "" : fields.text;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.width = fields.width;
		this.height = fields.height;
		this.rightReserve = fields.rightReserve;
		this.bottomPaneInsetTop = fields.bottomPaneInsetTop;
		this.bottomPaneDesiredHeight = fields.bottomPaneDesiredHeight;
		this.activeCellDesiredHeight = fields.activeCellDesiredHeight;
		this.activeHookDesiredHeight = fields.activeHookDesiredHeight;
		this.transcriptAreaWidth = fields.transcriptAreaWidth;
		this.transcriptAreaHeight = fields.transcriptAreaHeight;
		this.transcriptScrollOffset = fields.transcriptScrollOffset;
		this.cursorX = fields.cursorX;
		this.cursorY = fields.cursorY;
		this.queuedBefore = fields.queuedBefore;
		this.queuedAfter = fields.queuedAfter;
		this.pendingSteers = fields.pendingSteers;
		this.rejectedSteers = fields.rejectedSteers;
		this.activeCellPresent = fields.activeCellPresent;
		this.activeHookPresent = fields.activeHookPresent;
		this.activeHookShouldRender = fields.activeHookShouldRender;
		this.cursorVisible = fields.cursorVisible;
		this.inputEnabled = fields.inputEnabled;
		this.taskRunning = fields.taskRunning;
		this.sessionConfigured = fields.sessionConfigured;
		this.planStreaming = fields.planStreaming;
		this.userTurnPending = fields.userTurnPending;
		this.onlyUserShellCommandsRunning = fields.onlyUserShellCommandsRunning;
		this.hadModalOrPopup = fields.hadModalOrPopup;
		this.modalCleared = fields.modalCleared;
		this.shouldSubmitNow = fields.shouldSubmitNow;
		this.previewUpdated = fields.previewUpdated;
		this.autosendSuppressed = fields.autosendSuppressed;
		this.followupSubmitted = fields.followupSubmitted;
		this.statusWorking = fields.statusWorking;
		this.reasoningCleared = fields.reasoningCleared;
		this.commandDispatched = fields.commandDispatched;
		this.serviceTierDispatched = fields.serviceTierDispatched;
		this.slashArgsDispatched = fields.slashArgsDispatched;
		this.frameScheduled = fields.frameScheduled;
		this.preDrawTick = fields.preDrawTick;
		this.bottomPaneTick = fields.bottomPaneTick;
		this.noLiveTerminal = fields.noLiveTerminal;
		this.noRatatuiRender = fields.noRatatuiRender;
		this.noLiveDispatch = fields.noLiveDispatch;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

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
