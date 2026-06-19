package codexhx.runtime.tui.resume.live;

typedef ResumePickerEmptyErrorRenderGateReportFields = {
	final pageLoads:Int;
	final failures:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerEmptyErrorRenderGateReport {
	public final pageLoads:Int;
	public final failures:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads
			+ ";failures=" + failures
			+ ";frames=" + frameRequests
			+ ";renders=" + renderCount
			+ ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";events=[" + eventSummaries.join("##") + "]";
	}
}
