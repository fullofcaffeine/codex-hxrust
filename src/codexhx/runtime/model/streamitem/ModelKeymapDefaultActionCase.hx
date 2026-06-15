package codexhx.runtime.model.streamitem;

typedef ModelKeymapDefaultActionCaseFields = {
	final actionKind:ModelKeymapMainSurfaceActionKind;
	final bindings:Array<ModelKeymapBinding>;
}

class ModelKeymapDefaultActionCase {
	public final actionKind:ModelKeymapMainSurfaceActionKind;
	public final bindings:Array<ModelKeymapBinding>;

	public function new(fields:ModelKeymapDefaultActionCaseFields) {
		this.actionKind = fields.actionKind == null ? ModelKeymapMainSurfaceActionKind.Unknown : fields.actionKind;
		this.bindings = fields.bindings == null ? [] : fields.bindings;
	}
}
