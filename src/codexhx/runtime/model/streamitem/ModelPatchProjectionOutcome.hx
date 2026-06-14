package codexhx.runtime.model.streamitem;

class ModelPatchProjectionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final itemId:String;
	public final fileChangeItemProjected:Bool;
	public final legacyBeginProjected:Bool;
	public final legacyEndProjected:Bool;
	public final turnDiffProjected:Bool;
	public final status:ModelPatchApplyStatus;
	public final autoApproved:Bool;
	public final stdoutVisible:Bool;
	public final stderrVisible:Bool;
	public final changeCount:Int;
	public final turnDiff:String;
	public final eventKinds:Array<ModelPatchProjectionEventKind>;
	public final changes:Array<ModelPatchFileChangeProjection>;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(
		ok:Bool,
		code:String,
		requestId:String,
		itemId:String,
		fileChangeItemProjected:Bool,
		legacyBeginProjected:Bool,
		legacyEndProjected:Bool,
		turnDiffProjected:Bool,
		status:ModelPatchApplyStatus,
		autoApproved:Bool,
		stdoutVisible:Bool,
		stderrVisible:Bool,
		changeCount:Int,
		turnDiff:String,
		eventKinds:Array<ModelPatchProjectionEventKind>,
		changes:Array<ModelPatchFileChangeProjection>,
		liveNetworkAttempted:Bool,
		realFilesystemMutated:Bool,
		toolExecutedOutsideFixture:Bool,
		errorMessage:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.itemId = itemId == null ? "" : itemId;
		this.fileChangeItemProjected = fileChangeItemProjected;
		this.legacyBeginProjected = legacyBeginProjected;
		this.legacyEndProjected = legacyEndProjected;
		this.turnDiffProjected = turnDiffProjected;
		this.status = status;
		this.autoApproved = autoApproved;
		this.stdoutVisible = stdoutVisible;
		this.stderrVisible = stderrVisible;
		this.changeCount = changeCount;
		this.turnDiff = turnDiff == null ? "" : turnDiff;
		this.eventKinds = eventKinds == null ? [] : eventKinds;
		this.changes = changes == null ? [] : changes;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		final parts:Array<String> = [];
		for (change in changes) parts.push(change.summary());
		final events:Array<String> = [];
		for (kind in eventKinds) events.push(kind);
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";itemId=" + noneIfEmpty(itemId)
			+ ";fileChangeItemProjected=" + boolText(fileChangeItemProjected)
			+ ";legacyBeginProjected=" + boolText(legacyBeginProjected)
			+ ";legacyEndProjected=" + boolText(legacyEndProjected)
			+ ";turnDiffProjected=" + boolText(turnDiffProjected)
			+ ";status=" + status
			+ ";autoApproved=" + boolText(autoApproved)
			+ ";stdoutVisible=" + boolText(stdoutVisible)
			+ ";stderrVisible=" + boolText(stderrVisible)
			+ ";changeCount=" + Std.string(changeCount)
			+ ";turnDiff=" + turnDiff
			+ ";events=[" + events.join("|") + "]"
			+ ";changes=[" + parts.join("||") + "]"
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
