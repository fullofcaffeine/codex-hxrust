package codexhx.runtime.tui.resume.live;

typedef ResumePickerReloadTranscriptOverlayInvalidationRenderGateReportFields = {
	final pageLoads:Int;
	final transcriptLoads:Int;
	final preservedOverlays:Int;
	final invalidatedOverlays:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerReloadTranscriptOverlayInvalidationRenderGateReport {
	public final pageLoads:Int;
	public final transcriptLoads:Int;
	public final preservedOverlays:Int;
	public final invalidatedOverlays:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";transcriptLoads=" + transcriptLoads + ";preservedOverlays=" + preservedOverlays + ";invalidatedOverlays="
			+ invalidatedOverlays + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";states=[" + stateSummaries.join("##") + "]" + ";events=[" + eventSummaries.join("##") + "]";
	}
}
