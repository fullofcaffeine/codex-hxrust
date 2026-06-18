package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadDeliveryActionFields = {
	final kind:TuiSmokeThreadDeliveryActionKind;
	final threadId:String;
	final requestId:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadDeliveryAction {
	public final kind:TuiSmokeThreadDeliveryActionKind;
	public final threadId:String;
	public final requestId:String;
}
