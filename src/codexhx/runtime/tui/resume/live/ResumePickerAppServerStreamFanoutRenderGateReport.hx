package codexhx.runtime.tui.resume.live;

typedef ResumePickerAppServerStreamFanoutRenderGateReportFields = {
	final requestShapePreserved:Bool;
	final pendingOwnershipModeled:Bool;
	final backpressureRouted:Bool;
	final jsonRpcErrorMapped:Bool;
	final pageDecoded:Bool;
	final previewDecoded:Bool;
	final transcriptDecoded:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final readRequests:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final transportSummaries:Array<String>;
	final transportEventSummaries:Array<String>;
	final fanoutSummaries:Array<String>;
	final hostEventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class ResumePickerAppServerStreamFanoutRenderGateReport {
	public final requestShapePreserved:Bool;
	public final pendingOwnershipModeled:Bool;
	public final backpressureRouted:Bool;
	public final jsonRpcErrorMapped:Bool;
	public final pageDecoded:Bool;
	public final previewDecoded:Bool;
	public final transcriptDecoded:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final readRequests:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final transportSummaries:Array<String>;
	public final transportEventSummaries:Array<String>;
	public final fanoutSummaries:Array<String>;
	public final hostEventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return "requestShapePreserved=" + boolLabel(requestShapePreserved) + ";pendingOwnershipModeled=" + boolLabel(pendingOwnershipModeled)
			+ ";backpressureRouted=" + boolLabel(backpressureRouted) + ";jsonRpcErrorMapped=" + boolLabel(jsonRpcErrorMapped) + ";pageDecoded="
			+ boolLabel(pageDecoded) + ";previewDecoded=" + boolLabel(previewDecoded) + ";transcriptDecoded=" + boolLabel(transcriptDecoded)
			+ ";noCredentialOrModelTraffic=" + boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests="
			+ pageRequests + ";readRequests=" + readRequests + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";requests=[" + requestSummaries.join("##") + "]" + ";transport=[" + transportSummaries.join("##")
			+ "]" + ";transportEvents=[" + transportEventSummaries.join("##") + "]" + ";fanout=[" + fanoutSummaries.join("##") + "]" + ";hostEvents=["
			+ hostEventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
