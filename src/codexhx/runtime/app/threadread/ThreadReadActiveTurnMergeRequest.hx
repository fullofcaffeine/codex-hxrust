package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnMergeRequest {
	public final loadedStatus:ThreadReadThreadStatus;
	public final hasLiveRunningThread:Bool;
	public final activeTurn:Null<ThreadReadTurnSummary>;

	public function new(
		loadedStatus:ThreadReadThreadStatus,
		hasLiveRunningThread:Bool,
		activeTurn:Null<ThreadReadTurnSummary>
	) {
		this.loadedStatus = loadedStatus;
		this.hasLiveRunningThread = hasLiveRunningThread;
		this.activeTurn = activeTurn;
	}
}
