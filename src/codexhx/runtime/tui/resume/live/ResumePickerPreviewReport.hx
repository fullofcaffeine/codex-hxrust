package codexhx.runtime.tui.resume.live;

typedef ResumePickerPreviewReportFields = {
	final pageLoads:Int;
	final previewLoads:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerPreviewReport {
	public final pageLoads:Int;
	public final previewLoads:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";previewLoads=" + previewLoads + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";events=[" + eventSummaries.join("##") + "]";
	}
}
