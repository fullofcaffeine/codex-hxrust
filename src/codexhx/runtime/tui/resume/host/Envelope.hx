package codexhx.runtime.tui.resume.host;

typedef EnvelopeFields = {
	final kind:EnvelopeKind;
	final requestClass:PendingRequestClassKind;
	final payloadKind:PayloadKind;
	final requestId:String;
	final method:String;
	final payloadJson:String;
	final errorJson:String;
	final correlationKey:String;
	final localOnly:Bool;
	final sendIntentRecorded:Bool;
	final liveTransportAttempted:Bool;
	final liveTransportSuppressed:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class Envelope {
	@:recordDefault(EnvelopeKind.Unknown)
	public final kind:EnvelopeKind;
	@:recordDefault(PendingRequestClassKind.Unknown)
	public final requestClass:PendingRequestClassKind;
	@:recordDefault(PayloadKind.Unknown)
	public final payloadKind:PayloadKind;
	public final requestId:String;
	public final method:String;
	public final payloadJson:String;
	public final errorJson:String;
	public final correlationKey:String;
	public final localOnly:Bool;
	public final sendIntentRecorded:Bool;
	public final liveTransportAttempted:Bool;
	public final liveTransportSuppressed:Bool;

	public function summary():String {
		return "kind=" + kind + ";class=" + requestClass + ";payloadKind=" + payloadKind + ";request=" + requestId + ";method=" + method + ";correlation="
			+ correlationKey + ";payload=" + payloadLabel(payloadJson) + ";error=" + payloadLabel(errorJson) + ";localOnly=" + boolLabel(localOnly)
			+ ";sendIntent=" + boolLabel(sendIntentRecorded) + ";liveTransport=" + boolLabel(liveTransportAttempted) + ";suppressed="
			+ boolLabel(liveTransportSuppressed);
	}

	static function payloadLabel(value:String):String {
		return value.length == 0 ? "none" : value;
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
