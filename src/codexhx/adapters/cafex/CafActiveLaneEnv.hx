package codexhx.adapters.cafex;

class CafActiveLaneEnv {
	public final activeLanePath:String;
	public final runId:String;
	public final successorRunId:String;
	public final ownerPid:String;
	public final continuityGenerationId:String;
	public final wakeRequestsDir:String;
	public final wakeReceiptsDir:String;
	public final pendingInputSnapshotPath:String;

	public function new(activeLanePath:String, runId:String, successorRunId:String, ownerPid:String, continuityGenerationId:String, wakeRequestsDir:String,
			wakeReceiptsDir:String, pendingInputSnapshotPath:String) {
		this.activeLanePath = activeLanePath;
		this.runId = runId;
		this.successorRunId = successorRunId;
		this.ownerPid = ownerPid;
		this.continuityGenerationId = continuityGenerationId;
		this.wakeRequestsDir = wakeRequestsDir;
		this.wakeReceiptsDir = wakeReceiptsDir;
		this.pendingInputSnapshotPath = pendingInputSnapshotPath;
	}

	public static function empty():CafActiveLaneEnv {
		return new CafActiveLaneEnv("", "", "", "", "", "", "", "");
	}
}
