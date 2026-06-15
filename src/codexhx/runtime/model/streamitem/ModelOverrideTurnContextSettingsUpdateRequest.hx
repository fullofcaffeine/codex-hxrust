package codexhx.runtime.model.streamitem;

typedef ModelOverrideTurnContextSettingsUpdateRequestFields = {
	final requestId:String;
	final threadId:String;
	final appCommandOverrideTurnContext:Bool;
	final primaryThreadRegistered:Bool;
	final appServerSessionAvailable:Bool;
	final hasSettingsChanges:Bool;
	final initialModel:String;
	final initialEffort:String;
	final requestedModel:String;
	final requestedEffort:String;
	final requestedServiceTier:String;
	final requestedApprovalPolicy:String;
	final requestedApprovalsReviewer:String;
	final requestedActivePermissionProfile:String;
	final requestedCollaborationMode:String;
	final requestedCollaborationModel:String;
	final requestedCollaborationEffort:String;
	final requestedPersonality:String;
	final notificationReceived:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelOverrideTurnContextSettingsUpdateRequest {
	public final requestId:String;
	public final threadId:String;
	public final appCommandOverrideTurnContext:Bool;
	public final primaryThreadRegistered:Bool;
	public final appServerSessionAvailable:Bool;
	public final hasSettingsChanges:Bool;
	public final initialModel:String;
	public final initialEffort:String;
	public final requestedModel:String;
	public final requestedEffort:String;
	public final requestedServiceTier:String;
	public final requestedApprovalPolicy:String;
	public final requestedApprovalsReviewer:String;
	public final requestedActivePermissionProfile:String;
	public final requestedCollaborationMode:String;
	public final requestedCollaborationModel:String;
	public final requestedCollaborationEffort:String;
	public final requestedPersonality:String;
	public final notificationReceived:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelOverrideTurnContextSettingsUpdateRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.appCommandOverrideTurnContext = fields.appCommandOverrideTurnContext;
		this.primaryThreadRegistered = fields.primaryThreadRegistered;
		this.appServerSessionAvailable = fields.appServerSessionAvailable;
		this.hasSettingsChanges = fields.hasSettingsChanges;
		this.initialModel = fields.initialModel == null ? "" : fields.initialModel;
		this.initialEffort = fields.initialEffort == null ? "" : fields.initialEffort;
		this.requestedModel = fields.requestedModel == null ? "" : fields.requestedModel;
		this.requestedEffort = fields.requestedEffort == null ? "" : fields.requestedEffort;
		this.requestedServiceTier = fields.requestedServiceTier == null ? "" : fields.requestedServiceTier;
		this.requestedApprovalPolicy = fields.requestedApprovalPolicy == null ? "" : fields.requestedApprovalPolicy;
		this.requestedApprovalsReviewer = fields.requestedApprovalsReviewer == null ? "" : fields.requestedApprovalsReviewer;
		this.requestedActivePermissionProfile = fields.requestedActivePermissionProfile == null ? "" : fields.requestedActivePermissionProfile;
		this.requestedCollaborationMode = fields.requestedCollaborationMode == null ? "" : fields.requestedCollaborationMode;
		this.requestedCollaborationModel = fields.requestedCollaborationModel == null ? "" : fields.requestedCollaborationModel;
		this.requestedCollaborationEffort = fields.requestedCollaborationEffort == null ? "" : fields.requestedCollaborationEffort;
		this.requestedPersonality = fields.requestedPersonality == null ? "" : fields.requestedPersonality;
		this.notificationReceived = fields.notificationReceived;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
