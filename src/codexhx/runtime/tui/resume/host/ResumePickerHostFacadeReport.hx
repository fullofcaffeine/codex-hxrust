package codexhx.runtime.tui.resume.host;

typedef ResumePickerHostFacadeReportFields = {
	final pageEvents:Int;
	final previewEvents:Int;
	final transcriptEvents:Int;
	final frameEvents:Int;
	final failureEvents:Int;
	final frameRequests:Int;
	final renders:Int;
	final persistedDensity:String;
	final skippedEvents:Int;
	final summaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerHostFacadeReport {
	public final pageEvents:Int;
	public final previewEvents:Int;
	public final transcriptEvents:Int;
	public final frameEvents:Int;
	public final failureEvents:Int;
	public final frameRequests:Int;
	public final renders:Int;
	public final persistedDensity:String;
	public final skippedEvents:Int;
	public final summaries:Array<String>;

	public function summary():String {
		return "page=" + pageEvents + ";preview=" + previewEvents + ";transcript=" + transcriptEvents + ";frame=" + frameEvents + ";failures="
			+ failureEvents + ";frameRequests=" + frameRequests + ";renders=" + renders + ";density=" + persistedDensity + ";skipped=" + skippedEvents
			+ ";events=[" + summaries.join("##") + "]";
	}
}
