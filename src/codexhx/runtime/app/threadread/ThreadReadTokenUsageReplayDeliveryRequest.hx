package codexhx.runtime.app.threadread;

class ThreadReadTokenUsageReplayDeliveryRequest {
	public final operation:ThreadReadTokenUsageReplayDeliveryOperation;
	public final includeTurns:Bool;
	public final responseReady:Bool;
	public final connectionId:String;
	public final payload:ThreadReadTokenUsageReplayOutcome;

	public function new(operation:ThreadReadTokenUsageReplayDeliveryOperation, includeTurns:Bool, responseReady:Bool, connectionId:String,
			payload:ThreadReadTokenUsageReplayOutcome) {
		this.operation = operation;
		this.includeTurns = includeTurns;
		this.responseReady = responseReady;
		this.connectionId = connectionId;
		this.payload = payload;
	}
}
