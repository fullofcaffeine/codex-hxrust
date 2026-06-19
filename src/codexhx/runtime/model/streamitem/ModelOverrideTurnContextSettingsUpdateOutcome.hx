package codexhx.runtime.model.streamitem;

typedef ModelOverrideTurnContextSettingsUpdateOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelOverrideTurnContextSettingsUpdateDecisionKind;
	final handled:Bool;
	final threadSettingsUpdateSubmitted:Bool;
	final updateParamsCarriedRequestedSettings:Bool;
	final cachedPrimarySessionUnchangedBeforeNotification:Bool;
	final notificationReceived:Bool;
	final notificationAppliedToCache:Bool;
	final primarySessionModelPreserved:Bool;
	final primarySessionEffortPreserved:Bool;
	final collaborationModeCached:Bool;
	final collaborationSettingsRebasedToNotification:Bool;
	final serviceTierCached:Bool;
	final approvalPolicyCached:Bool;
	final approvalsReviewerCached:Bool;
	final activePermissionProfileSubmitted:Bool;
	final personalityCached:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelOverrideTurnContextSettingsUpdateOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelOverrideTurnContextSettingsUpdateDecisionKind;
	public final handled:Bool;
	public final threadSettingsUpdateSubmitted:Bool;
	public final updateParamsCarriedRequestedSettings:Bool;
	public final cachedPrimarySessionUnchangedBeforeNotification:Bool;
	public final notificationReceived:Bool;
	public final notificationAppliedToCache:Bool;
	public final primarySessionModelPreserved:Bool;
	public final primarySessionEffortPreserved:Bool;
	public final collaborationModeCached:Bool;
	public final collaborationSettingsRebasedToNotification:Bool;
	public final serviceTierCached:Bool;
	public final approvalPolicyCached:Bool;
	public final approvalsReviewerCached:Bool;
	public final activePermissionProfileSubmitted:Bool;
	public final personalityCached:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelOverrideTurnContextSettingsUpdateOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelOverrideTurnContextSettingsUpdateDecisionKind.OverrideTurnContextNotHandled : fields.decisionKind;
		this.handled = fields.handled;
		this.threadSettingsUpdateSubmitted = fields.threadSettingsUpdateSubmitted;
		this.updateParamsCarriedRequestedSettings = fields.updateParamsCarriedRequestedSettings;
		this.cachedPrimarySessionUnchangedBeforeNotification = fields.cachedPrimarySessionUnchangedBeforeNotification;
		this.notificationReceived = fields.notificationReceived;
		this.notificationAppliedToCache = fields.notificationAppliedToCache;
		this.primarySessionModelPreserved = fields.primarySessionModelPreserved;
		this.primarySessionEffortPreserved = fields.primarySessionEffortPreserved;
		this.collaborationModeCached = fields.collaborationModeCached;
		this.collaborationSettingsRebasedToNotification = fields.collaborationSettingsRebasedToNotification;
		this.serviceTierCached = fields.serviceTierCached;
		this.approvalPolicyCached = fields.approvalPolicyCached;
		this.approvalsReviewerCached = fields.approvalsReviewerCached;
		this.activePermissionProfileSubmitted = fields.activePermissionProfileSubmitted;
		this.personalityCached = fields.personalityCached;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code="
			+ code
			+ ";ok="
			+ boolText(ok)
			+ ";request="
			+ requestId
			+ ";decisionKind="
			+ decisionKind
			+ ";handled="
			+ boolText(handled)
			+ ";threadSettingsUpdateSubmitted="
			+ boolText(threadSettingsUpdateSubmitted)
			+ ";updateParamsCarriedRequestedSettings="
			+ boolText(updateParamsCarriedRequestedSettings)
			+ ";cachedPrimarySessionUnchangedBeforeNotification="
			+ boolText(cachedPrimarySessionUnchangedBeforeNotification)
			+ ";notificationReceived="
			+ boolText(notificationReceived)
			+ ";notificationAppliedToCache="
			+ boolText(notificationAppliedToCache)
			+ ";primarySessionModelPreserved="
			+ boolText(primarySessionModelPreserved)
			+ ";primarySessionEffortPreserved="
			+ boolText(primarySessionEffortPreserved)
			+ ";collaborationModeCached="
			+ boolText(collaborationModeCached)
			+ ";collaborationSettingsRebasedToNotification="
			+ boolText(collaborationSettingsRebasedToNotification)
			+ ";serviceTierCached="
			+ boolText(serviceTierCached)
			+ ";approvalPolicyCached="
			+ boolText(approvalPolicyCached)
			+ ";approvalsReviewerCached="
			+ boolText(approvalsReviewerCached)
			+ ";activePermissionProfileSubmitted="
			+ boolText(activePermissionProfileSubmitted)
			+ ";personalityCached="
			+ boolText(personalityCached)
			+ ";eventOrderingPreserved="
			+ boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted="
			+ boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated="
			+ boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture="
			+ boolText(toolExecutedOutsideFixture)
			+ ";error="
			+ errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
