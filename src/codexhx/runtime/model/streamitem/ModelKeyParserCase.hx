package codexhx.runtime.model.streamitem;

typedef ModelKeyParserCaseFields = {
	final spec:String;
	final expectedAccepted:Bool;
	final expectedKind:ModelParsedKeyKind;
	final expectedKeyName:String;
	final expectedFunctionNumber:Int;
	final ?expectedCtrlModifier:Bool;
	final ?expectedAltModifier:Bool;
	final ?expectedShiftModifier:Bool;
}

class ModelKeyParserCase {
	public final spec:String;
	public final expectedAccepted:Bool;
	public final expectedKind:ModelParsedKeyKind;
	public final expectedKeyName:String;
	public final expectedFunctionNumber:Int;
	public final expectedCtrlModifier:Bool;
	public final expectedAltModifier:Bool;
	public final expectedShiftModifier:Bool;

	public function new(fields:ModelKeyParserCaseFields) {
		this.spec = normalizeText(fields.spec);
		this.expectedAccepted = fields.expectedAccepted;
		this.expectedKind = fields.expectedKind == null ? ModelParsedKeyKind.Invalid : fields.expectedKind;
		this.expectedKeyName = normalizeText(fields.expectedKeyName);
		this.expectedFunctionNumber = fields.expectedFunctionNumber;
		this.expectedCtrlModifier = fields.expectedCtrlModifier == true;
		this.expectedAltModifier = fields.expectedAltModifier == true;
		this.expectedShiftModifier = fields.expectedShiftModifier == true;
	}

	static function normalizeText(value:String):String {
		return value == null ? "" : value;
	}
}
