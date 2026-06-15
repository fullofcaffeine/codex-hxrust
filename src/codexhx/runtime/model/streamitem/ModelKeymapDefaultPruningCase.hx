package codexhx.runtime.model.streamitem;

typedef ModelKeymapDefaultPruningCaseFields = {
	final actionKind:ModelKeymapDefaultPruningActionKind;
	final bindings:Array<ModelKeymapBinding>;
}

class ModelKeymapDefaultPruningCase {
	public final actionKind:ModelKeymapDefaultPruningActionKind;
	public final bindings:Array<ModelKeymapBinding>;

	public function new(fields:ModelKeymapDefaultPruningCaseFields) {
		this.actionKind = fields.actionKind == null ? ModelKeymapDefaultPruningActionKind.Unknown : fields.actionKind;
		this.bindings = fields.bindings == null ? [] : fields.bindings;
	}
}
