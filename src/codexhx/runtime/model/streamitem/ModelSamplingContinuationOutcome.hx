package codexhx.runtime.model.streamitem;

class ModelSamplingContinuationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final continuationKind:ModelSamplingContinuationKind;
	public final modelNeedsFollowUp:Bool;
	public final hasPendingInput:Bool;
	public final needsFollowUp:Bool;
	public final nextSamplingRequestRequired:Bool;
	public final responseInputCarried:Bool;
	public final pendingInputDrainedBeforeNextRequest:Bool;
	public final autoCompactRequired:Bool;
	public final canDrainPendingInputBeforeNextRequest:Bool;
	public final admittedResponseInputCount:Int;
	public final pendingInputCount:Int;
	public final nextSamplingInputCount:Int;
	public final nextSamplingRequestIndex:Int;
	public final activeContextTokens:Int;
	public final estimatedTokenCount:Int;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, continuationKind:ModelSamplingContinuationKind, modelNeedsFollowUp:Bool, hasPendingInput:Bool,
			needsFollowUp:Bool, nextSamplingRequestRequired:Bool, responseInputCarried:Bool, pendingInputDrainedBeforeNextRequest:Bool,
			autoCompactRequired:Bool, canDrainPendingInputBeforeNextRequest:Bool, admittedResponseInputCount:Int, pendingInputCount:Int,
			nextSamplingInputCount:Int, nextSamplingRequestIndex:Int, activeContextTokens:Int, estimatedTokenCount:Int, liveNetworkAttempted:Bool,
			realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.continuationKind = continuationKind;
		this.modelNeedsFollowUp = modelNeedsFollowUp;
		this.hasPendingInput = hasPendingInput;
		this.needsFollowUp = needsFollowUp;
		this.nextSamplingRequestRequired = nextSamplingRequestRequired;
		this.responseInputCarried = responseInputCarried;
		this.pendingInputDrainedBeforeNextRequest = pendingInputDrainedBeforeNextRequest;
		this.autoCompactRequired = autoCompactRequired;
		this.canDrainPendingInputBeforeNextRequest = canDrainPendingInputBeforeNextRequest;
		this.admittedResponseInputCount = admittedResponseInputCount;
		this.pendingInputCount = pendingInputCount;
		this.nextSamplingInputCount = nextSamplingInputCount;
		this.nextSamplingRequestIndex = nextSamplingRequestIndex;
		this.activeContextTokens = activeContextTokens;
		this.estimatedTokenCount = estimatedTokenCount;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";continuationKind=" + continuationKind + ";modelNeedsFollowUp="
			+ boolText(modelNeedsFollowUp) + ";hasPendingInput=" + boolText(hasPendingInput) + ";needsFollowUp=" + boolText(needsFollowUp)
			+ ";nextSamplingRequestRequired=" + boolText(nextSamplingRequestRequired) + ";responseInputCarried=" + boolText(responseInputCarried)
			+ ";pendingInputDrainedBeforeNextRequest=" + boolText(pendingInputDrainedBeforeNextRequest) + ";autoCompactRequired="
			+ boolText(autoCompactRequired) + ";canDrainPendingInputBeforeNextRequest=" + boolText(canDrainPendingInputBeforeNextRequest)
			+ ";admittedResponseInputCount=" + Std.string(admittedResponseInputCount) + ";pendingInputCount=" + Std.string(pendingInputCount)
			+ ";nextSamplingInputCount=" + Std.string(nextSamplingInputCount) + ";nextSamplingRequestIndex=" + Std.string(nextSamplingRequestIndex)
			+ ";activeContextTokens=" + Std.string(activeContextTokens) + ";estimatedTokenCount=" + Std.string(estimatedTokenCount)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
