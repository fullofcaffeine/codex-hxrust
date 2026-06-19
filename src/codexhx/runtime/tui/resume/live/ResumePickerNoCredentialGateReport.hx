package codexhx.runtime.tui.resume.live;

typedef ResumePickerNoCredentialGateReportFields = {
	final pageLoads:Int;
	final transcriptLoads:Int;
	final keyEvents:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final overlayOpened:Bool;
	final densityPersisted:Bool;
	final configPath:String;
	final configText:String;
	final finalSummary:String;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerNoCredentialGateReport {
	public final pageLoads:Int;
	public final transcriptLoads:Int;
	public final keyEvents:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final overlayOpened:Bool;
	public final densityPersisted:Bool;
	public final configPath:String;
	public final configText:String;
	public final finalSummary:String;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";transcriptLoads=" + transcriptLoads + ";keys=" + keyEvents + ";frames=" + frameRequests + ";renders="
			+ renderCount + ";overlay=" + (overlayOpened ? "true" : "false") + ";densityPersisted=" + (densityPersisted ? "true" : "false") + ";configPath="
			+ configPath + ";final=" + finalSummary + ";finalSnapshot=" + finalSnapshot.split("\n")
			.join("\\n") + ";events=[" + eventSummaries.join("##") + "]";
	}
}
