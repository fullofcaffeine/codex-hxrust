package codexhx.runtime.model.streamitem;

typedef ModelKeymapVimNormalDefaultsRequestFields = {
	final requestId:String;
	final enterInsert:Array<ModelKeymapBinding>;
	final moveLeft:Array<ModelKeymapBinding>;
	final moveRight:Array<ModelKeymapBinding>;
	final moveUp:Array<ModelKeymapBinding>;
	final moveDown:Array<ModelKeymapBinding>;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelKeymapVimNormalDefaultsRequest {
	public final requestId:String;
	public final enterInsert:Array<ModelKeymapBinding>;
	public final moveLeft:Array<ModelKeymapBinding>;
	public final moveRight:Array<ModelKeymapBinding>;
	public final moveUp:Array<ModelKeymapBinding>;
	public final moveDown:Array<ModelKeymapBinding>;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelKeymapVimNormalDefaultsRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.enterInsert = fields.enterInsert == null ? [] : fields.enterInsert;
		this.moveLeft = fields.moveLeft == null ? [] : fields.moveLeft;
		this.moveRight = fields.moveRight == null ? [] : fields.moveRight;
		this.moveUp = fields.moveUp == null ? [] : fields.moveUp;
		this.moveDown = fields.moveDown == null ? [] : fields.moveDown;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
