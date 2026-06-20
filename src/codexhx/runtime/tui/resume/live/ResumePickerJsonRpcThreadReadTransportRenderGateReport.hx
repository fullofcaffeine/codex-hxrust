package codexhx.runtime.tui.resume.live;

typedef ResumePickerJsonRpcThreadReadTransportRenderGateReportFields = {
	final requestShapePreserved:Bool;
	final previewDecoded:Bool;
	final transcriptDecoded:Bool;
	final errorMapped:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final transportEventSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerJsonRpcThreadReadTransportRenderGateReport {
	public final requestShapePreserved:Bool;
	public final previewDecoded:Bool;
	public final transcriptDecoded:Bool;
	public final errorMapped:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final transportEventSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return "requestShapePreserved=" + boolLabel(requestShapePreserved) + ";previewDecoded=" + boolLabel(previewDecoded) + ";transcriptDecoded="
			+ boolLabel(transcriptDecoded) + ";errorMapped=" + boolLabel(errorMapped) + ";noCredentialOrModelTraffic="
			+ boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";readRequests=" + readRequests + ";frames="
			+ frameRequests + ";renders=" + renderCount + ";finalSnapshot=" + finalSnapshot.split("\n").join("\\n") + ";requests=["
			+ requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##") + "]" + ";transportEvents=["
			+ transportEventSummaries.join("##") + "]" + ";hostEvents=[" + hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
