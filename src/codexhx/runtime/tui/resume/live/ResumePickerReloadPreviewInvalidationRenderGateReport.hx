package codexhx.runtime.tui.resume.live;

typedef ResumePickerReloadPreviewInvalidationRenderGateReportFields = {
	final pageLoads:Int;
	final previewLoads:Int;
	final preservedPreviews:Int;
	final invalidatedPreviews:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final stateSummaries:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerReloadPreviewInvalidationRenderGateReport {
	public final pageLoads:Int;
	public final previewLoads:Int;
	public final preservedPreviews:Int;
	public final invalidatedPreviews:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final stateSummaries:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";previewLoads=" + previewLoads + ";preservedPreviews=" + preservedPreviews + ";invalidatedPreviews="
			+ invalidatedPreviews + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n")
			+ ";states=[" + stateSummaries.join("##") + "]" + ";events=[" + eventSummaries.join("##") + "]";
	}
}
