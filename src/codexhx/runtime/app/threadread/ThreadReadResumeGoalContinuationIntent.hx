package codexhx.runtime.app.threadread;

enum abstract ThreadReadResumeGoalContinuationIntent(String) from String to String {
	var None = "none";
	var EmitIdleLifecycle = "emit_idle_lifecycle";
	var SnapshotOnly = "snapshot_only";
}
