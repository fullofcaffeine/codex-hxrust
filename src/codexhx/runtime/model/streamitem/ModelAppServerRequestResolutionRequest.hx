package codexhx.runtime.model.streamitem;

class ModelAppServerRequestResolutionRequest {
	public final requestId:String;
	public final surfaceOutcome:ModelReplayedServerRequestSurfaceOutcome;
	public final requestKind:ModelReplayedServerRequestKind;
	public final commandKind:ModelAppServerRequestResolutionCommandKind;
	public final appServerRequestId:String;
	public final requestKey:String;
	public final commandKey:String;
	public final serverName:String;
	public final commandServerName:String;
	public final mcpRequestId:String;
	public final commandMcpRequestId:String;
	public final pendingItemId:String;
	public final pendingRequestCountBefore:Int;
	public final userInputQueueLengthBefore:Int;
	public final userInputQueuePosition:Int;
	public final duplicateResponse:Bool;
	public final secretProbe:String;

	public function new(requestId:String, surfaceOutcome:ModelReplayedServerRequestSurfaceOutcome, requestKind:ModelReplayedServerRequestKind,
			commandKind:ModelAppServerRequestResolutionCommandKind, appServerRequestId:String, requestKey:String, commandKey:String, serverName:String,
			commandServerName:String, mcpRequestId:String, commandMcpRequestId:String, pendingItemId:String, pendingRequestCountBefore:Int,
			userInputQueueLengthBefore:Int, userInputQueuePosition:Int, duplicateResponse:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.surfaceOutcome = surfaceOutcome;
		this.requestKind = requestKind == null ? ModelReplayedServerRequestKind.UserInput : requestKind;
		this.commandKind = commandKind == null ? ModelAppServerRequestResolutionCommandKind.UserInputAnswer : commandKind;
		this.appServerRequestId = appServerRequestId == null ? "" : appServerRequestId;
		this.requestKey = requestKey == null ? "" : requestKey;
		this.commandKey = commandKey == null ? "" : commandKey;
		this.serverName = serverName == null ? "" : serverName;
		this.commandServerName = commandServerName == null ? "" : commandServerName;
		this.mcpRequestId = mcpRequestId == null ? "" : mcpRequestId;
		this.commandMcpRequestId = commandMcpRequestId == null ? "" : commandMcpRequestId;
		this.pendingItemId = pendingItemId == null ? "" : pendingItemId;
		this.pendingRequestCountBefore = pendingRequestCountBefore < 0 ? 0 : pendingRequestCountBefore;
		this.userInputQueueLengthBefore = userInputQueueLengthBefore < 0 ? 0 : userInputQueueLengthBefore;
		this.userInputQueuePosition = userInputQueuePosition;
		this.duplicateResponse = duplicateResponse;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
