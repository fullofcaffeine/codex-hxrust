package codexhx.runtime.tui.resume.live;

typedef StaleReloadResponseReportFields = {
	final activePageLoads:Int;
	final stalePageRefusals:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final activeSnapshot:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class StaleReloadResponseReport {
	public final activePageLoads:Int;
	public final stalePageRefusals:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final activeSnapshot:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "activePageLoads=" + activePageLoads + ";stalePageRefusals=" + stalePageRefusals + ";frames=" + frameRequests + ";renders=" + renderCount
			+ ";activeSnapshot=" + activeSnapshot.split("\n").join("\\n") + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";states=["
			+ stateSummaries.join("##") + "]" + ";events=[" + eventSummaries.join("##") + "]";
	}
}
