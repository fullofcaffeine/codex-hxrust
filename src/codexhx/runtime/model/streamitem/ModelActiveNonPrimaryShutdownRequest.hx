package codexhx.runtime.model.streamitem;

class ModelActiveNonPrimaryShutdownRequest {
	public final requestId:String;
	public final navigationCleanupOutcome:ModelThreadSideThreadNavigationCleanupOutcome;
	public final eventKind:ModelActiveNonPrimaryShutdownEventKind;
	public final activeThreadId:String;
	public final primaryThreadId:String;
	public final pendingShutdownExitThreadId:String;
	public final closedThreadIsSideThread:Bool;
	public final primarySelectSucceeded:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, navigationCleanupOutcome:ModelThreadSideThreadNavigationCleanupOutcome,
			eventKind:ModelActiveNonPrimaryShutdownEventKind, activeThreadId:String, primaryThreadId:String, pendingShutdownExitThreadId:String,
			closedThreadIsSideThread:Bool, primarySelectSucceeded:Bool, eventOrderIndex:Int, previousEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.navigationCleanupOutcome = navigationCleanupOutcome;
		this.eventKind = eventKind == null ? ModelActiveNonPrimaryShutdownEventKind.Other : eventKind;
		this.activeThreadId = activeThreadId == null ? "" : activeThreadId;
		this.primaryThreadId = primaryThreadId == null ? "" : primaryThreadId;
		this.pendingShutdownExitThreadId = pendingShutdownExitThreadId == null ? "" : pendingShutdownExitThreadId;
		this.closedThreadIsSideThread = closedThreadIsSideThread;
		this.primarySelectSucceeded = primarySelectSucceeded;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
