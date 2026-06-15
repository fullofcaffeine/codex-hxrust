package codexhx.runtime.model.streamitem;

typedef ModelFeedbackSubmissionRoutingRequestFields = {
	final requestId:String;
	final requestKind:ModelFeedbackSubmissionRequestKind;
	final category:ModelFeedbackSubmissionCategory;
	final includeLogs:Bool;
	final resultOk:Bool;
	final resultThreadId:String;
	final resultErrorMessage:String;
	final originThreadProvided:Bool;
	final originThreadActive:Bool;
	final snapshotReplay:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelFeedbackSubmissionRoutingRequest {
	public final requestId:String;
	public final requestKind:ModelFeedbackSubmissionRequestKind;
	public final category:ModelFeedbackSubmissionCategory;
	public final includeLogs:Bool;
	public final resultOk:Bool;
	public final resultThreadId:String;
	public final resultErrorMessage:String;
	public final originThreadProvided:Bool;
	public final originThreadActive:Bool;
	public final snapshotReplay:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelFeedbackSubmissionRoutingRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.requestKind = fields.requestKind == null ? ModelFeedbackSubmissionRequestKind.Submitted : fields.requestKind;
		this.category = fields.category == null ? ModelFeedbackSubmissionCategory.Bug : fields.category;
		this.includeLogs = fields.includeLogs;
		this.resultOk = fields.resultOk;
		this.resultThreadId = fields.resultThreadId == null ? "" : fields.resultThreadId;
		this.resultErrorMessage = fields.resultErrorMessage == null ? "" : fields.resultErrorMessage;
		this.originThreadProvided = fields.originThreadProvided;
		this.originThreadActive = fields.originThreadActive;
		this.snapshotReplay = fields.snapshotReplay;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
