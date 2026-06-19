package codexhx.runtime.model.streamitem;

class ModelTerminalResizeReflowRequest {
	public final requestId:String;
	public final clearUiHeaderOutcome:ModelClearUiHeaderOutcome;
	public final requestKind:ModelTerminalResizeReflowRequestKind;
	public final maxRowsKind:ModelTerminalResizeReflowMaxRowsKind;
	public final maxRows:Int;
	public final terminalResizeReflowEnabled:Bool;
	public final overlayActive:Bool;
	public final terminalWidth:Int;
	public final petReservedColumns:Int;
	public final transcriptRows:Array<String>;
	public final replayRows:Array<String>;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, clearUiHeaderOutcome:ModelClearUiHeaderOutcome, requestKind:ModelTerminalResizeReflowRequestKind,
			maxRowsKind:ModelTerminalResizeReflowMaxRowsKind, maxRows:Int, terminalResizeReflowEnabled:Bool, overlayActive:Bool, terminalWidth:Int,
			petReservedColumns:Int, transcriptRows:Array<String>, replayRows:Array<String>, eventOrderIndex:Int, previousEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.clearUiHeaderOutcome = clearUiHeaderOutcome;
		this.requestKind = requestKind == null ? ModelTerminalResizeReflowRequestKind.RenderTranscript : requestKind;
		this.maxRowsKind = maxRowsKind == null ? ModelTerminalResizeReflowMaxRowsKind.Disabled : maxRowsKind;
		this.maxRows = maxRows < 0 ? 0 : maxRows;
		this.terminalResizeReflowEnabled = terminalResizeReflowEnabled;
		this.overlayActive = overlayActive;
		this.terminalWidth = terminalWidth < 1 ? 1 : terminalWidth;
		this.petReservedColumns = petReservedColumns < 0 ? 0 : petReservedColumns;
		this.transcriptRows = transcriptRows == null ? [] : transcriptRows.copy();
		this.replayRows = replayRows == null ? [] : replayRows.copy();
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
