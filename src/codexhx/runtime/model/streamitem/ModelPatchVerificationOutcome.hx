package codexhx.runtime.model.streamitem;

class ModelPatchVerificationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final beginEvent:ModelPatchVerificationEvent;
	public final endEvent:ModelPatchVerificationEvent;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(ok:Bool, code:String, requestId:String, beginEvent:ModelPatchVerificationEvent, endEvent:ModelPatchVerificationEvent,
			liveNetworkAttempted:Bool, realFilesystemMutated:Bool, toolExecutedOutsideFixture:Bool, errorMessage:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = requestId == null ? "" : requestId;
		this.beginEvent = beginEvent;
		this.endEvent = endEvent;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.realFilesystemMutated = realFilesystemMutated;
		this.toolExecutedOutsideFixture = toolExecutedOutsideFixture;
		this.errorMessage = errorMessage == null ? "" : errorMessage;
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";begin=" + (beginEvent == null ? "none" : beginEvent.summary()) + ";end="
			+ (endEvent == null ? "none" : endEvent.summary()) + ";liveNetworkAttempted=" + boolText(liveNetworkAttempted) + ";realFilesystemMutated="
			+ boolText(realFilesystemMutated) + ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture) + ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
