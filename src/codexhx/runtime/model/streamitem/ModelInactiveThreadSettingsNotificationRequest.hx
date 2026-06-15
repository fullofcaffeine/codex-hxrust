package codexhx.runtime.model.streamitem;

typedef ModelInactiveThreadSettingsNotificationRequestFields = {
	final requestId:String;
	final primaryThreadId:String;
	final inactiveThreadId:String;
	final activeThreadId:String;
	final primaryThreadRegistered:Bool;
	final inactiveThreadChannelPresent:Bool;
	final inactiveSessionCached:Bool;
	final notificationKindThreadSettingsUpdated:Bool;
	final notificationThreadMatchesInactive:Bool;
	final initialPrimaryModel:String;
	final initialPrimaryEffort:String;
	final initialInactiveModel:String;
	final initialInactiveEffort:String;
	final notificationModel:String;
	final notificationEffort:String;
	final notificationModelProvider:String;
	final notificationServiceTier:String;
	final notificationApprovalPolicy:String;
	final notificationApprovalsReviewer:String;
	final notificationSandboxPolicy:String;
	final notificationActivePermissionProfile:String;
	final notificationCollaborationMode:String;
	final notificationCollaborationModel:String;
	final notificationCollaborationEffort:String;
	final notificationPersonality:String;
	final handoffToChatWidget:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelInactiveThreadSettingsNotificationRequest {
	public final requestId:String;
	public final primaryThreadId:String;
	public final inactiveThreadId:String;
	public final activeThreadId:String;
	public final primaryThreadRegistered:Bool;
	public final inactiveThreadChannelPresent:Bool;
	public final inactiveSessionCached:Bool;
	public final notificationKindThreadSettingsUpdated:Bool;
	public final notificationThreadMatchesInactive:Bool;
	public final initialPrimaryModel:String;
	public final initialPrimaryEffort:String;
	public final initialInactiveModel:String;
	public final initialInactiveEffort:String;
	public final notificationModel:String;
	public final notificationEffort:String;
	public final notificationModelProvider:String;
	public final notificationServiceTier:String;
	public final notificationApprovalPolicy:String;
	public final notificationApprovalsReviewer:String;
	public final notificationSandboxPolicy:String;
	public final notificationActivePermissionProfile:String;
	public final notificationCollaborationMode:String;
	public final notificationCollaborationModel:String;
	public final notificationCollaborationEffort:String;
	public final notificationPersonality:String;
	public final handoffToChatWidget:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelInactiveThreadSettingsNotificationRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.primaryThreadId = fields.primaryThreadId == null ? "" : fields.primaryThreadId;
		this.inactiveThreadId = fields.inactiveThreadId == null ? "" : fields.inactiveThreadId;
		this.activeThreadId = fields.activeThreadId == null ? "" : fields.activeThreadId;
		this.primaryThreadRegistered = fields.primaryThreadRegistered;
		this.inactiveThreadChannelPresent = fields.inactiveThreadChannelPresent;
		this.inactiveSessionCached = fields.inactiveSessionCached;
		this.notificationKindThreadSettingsUpdated = fields.notificationKindThreadSettingsUpdated;
		this.notificationThreadMatchesInactive = fields.notificationThreadMatchesInactive;
		this.initialPrimaryModel = fields.initialPrimaryModel == null ? "" : fields.initialPrimaryModel;
		this.initialPrimaryEffort = fields.initialPrimaryEffort == null ? "" : fields.initialPrimaryEffort;
		this.initialInactiveModel = fields.initialInactiveModel == null ? "" : fields.initialInactiveModel;
		this.initialInactiveEffort = fields.initialInactiveEffort == null ? "" : fields.initialInactiveEffort;
		this.notificationModel = fields.notificationModel == null ? "" : fields.notificationModel;
		this.notificationEffort = fields.notificationEffort == null ? "" : fields.notificationEffort;
		this.notificationModelProvider = fields.notificationModelProvider == null ? "" : fields.notificationModelProvider;
		this.notificationServiceTier = fields.notificationServiceTier == null ? "" : fields.notificationServiceTier;
		this.notificationApprovalPolicy = fields.notificationApprovalPolicy == null ? "" : fields.notificationApprovalPolicy;
		this.notificationApprovalsReviewer = fields.notificationApprovalsReviewer == null ? "" : fields.notificationApprovalsReviewer;
		this.notificationSandboxPolicy = fields.notificationSandboxPolicy == null ? "" : fields.notificationSandboxPolicy;
		this.notificationActivePermissionProfile = fields.notificationActivePermissionProfile == null ? "" : fields.notificationActivePermissionProfile;
		this.notificationCollaborationMode = fields.notificationCollaborationMode == null ? "" : fields.notificationCollaborationMode;
		this.notificationCollaborationModel = fields.notificationCollaborationModel == null ? "" : fields.notificationCollaborationModel;
		this.notificationCollaborationEffort = fields.notificationCollaborationEffort == null ? "" : fields.notificationCollaborationEffort;
		this.notificationPersonality = fields.notificationPersonality == null ? "" : fields.notificationPersonality;
		this.handoffToChatWidget = fields.handoffToChatWidget;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
