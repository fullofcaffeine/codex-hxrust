package codexhx.runtime.tui.resume.live;

typedef AppServerBoundaryReportFields = {
	final requestIdsPreserved:Bool;
	final requestFieldsPreserved:Bool;
	final backpressureSeen:Bool;
	final errorMapped:Bool;
	final noCredentialOrModelTraffic:Bool;
	final stateDbUntouched:Bool;
	final pageRequests:Int;
	final pendingEvents:Int;
	final skippedEvents:Int;
	final frameRequests:Int;
	final renderCount:Int;
	final finalSnapshot:String;
	final renderSnapshots:Array<String>;
	final requestSummaries:Array<String>;
	final pollSummaries:Array<String>;
	final eventSummaries:Array<String>;
	final stateSummaries:Array<String>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class AppServerBoundaryReport {
	public final requestIdsPreserved:Bool;
	public final requestFieldsPreserved:Bool;
	public final backpressureSeen:Bool;
	public final errorMapped:Bool;
	public final noCredentialOrModelTraffic:Bool;
	public final stateDbUntouched:Bool;
	public final pageRequests:Int;
	public final pendingEvents:Int;
	public final skippedEvents:Int;
	public final frameRequests:Int;
	public final renderCount:Int;
	public final finalSnapshot:String;
	public final renderSnapshots:Array<String>;
	public final requestSummaries:Array<String>;
	public final pollSummaries:Array<String>;
	public final eventSummaries:Array<String>;
	public final stateSummaries:Array<String>;

	public function summary():String {
		return "requestIdsPreserved=" + boolLabel(requestIdsPreserved) + ";requestFieldsPreserved=" + boolLabel(requestFieldsPreserved)
			+ ";backpressureSeen=" + boolLabel(backpressureSeen) + ";errorMapped=" + boolLabel(errorMapped) + ";noCredentialOrModelTraffic="
			+ boolLabel(noCredentialOrModelTraffic) + ";stateDbUntouched=" + boolLabel(stateDbUntouched) + ";pageRequests=" + pageRequests + ";pending="
			+ pendingEvents + ";skipped=" + skippedEvents + ";frames=" + frameRequests + ";renders=" + renderCount + ";finalSnapshot="
			+ finalSnapshot.split("\n").join("\\n") + ";requests=[" + requestSummaries.join("##") + "]" + ";polls=[" + pollSummaries.join("##") + "]"
			+ ";events=[" + eventSummaries.join("##") + "]" + ";states=[" + stateSummaries.join("##") + "]";
	}

	static function boolLabel(value:Bool):String {
		return value ? "true" : "false";
	}
}
