package codexhx.runtime.model.streamitem;

typedef ModelKeymapBindingFields = {
	final kind:ModelParsedKeyKind;
	final keyName:String;
	final functionNumber:Int;
	final ?ctrlModifier:Bool;
	final ?altModifier:Bool;
	final ?shiftModifier:Bool;
}

class ModelKeymapBinding {
	public final kind:ModelParsedKeyKind;
	public final keyName:String;
	public final functionNumber:Int;
	public final ctrlModifier:Bool;
	public final altModifier:Bool;
	public final shiftModifier:Bool;

	public function new(fields:ModelKeymapBindingFields) {
		this.kind = fields.kind == null ? ModelParsedKeyKind.Invalid : fields.kind;
		this.keyName = fields.keyName == null ? "" : fields.keyName;
		this.functionNumber = fields.functionNumber;
		this.ctrlModifier = fields.ctrlModifier == true;
		this.altModifier = fields.altModifier == true;
		this.shiftModifier = fields.shiftModifier == true;
	}

	public function equals(other:ModelKeymapBinding):Bool {
		return other != null
			&& kind == other.kind
			&& keyName == other.keyName
			&& functionNumber == other.functionNumber
			&& ctrlModifier == other.ctrlModifier
			&& altModifier == other.altModifier
			&& shiftModifier == other.shiftModifier;
	}
}
