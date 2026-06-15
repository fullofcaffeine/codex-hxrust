package codexhx.runtime.model.streamitem;

typedef ModelTuiActiveTurnErrorRequestFields = {
	final requestId:String;
	final requestKind:ModelTuiActiveTurnErrorRequestKind;
	final method:String;
	final message:String;
	final hasStructuredTurnError:Bool;
	final structuredNotSteerable:Bool;
	final turnKind:ModelTuiActiveTurnErrorTurnKind;
	final sessionAction:String;
	final targetThreadId:String;
	final targetRolloutPath:String;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelTuiActiveTurnErrorRequest {
	public final requestId:String;
	public final requestKind:ModelTuiActiveTurnErrorRequestKind;
	public final method:String;
	public final message:String;
	public final hasStructuredTurnError:Bool;
	public final structuredNotSteerable:Bool;
	public final turnKind:ModelTuiActiveTurnErrorTurnKind;
	public final sessionAction:String;
	public final targetThreadId:String;
	public final targetRolloutPath:String;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelTuiActiveTurnErrorRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.requestKind = fields.requestKind == null ? ModelTuiActiveTurnErrorRequestKind.SteerRace : fields.requestKind;
		this.method = fields.method == null ? "" : fields.method;
		this.message = fields.message == null ? "" : fields.message;
		this.hasStructuredTurnError = fields.hasStructuredTurnError;
		this.structuredNotSteerable = fields.structuredNotSteerable;
		this.turnKind = fields.turnKind == null ? ModelTuiActiveTurnErrorTurnKind.None : fields.turnKind;
		this.sessionAction = fields.sessionAction == null ? "" : fields.sessionAction;
		this.targetThreadId = fields.targetThreadId == null ? "" : fields.targetThreadId;
		this.targetRolloutPath = fields.targetRolloutPath == null ? "" : fields.targetRolloutPath;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
