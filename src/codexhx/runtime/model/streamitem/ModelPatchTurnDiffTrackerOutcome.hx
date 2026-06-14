package codexhx.runtime.model.streamitem;

class ModelPatchTurnDiffTrackerOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final updateKind:ModelPatchTurnDiffTrackerUpdateKind;
	public final trackerValid:Bool;
	public final shouldEmitTurnDiff:Bool;
	public final unifiedDiff:String;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		updateKind:ModelPatchTurnDiffTrackerUpdateKind,
		trackerValid:Bool,
		shouldEmitTurnDiff:Bool,
		unifiedDiff:String,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.updateKind = updateKind;
		this.trackerValid = trackerValid;
		this.shouldEmitTurnDiff = shouldEmitTurnDiff;
		this.unifiedDiff = unifiedDiff == null ? "" : unifiedDiff;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";updateKind=" + updateKind
			+ ";trackerValid=" + boolText(trackerValid)
			+ ";shouldEmitTurnDiff=" + boolText(shouldEmitTurnDiff)
			+ ";unifiedDiff=" + unifiedDiff
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
