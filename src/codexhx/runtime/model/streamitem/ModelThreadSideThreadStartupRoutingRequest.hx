package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartupRoutingRequest {
	public final requestId:String;
	public final startOutcome:ModelThreadSideThreadStartOutcome;
	public final notificationThreadScoped:Bool;
	public final notificationTargetsVisibleThread:Bool;
	public final notificationTargetsPrimaryThread:Bool;
	public final targetThreadIsSideThread:Bool;
	public final visibleThreadIsSideThread:Bool;
	public final activeThreadChannel:Bool;
	public final snapshotReplay:Bool;
	public final snapshotSessionIsSideThread:Bool;
	public final mcpServerName:String;
	public final startupEventKind:ModelThreadSideThreadStartupEventKind;
	public final startupErrorMessage:String;
	public final expectedServerConfigured:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(
		requestId:String,
		startOutcome:ModelThreadSideThreadStartOutcome,
		notificationThreadScoped:Bool,
		notificationTargetsVisibleThread:Bool,
		notificationTargetsPrimaryThread:Bool,
		targetThreadIsSideThread:Bool,
		visibleThreadIsSideThread:Bool,
		activeThreadChannel:Bool,
		snapshotReplay:Bool,
		snapshotSessionIsSideThread:Bool,
		mcpServerName:String,
		startupEventKind:ModelThreadSideThreadStartupEventKind,
		startupErrorMessage:String,
		expectedServerConfigured:Bool,
		eventOrderIndex:Int,
		previousEventCount:Int,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.startOutcome = startOutcome;
		this.notificationThreadScoped = notificationThreadScoped;
		this.notificationTargetsVisibleThread = notificationTargetsVisibleThread;
		this.notificationTargetsPrimaryThread = notificationTargetsPrimaryThread;
		this.targetThreadIsSideThread = targetThreadIsSideThread;
		this.visibleThreadIsSideThread = visibleThreadIsSideThread;
		this.activeThreadChannel = activeThreadChannel;
		this.snapshotReplay = snapshotReplay;
		this.snapshotSessionIsSideThread = snapshotSessionIsSideThread;
		this.mcpServerName = mcpServerName == null ? "" : mcpServerName;
		this.startupEventKind = startupEventKind == null ? ModelThreadSideThreadStartupEventKind.Starting : startupEventKind;
		this.startupErrorMessage = startupErrorMessage == null ? "" : startupErrorMessage;
		this.expectedServerConfigured = expectedServerConfigured;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
