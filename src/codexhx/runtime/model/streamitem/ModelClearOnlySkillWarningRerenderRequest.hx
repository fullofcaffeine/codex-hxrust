package codexhx.runtime.model.streamitem;

typedef ModelClearOnlySkillWarningRerenderRequestFields = {
	final requestId:String;
	final warningPath:String;
	final warningMessage:String;
	final firstScanInputCount:Int;
	final repeatedScanInputCount:Int;
	final postResetScanInputCount:Int;
	final resetInvoked:Bool;
	final clearOnlyResetClearsWarnings:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelClearOnlySkillWarningRerenderRequest {
	public final requestId:String;
	public final warningPath:String;
	public final warningMessage:String;
	public final firstScanInputCount:Int;
	public final repeatedScanInputCount:Int;
	public final postResetScanInputCount:Int;
	public final resetInvoked:Bool;
	public final clearOnlyResetClearsWarnings:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelClearOnlySkillWarningRerenderRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.warningPath = fields.warningPath == null ? "" : fields.warningPath;
		this.warningMessage = fields.warningMessage == null ? "" : fields.warningMessage;
		this.firstScanInputCount = fields.firstScanInputCount;
		this.repeatedScanInputCount = fields.repeatedScanInputCount;
		this.postResetScanInputCount = fields.postResetScanInputCount;
		this.resetInvoked = fields.resetInvoked;
		this.clearOnlyResetClearsWarnings = fields.clearOnlyResetClearsWarnings;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
