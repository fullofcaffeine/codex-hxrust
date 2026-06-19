package codexhx.runtime.tui.resume.live;

typedef ResumePickerLoaderCancellationRenderGateReportFields = {
	final pageLoads:Int;
	final staleIgnored:Int;
	final cancellationObserved:Bool;
	final frameRequests:Int;
	final renderCount:Int;
	final baselineSummary:String;
	final finalSummary:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerLoaderCancellationRenderGateReport {
	public final pageLoads:Int;
	public final staleIgnored:Int;
	public final cancellationObserved:Bool;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final baselineSummary:String;
	public final finalSummary:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads
			+ ";staleIgnored=" + staleIgnored
			+ ";cancelled=" + (cancellationObserved ? "true" : "false")
			+ ";frames=" + frameRequests
			+ ";renders=" + renderCount
			+ ";baseline=" + baselineSummary
			+ ";final=" + finalSummary
			+ ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";events=[" + eventSummaries.join("##") + "]";
	}
}
