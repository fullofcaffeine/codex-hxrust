package codexhx.runtime.tui.resume.live;

typedef ResumePickerInvalidRowProjectionRenderGateReportFields = {
	final pageLoads:Int;
	final scannedRows:Int;
	final acceptedRows:Int;
	final invalidRows:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final eventSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerInvalidRowProjectionRenderGateReport {
	public final pageLoads:Int;
	public final scannedRows:Int;
	public final acceptedRows:Int;
	public final invalidRows:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final eventSummaries:Array<String>;

	public function summary():String {
		return "pageLoads=" + pageLoads + ";scanned=" + scannedRows + ";accepted=" + acceptedRows + ";invalid=" + invalidRows + ";frames=" + frameRequests
			+ ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";events=[" + eventSummaries.join("##") + "]";
	}
}
