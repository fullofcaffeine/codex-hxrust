package codexhx.runtime.model.streamitem;

class ModelThreadActiveTurnRequest {
	public final requestId:String;
	public final rebaseOutcome:ModelThreadSessionRebaseOutcome;
	public final eventKind:ModelThreadActiveTurnEventKind;
	public final activeTurnIdBefore:String;
	public final eventTurnId:String;
	public final latestInProgressTurnId:String;
	public final turnsRestoredInOrder:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		rebaseOutcome:ModelThreadSessionRebaseOutcome,
		eventKind:ModelThreadActiveTurnEventKind,
		activeTurnIdBefore:String,
		eventTurnId:String,
		latestInProgressTurnId:String,
		turnsRestoredInOrder:Bool,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.rebaseOutcome = rebaseOutcome;
		this.eventKind = eventKind == null ? ModelThreadActiveTurnEventKind.TurnsRestored : eventKind;
		this.activeTurnIdBefore = activeTurnIdBefore == null ? "" : activeTurnIdBefore;
		this.eventTurnId = eventTurnId == null ? "" : eventTurnId;
		this.latestInProgressTurnId = latestInProgressTurnId == null ? "" : latestInProgressTurnId;
		this.turnsRestoredInOrder = turnsRestoredInOrder;
		this.eventOrderIndex = eventOrderIndex < 0 ? 0 : eventOrderIndex;
		this.previousEventCount = previousEventCount < 0 ? 0 : previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
