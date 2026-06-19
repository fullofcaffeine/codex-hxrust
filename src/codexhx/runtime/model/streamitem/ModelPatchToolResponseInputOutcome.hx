package codexhx.runtime.model.streamitem;

class ModelPatchToolResponseInputOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final callId:String;
	public final responseKind:ModelPatchToolOutputItemKind;
	public final admissionKind:ModelPatchToolResponseAdmissionKind;
	public final responseOrderIndex:Int;
	public final nextInputCount:Int;
	public final outputText:String;
	public final success:Bool;
	public final followUpRequestRequired:Bool;
	public final toolFutureDrained:Bool;
	public final conversationItemRecorded:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, callId:String, responseKind:ModelPatchToolOutputItemKind,
			admissionKind:ModelPatchToolResponseAdmissionKind, responseOrderIndex:Int, nextInputCount:Int, outputText:String, success:Bool,
			followUpRequestRequired:Bool, toolFutureDrained:Bool, conversationItemRecorded:Bool, liveNetworkAttempted:Bool, realFilesystemMutated:Bool,
			toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.callId = callId == null ? "" : callId;
		this.responseKind = responseKind;
		this.admissionKind = admissionKind;
		this.responseOrderIndex = responseOrderIndex;
		this.nextInputCount = nextInputCount;
		this.outputText = outputText == null ? "" : outputText;
		this.success = success;
		this.followUpRequestRequired = followUpRequestRequired;
		this.toolFutureDrained = toolFutureDrained;
		this.conversationItemRecorded = conversationItemRecorded;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";callId=" + noneIfEmpty(callId) + ";responseKind=" + responseKind
			+ ";admissionKind=" + admissionKind + ";responseOrderIndex=" + Std.string(responseOrderIndex) + ";nextInputCount=" + Std.string(nextInputCount)
			+ ";success=" + boolText(success) + ";followUpRequestRequired=" + boolText(followUpRequestRequired) + ";toolFutureDrained="
			+ boolText(toolFutureDrained) + ";conversationItemRecorded=" + boolText(conversationItemRecorded) + ";outputText=" + outputText
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
