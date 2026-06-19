package codexhx.runtime.tui.resume.live;

typedef ResumePickerQueryReloadRenderGateReportFields = {
	final pageLoads:Int;
	final queryReloads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerQueryReloadRenderGateReport {
	public final pageLoads:Int;
	public final queryReloads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";queryReloads=" + queryReloads + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";requests=[" + requestSummaries.join("##") + "]" + ";events=[" + eventSummaries.join("##") + "]";
	}
}
