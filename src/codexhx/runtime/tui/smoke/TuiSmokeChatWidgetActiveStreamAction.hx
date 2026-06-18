package codexhx.runtime.tui.smoke;

typedef TuiSmokeChatWidgetActiveStreamActionFields = {
	final kind:TuiSmokeChatWidgetActiveStreamActionKind;
	final renderMode:String;
	final scrollbackReflow:String;
	final text:String;
	final failureCode:String;
	final width:Int;
	final previousWidth:Int;
	final streamReservedCols:Int;
	final planReservedCols:Int;
	final streamWidth:Int;
	final planStreamWidth:Int;
	final queuedLinesBefore:Int;
	final queuedLinesAfter:Int;
	final committedCells:Int;
	final revisionBefore:Int;
	final revisionAfter:Int;
	final animationTick:Int;
	final transcriptLineCount:Int;
	final hyperlinkLineCount:Int;
	final planBufferLength:Int;
	final activeCellPresent:Bool;
	final activeHookPresent:Bool;
	final streamControllerPresent:Bool;
	final planStreamControllerPresent:Bool;
	final pushed:Bool;
	final startedCommitAnimation:Bool;
	final ranCatchUpTick:Bool;
	final statusHidden:Bool;
	final statusRestorePending:Bool;
	final statusRestored:Bool;
	final activeTailPresent:Bool;
	final liveTailPresent:Bool;
	final activeTailCleared:Bool;
	final sourceConsolidated:Bool;
	final historyInserted:Bool;
	final deferredHistoryCell:Bool;
	final requestRedraw:Bool;
	final noLiveTerminal:Bool;
	final noRatatuiRender:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

class TuiSmokeChatWidgetActiveStreamAction {
	public final kind:TuiSmokeChatWidgetActiveStreamActionKind;
	public final renderMode:String;
	public final scrollbackReflow:String;
	public final text:String;
	public final failureCode:String;
	public final width:Int;
	public final previousWidth:Int;
	public final streamReservedCols:Int;
	public final planReservedCols:Int;
	public final streamWidth:Int;
	public final planStreamWidth:Int;
	public final queuedLinesBefore:Int;
	public final queuedLinesAfter:Int;
	public final committedCells:Int;
	public final revisionBefore:Int;
	public final revisionAfter:Int;
	public final animationTick:Int;
	public final transcriptLineCount:Int;
	public final hyperlinkLineCount:Int;
	public final planBufferLength:Int;
	public final activeCellPresent:Bool;
	public final activeHookPresent:Bool;
	public final streamControllerPresent:Bool;
	public final planStreamControllerPresent:Bool;
	public final pushed:Bool;
	public final startedCommitAnimation:Bool;
	public final ranCatchUpTick:Bool;
	public final statusHidden:Bool;
	public final statusRestorePending:Bool;
	public final statusRestored:Bool;
	public final activeTailPresent:Bool;
	public final liveTailPresent:Bool;
	public final activeTailCleared:Bool;
	public final sourceConsolidated:Bool;
	public final historyInserted:Bool;
	public final deferredHistoryCell:Bool;
	public final requestRedraw:Bool;
	public final noLiveTerminal:Bool;
	public final noRatatuiRender:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;

	public function new(fields:TuiSmokeChatWidgetActiveStreamActionFields) {
		this.kind = fields.kind == null ? TuiSmokeChatWidgetActiveStreamActionKind.Unknown : fields.kind;
		this.renderMode = fields.renderMode == null ? "" : fields.renderMode;
		this.scrollbackReflow = fields.scrollbackReflow == null ? "" : fields.scrollbackReflow;
		this.text = fields.text == null ? "" : fields.text;
		this.failureCode = fields.failureCode == null ? "" : fields.failureCode;
		this.width = fields.width;
		this.previousWidth = fields.previousWidth;
		this.streamReservedCols = fields.streamReservedCols;
		this.planReservedCols = fields.planReservedCols;
		this.streamWidth = fields.streamWidth;
		this.planStreamWidth = fields.planStreamWidth;
		this.queuedLinesBefore = fields.queuedLinesBefore;
		this.queuedLinesAfter = fields.queuedLinesAfter;
		this.committedCells = fields.committedCells;
		this.revisionBefore = fields.revisionBefore;
		this.revisionAfter = fields.revisionAfter;
		this.animationTick = fields.animationTick;
		this.transcriptLineCount = fields.transcriptLineCount;
		this.hyperlinkLineCount = fields.hyperlinkLineCount;
		this.planBufferLength = fields.planBufferLength;
		this.activeCellPresent = fields.activeCellPresent;
		this.activeHookPresent = fields.activeHookPresent;
		this.streamControllerPresent = fields.streamControllerPresent;
		this.planStreamControllerPresent = fields.planStreamControllerPresent;
		this.pushed = fields.pushed;
		this.startedCommitAnimation = fields.startedCommitAnimation;
		this.ranCatchUpTick = fields.ranCatchUpTick;
		this.statusHidden = fields.statusHidden;
		this.statusRestorePending = fields.statusRestorePending;
		this.statusRestored = fields.statusRestored;
		this.activeTailPresent = fields.activeTailPresent;
		this.liveTailPresent = fields.liveTailPresent;
		this.activeTailCleared = fields.activeTailCleared;
		this.sourceConsolidated = fields.sourceConsolidated;
		this.historyInserted = fields.historyInserted;
		this.deferredHistoryCell = fields.deferredHistoryCell;
		this.requestRedraw = fields.requestRedraw;
		this.noLiveTerminal = fields.noLiveTerminal;
		this.noRatatuiRender = fields.noRatatuiRender;
		this.noModelCall = fields.noModelCall;
		this.unsupportedRejected = fields.unsupportedRejected;
	}

	public function streamQueueText():String {
		return queuedLinesBefore + "->" + queuedLinesAfter;
	}

	public function revisionText():String {
		return revisionBefore + "->" + revisionAfter;
	}
}
