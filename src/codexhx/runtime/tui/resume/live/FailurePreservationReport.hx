package codexhx.runtime.tui.resume.live;

typedef FailurePreservationReportFields = {
	final pageLoads:Int;
	final reloadFailures:Int;
	final recoveryReloads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class FailurePreservationReport {
	public final pageLoads:Int;
	public final reloadFailures:Int;
	public final recoveryReloads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";reloadFailures=" + reloadFailures + ";recoveryReloads=" + recoveryReloads + ";frames=" + frameRequests
			+ ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";states=[" + stateSummaries.join("##") + "]"
			+ ";events=[" + eventSummaries.join("##") + "]";
	}
}
