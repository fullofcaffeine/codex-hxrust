package codexhx.runtime.tui.resume.host;

typedef ResumePickerThreadListResponseFields = {
	final requestId:String;
	final rows:Array<ResumePickerThreadRow>;
	final nextCursor:String;
	final scannedRows:Int;
	final acceptedRows:Int;
	final invalidRows:Int;
	final reachedScanCap:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerThreadListResponse {
	public final requestId:String;
	public final rows:Array<ResumePickerThreadRow>;
	public final nextCursor:String;
	public final scannedRows:Int;
	public final acceptedRows:Int;
	public final invalidRows:Int;
	public final reachedScanCap:Bool;

	public function summary():String {
		return "id=" + requestId + ";rows=" + rows.length + ";next=" + nextCursor + ";scanned=" + scannedRows + ";accepted=" + acceptedRows + ";invalid="
			+ invalidRows + ";scanCap=" + (reachedScanCap ? "true" : "false");
	}
}
