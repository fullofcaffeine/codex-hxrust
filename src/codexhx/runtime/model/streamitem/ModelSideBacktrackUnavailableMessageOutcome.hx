package codexhx.runtime.model.streamitem;

typedef ModelSideBacktrackUnavailableMessageOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelSideBacktrackUnavailableMessageDecisionKind;
	final backtrackPrimedAfter:Bool;
	final backtrackReset:Bool;
	final errorHistoryCellInserted:Bool;
	final insertHistoryCellIntentRecorded:Bool;
	final renderedLine:String;
	final snapshotNamePreserved:Bool;
	final widthStableSnapshot:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelSideBacktrackUnavailableMessageOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelSideBacktrackUnavailableMessageDecisionKind;
	public final backtrackPrimedAfter:Bool;
	public final backtrackReset:Bool;
	public final errorHistoryCellInserted:Bool;
	public final insertHistoryCellIntentRecorded:Bool;
	public final renderedLine:String;
	public final snapshotNamePreserved:Bool;
	public final widthStableSnapshot:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelSideBacktrackUnavailableMessageOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelSideBacktrackUnavailableMessageDecisionKind.SideBacktrackUnavailableMessageUnavailable : fields.decisionKind;
		this.backtrackPrimedAfter = fields.backtrackPrimedAfter;
		this.backtrackReset = fields.backtrackReset;
		this.errorHistoryCellInserted = fields.errorHistoryCellInserted;
		this.insertHistoryCellIntentRecorded = fields.insertHistoryCellIntentRecorded;
		this.renderedLine = fields.renderedLine == null ? "" : fields.renderedLine;
		this.snapshotNamePreserved = fields.snapshotNamePreserved;
		this.widthStableSnapshot = fields.widthStableSnapshot;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";decisionKind=" + decisionKind
			+ ";backtrackPrimedAfter=" + boolText(backtrackPrimedAfter)
			+ ";backtrackReset=" + boolText(backtrackReset)
			+ ";errorHistoryCellInserted=" + boolText(errorHistoryCellInserted)
			+ ";insertHistoryCellIntentRecorded=" + boolText(insertHistoryCellIntentRecorded)
			+ ";snapshotNamePreserved=" + boolText(snapshotNamePreserved)
			+ ";widthStableSnapshot=" + boolText(widthStableSnapshot)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
