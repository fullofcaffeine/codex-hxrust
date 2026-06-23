package codexhx.runtime.tui.resume.host;

typedef RequestDispatchCommandFields = {
	final kind:RequestDispatchCommandKind;
	final requestId:String;
	final intentKind:RequestResponseIntentKind;
	final orderIndex:Int;
	final responseJson:String;
	final errorCode:String;
	final errorMessage:String;
	final appServerSessionAvailable:Bool;
	final transportSendIntentRecorded:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class RequestDispatchCommand {
	@:recordDefault(RequestDispatchCommandKind.Unknown)
	public final kind:RequestDispatchCommandKind;
	public final requestId:String;
	@:recordDefault(RequestResponseIntentKind.Unknown)
	public final intentKind:RequestResponseIntentKind;
	public final orderIndex:Int;
	public final responseJson:String;
	public final errorCode:String;
	public final errorMessage:String;
	public final appServerSessionAvailable:Bool;
	public final transportSendIntentRecorded:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;

	public function summary():String {
		final response = responseJson.length == 0 ? "none" : responseJson;
		final error = errorCode.length == 0 ? "none" : errorCode + ":" + errorMessage;
		return "kind=" + kind + ";request=" + requestId + ";intent=" + intentKind + ";order=" + orderIndex + ";response=" + response + ";error=" + error
			+ ";session=" + boolLabel(appServerSessionAvailable) + ";sendIntent=" + boolLabel(transportSendIntentRecorded) + ";liveTransport="
			+ boolLabel(liveTransportAttempted) + ";suppressed=" + boolLabel(liveTransportSuppressed);
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
