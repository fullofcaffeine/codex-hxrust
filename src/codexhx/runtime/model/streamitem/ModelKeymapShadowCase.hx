package codexhx.runtime.model.streamitem;

typedef ModelKeymapShadowCaseFields = {
	final scope:ModelKeymapShadowScopeKind;
	final outerActionName:String;
	final innerActionName:String;
	final binding:Null<ModelKeymapBinding>;
}

class ModelKeymapShadowCase {
	public final scope:ModelKeymapShadowScopeKind;
	public final outerActionName:String;
	public final innerActionName:String;
	public final binding:Null<ModelKeymapBinding>;

	public function new(fields:ModelKeymapShadowCaseFields) {
		this.scope = fields.scope == null ? ModelKeymapShadowScopeKind.Unknown : fields.scope;
		this.outerActionName = fields.outerActionName == null ? "" : fields.outerActionName;
		this.innerActionName = fields.innerActionName == null ? "" : fields.innerActionName;
		this.binding = fields.binding;
	}
}
