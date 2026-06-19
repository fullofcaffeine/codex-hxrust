package codexhx.runtime.model.streamitem;

class ModelPatchToolFollowUpOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final outputText:String;
	public final success:Bool;
	public final followUpQueued:Bool;
	public final modelNeedsFollowUp:Bool;
	public final postToolUseResponseVisible:Bool;
	public final stdoutVisible:Bool;
	public final stderrVisible:Bool;
	public final resultTextVisible:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, callId:String, responseKind:ModelPatchToolOutputItemKind, outputText:String, success:Bool,
			followUpQueued:Bool, modelNeedsFollowUp:Bool, postToolUseResponseVisible:Bool, stdoutVisible:Bool, stderrVisible:Bool, resultTextVisible:Bool,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind;
		this.outputText = outputText == null ? "" : outputText;
		this.success = success;
		this.followUpQueued = followUpQueued;
		this.modelNeedsFollowUp = modelNeedsFollowUp;
		this.postToolUseResponseVisible = postToolUseResponseVisible;
		this.stdoutVisible = stdoutVisible;
		this.stderrVisible = stderrVisible;
		this.resultTextVisible = resultTextVisible;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";callId=" + noneIfEmpty(callId) + ";responseKind=" + responseKind
			+ ";success=" + boolText(success) + ";followUpQueued=" + boolText(followUpQueued) + ";modelNeedsFollowUp=" + boolText(modelNeedsFollowUp)
			+ ";postToolUseResponseVisible=" + boolText(postToolUseResponseVisible) + ";stdoutVisible=" + boolText(stdoutVisible) + ";stderrVisible="
			+ boolText(stderrVisible) + ";resultTextVisible=" + boolText(resultTextVisible) + ";outputText=" + outputText + ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
