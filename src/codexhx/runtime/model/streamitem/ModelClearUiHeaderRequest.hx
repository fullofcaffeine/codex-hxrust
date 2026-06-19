package codexhx.runtime.model.streamitem;

class ModelClearUiHeaderRequest {
	public final requestId:String;
	public final activeShutdownOutcome:ModelActiveNonPrimaryShutdownOutcome;
	public final requestKind:ModelClearUiHeaderRequestKind;
	public final model:String;
	public final reasoningEffort:String;
	public final cwd:String;
	public final version:String;
	public final width:Int;
	public final redrawHeader:Bool;
	public final altScreenActive:Bool;
	public final viewportYBefore:Int;
	public final transcriptCellCountBefore:Int;
	public final pendingHistoryLineCountBefore:Int;
	public final staleNoticeProbe:String;
	public final staleTranscriptProbe:String;
	public final fastStatusEligible:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, activeShutdownOutcome:ModelActiveNonPrimaryShutdownOutcome, requestKind:ModelClearUiHeaderRequestKind, model:String,
			reasoningEffort:String, cwd:String, version:String, width:Int, redrawHeader:Bool, altScreenActive:Bool, viewportYBefore:Int,
			transcriptCellCountBefore:Int, pendingHistoryLineCountBefore:Int, staleNoticeProbe:String, staleTranscriptProbe:String, fastStatusEligible:Bool,
			eventOrderIndex:Int, previousEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.activeShutdownOutcome = activeShutdownOutcome;
		this.requestKind = requestKind == null ? ModelClearUiHeaderRequestKind.SlashClear : requestKind;
		this.model = model == null ? "" : model;
		this.reasoningEffort = reasoningEffort == null ? "" : reasoningEffort;
		this.cwd = cwd == null ? "" : cwd;
		this.version = version == null ? "" : version;
		this.width = width < 0 ? 0 : width;
		this.redrawHeader = redrawHeader;
		this.altScreenActive = altScreenActive;
		this.viewportYBefore = viewportYBefore < 0 ? 0 : viewportYBefore;
		this.transcriptCellCountBefore = transcriptCellCountBefore < 0 ? 0 : transcriptCellCountBefore;
		this.pendingHistoryLineCountBefore = pendingHistoryLineCountBefore < 0 ? 0 : pendingHistoryLineCountBefore;
		this.staleNoticeProbe = staleNoticeProbe == null ? "" : staleNoticeProbe;
		this.staleTranscriptProbe = staleTranscriptProbe == null ? "" : staleTranscriptProbe;
		this.fastStatusEligible = fastStatusEligible;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
