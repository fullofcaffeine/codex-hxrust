package codexhx.runtime.tui.resume.live;

typedef ResumePickerTranscriptOverlayRenderGateReportFields = {
	final transcriptLoads:Int;
	final fallbackLoads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerTranscriptOverlayRenderGateReport {
	public final transcriptLoads:Int;
	public final fallbackLoads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "transcriptLoads=" + transcriptLoads
			+ ";fallbackLoads=" + fallbackLoads
			+ ";frames=" + frameRequests
			+ ";renders=" + renderCount
			+ ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";events=[" + eventSummaries.join("##") + "]";
	}
}
