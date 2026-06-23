package codexhx.runtime.tui.resume.host;

typedef RequestResponseIntentFields = {
	final kind:RequestResponseIntentKind;
	final requestId:String;
	final detail:String;
	final reason:String;
	final responseJson:String;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RequestResponseIntent {
	@:recordDefault(RequestResponseIntentKind.Unknown)
	public final kind:RequestResponseIntentKind;
	public final requestId:String;
	public final detail:String;
	public final reason:String;
	public final responseJson:String;
	public final failureCode:String;

	public static function refused(requestId:String, detail:String, reason:String, failureCode:String):RequestResponseIntent {
		return new RequestResponseIntent({
			kind: RequestResponseIntentKind.Refused,
			requestId: requestId,
			detail: detail,
			reason: reason,
			responseJson: "",
			failureCode: failureCode
		});
	}

	public static function resolved(requestId:String, detail:String, responseJson:String):RequestResponseIntent {
		return new RequestResponseIntent({
			kind: RequestResponseIntentKind.Resolved,
			requestId: requestId,
			detail: detail,
			reason: "",
			responseJson: responseJson,
			failureCode: ""
		});
	}

	public function summary():String {
		final failure = failureCode.length == 0 ? "none" : failureCode;
		final response = responseJson.length == 0 ? "none" : responseJson;
		return "kind="
			+ kind
			+ ";request="
			+ requestId
			+ ";detail="
			+ detail
			+ ";reason="
			+ reason
			+ ";failure="
			+ failure
			+ ";response="
			+ response;
	}
}
