package codexhx.runtime.model.streamitem;

typedef ModelInactiveThreadSettingsNotificationOutcomeFields = {
	final ok:Bool;
	final code:String;
	final requestId:String;
	final decisionKind:ModelInactiveThreadSettingsNotificationDecisionKind;
	final notificationAccepted:Bool;
	final inactiveChannelRetained:Bool;
	final inactiveSessionUpdated:Bool;
	final primarySessionUnchanged:Bool;
	final inactiveSessionModelPreserved:Bool;
	final inactiveSessionEffortPreserved:Bool;
	final collaborationModeCached:Bool;
	final collaborationSettingsRebasedToNotification:Bool;
	final modelProviderCached:Bool;
	final serviceTierCached:Bool;
	final approvalPolicyCached:Bool;
	final approvalsReviewerCached:Bool;
	final permissionProfileCached:Bool;
	final activePermissionProfileCached:Bool;
	final personalityCached:Bool;
	final notificationBuffered:Bool;
	final chatWidgetHandoffApplied:Bool;
	final chatWidgetCollaborationModeActive:Bool;
	final chatWidgetCurrentModelFromCollaborationSettings:Bool;
	final chatWidgetCurrentCollaborationModeModelPreservesSessionModel:Bool;
	final chatWidgetCurrentEffortFromNotification:Bool;
	final chatWidgetPersonalityApplied:Bool;
	final eventOrderingPreserved:Bool;
	final liveNetworkAttempted:Bool;
	final realFilesystemMutated:Bool;
	final toolExecutedOutsideFixture:Bool;
	final errorMessage:String;
}

class ModelInactiveThreadSettingsNotificationOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final decisionKind:ModelInactiveThreadSettingsNotificationDecisionKind;
	public final notificationAccepted:Bool;
	public final inactiveChannelRetained:Bool;
	public final inactiveSessionUpdated:Bool;
	public final primarySessionUnchanged:Bool;
	public final inactiveSessionModelPreserved:Bool;
	public final inactiveSessionEffortPreserved:Bool;
	public final collaborationModeCached:Bool;
	public final collaborationSettingsRebasedToNotification:Bool;
	public final modelProviderCached:Bool;
	public final serviceTierCached:Bool;
	public final approvalPolicyCached:Bool;
	public final approvalsReviewerCached:Bool;
	public final permissionProfileCached:Bool;
	public final activePermissionProfileCached:Bool;
	public final personalityCached:Bool;
	public final notificationBuffered:Bool;
	public final chatWidgetHandoffApplied:Bool;
	public final chatWidgetCollaborationModeActive:Bool;
	public final chatWidgetCurrentModelFromCollaborationSettings:Bool;
	public final chatWidgetCurrentCollaborationModeModelPreservesSessionModel:Bool;
	public final chatWidgetCurrentEffortFromNotification:Bool;
	public final chatWidgetPersonalityApplied:Bool;
	public final eventOrderingPreserved:Bool;
	public final liveNetworkAttempted:Bool;
	public final realFilesystemMutated:Bool;
	public final toolExecutedOutsideFixture:Bool;
	public final errorMessage:String;

	public function new(fields:ModelInactiveThreadSettingsNotificationOutcomeFields) {
		this.ok = fields.ok;
		this.code = fields.code == null ? "" : fields.code;
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.decisionKind = fields.decisionKind == null ? ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationUnavailable : fields.decisionKind;
		this.notificationAccepted = fields.notificationAccepted;
		this.inactiveChannelRetained = fields.inactiveChannelRetained;
		this.inactiveSessionUpdated = fields.inactiveSessionUpdated;
		this.primarySessionUnchanged = fields.primarySessionUnchanged;
		this.inactiveSessionModelPreserved = fields.inactiveSessionModelPreserved;
		this.inactiveSessionEffortPreserved = fields.inactiveSessionEffortPreserved;
		this.collaborationModeCached = fields.collaborationModeCached;
		this.collaborationSettingsRebasedToNotification = fields.collaborationSettingsRebasedToNotification;
		this.modelProviderCached = fields.modelProviderCached;
		this.serviceTierCached = fields.serviceTierCached;
		this.approvalPolicyCached = fields.approvalPolicyCached;
		this.approvalsReviewerCached = fields.approvalsReviewerCached;
		this.permissionProfileCached = fields.permissionProfileCached;
		this.activePermissionProfileCached = fields.activePermissionProfileCached;
		this.personalityCached = fields.personalityCached;
		this.notificationBuffered = fields.notificationBuffered;
		this.chatWidgetHandoffApplied = fields.chatWidgetHandoffApplied;
		this.chatWidgetCollaborationModeActive = fields.chatWidgetCollaborationModeActive;
		this.chatWidgetCurrentModelFromCollaborationSettings = fields.chatWidgetCurrentModelFromCollaborationSettings;
		this.chatWidgetCurrentCollaborationModeModelPreservesSessionModel = fields.chatWidgetCurrentCollaborationModeModelPreservesSessionModel;
		this.chatWidgetCurrentEffortFromNotification = fields.chatWidgetCurrentEffortFromNotification;
		this.chatWidgetPersonalityApplied = fields.chatWidgetPersonalityApplied;
		this.eventOrderingPreserved = fields.eventOrderingPreserved;
		this.liveNetworkAttempted = fields.liveNetworkAttempted;
		this.realFilesystemMutated = fields.realFilesystemMutated;
		this.toolExecutedOutsideFixture = fields.toolExecutedOutsideFixture;
		this.errorMessage = fields.errorMessage == null ? "" : fields.errorMessage;
	}

	public function summary():String {
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";decisionKind=" + decisionKind
			+ ";notificationAccepted=" + boolText(notificationAccepted)
			+ ";inactiveChannelRetained=" + boolText(inactiveChannelRetained)
			+ ";inactiveSessionUpdated=" + boolText(inactiveSessionUpdated)
			+ ";primarySessionUnchanged=" + boolText(primarySessionUnchanged)
			+ ";inactiveSessionModelPreserved=" + boolText(inactiveSessionModelPreserved)
			+ ";inactiveSessionEffortPreserved=" + boolText(inactiveSessionEffortPreserved)
			+ ";collaborationModeCached=" + boolText(collaborationModeCached)
			+ ";collaborationSettingsRebasedToNotification=" + boolText(collaborationSettingsRebasedToNotification)
			+ ";modelProviderCached=" + boolText(modelProviderCached)
			+ ";serviceTierCached=" + boolText(serviceTierCached)
			+ ";approvalPolicyCached=" + boolText(approvalPolicyCached)
			+ ";approvalsReviewerCached=" + boolText(approvalsReviewerCached)
			+ ";permissionProfileCached=" + boolText(permissionProfileCached)
			+ ";activePermissionProfileCached=" + boolText(activePermissionProfileCached)
			+ ";personalityCached=" + boolText(personalityCached)
			+ ";notificationBuffered=" + boolText(notificationBuffered)
			+ ";chatWidgetHandoffApplied=" + boolText(chatWidgetHandoffApplied)
			+ ";chatWidgetCollaborationModeActive=" + boolText(chatWidgetCollaborationModeActive)
			+ ";chatWidgetCurrentModelFromCollaborationSettings=" + boolText(chatWidgetCurrentModelFromCollaborationSettings)
			+ ";chatWidgetCurrentCollaborationModeModelPreservesSessionModel=" + boolText(chatWidgetCurrentCollaborationModeModelPreservesSessionModel)
			+ ";chatWidgetCurrentEffortFromNotification=" + boolText(chatWidgetCurrentEffortFromNotification)
			+ ";chatWidgetPersonalityApplied=" + boolText(chatWidgetPersonalityApplied)
			+ ";eventOrderingPreserved=" + boolText(eventOrderingPreserved)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";realFilesystemMutated=" + boolText(realFilesystemMutated)
			+ ";toolExecutedOutsideFixture=" + boolText(toolExecutedOutsideFixture)
			+ ";error=" + errorMessage;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
