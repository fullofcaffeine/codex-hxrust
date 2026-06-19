package codexhx.runtime.model.streamitem;

class ModelThreadSideThreadStartRequest {
	public final requestId:String;
	public final cleanupOutcome:ModelThreadSideThreadDiscardOutcome;
	public final primaryThreadAvailable:Bool;
	public final sideThreadAlreadyOpen:Bool;
	public final parentModel:String;
	public final parentReasoningEffort:String;
	public final parentServiceTier:String;
	public final parentApprovalPolicy:String;
	public final parentPermissionProfile:String;
	public final parentApprovalsReviewer:String;
	public final existingDeveloperInstructions:String;
	public final userMessageProvided:Bool;
	public final forkSucceeded:Bool;
	public final forkErrorMessage:String;
	public final injectBoundarySucceeded:Bool;
	public final switchSucceeded:Bool;
	public final activeChildAfterSwitch:Bool;
	public final discardCleanupSucceeded:Bool;
	public final activeThreadRestoredToParent:Bool;
	public final eventOrderIndex:Int;
	public final previousEventCount:Int;
	public final secretProbe:String;

	public function new(requestId:String, cleanupOutcome:ModelThreadSideThreadDiscardOutcome, primaryThreadAvailable:Bool, sideThreadAlreadyOpen:Bool,
			parentModel:String, parentReasoningEffort:String, parentServiceTier:String, parentApprovalPolicy:String, parentPermissionProfile:String,
			parentApprovalsReviewer:String, existingDeveloperInstructions:String, userMessageProvided:Bool, forkSucceeded:Bool, forkErrorMessage:String,
			injectBoundarySucceeded:Bool, switchSucceeded:Bool, activeChildAfterSwitch:Bool, discardCleanupSucceeded:Bool, activeThreadRestoredToParent:Bool,
			eventOrderIndex:Int, previousEventCount:Int, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.cleanupOutcome = cleanupOutcome;
		this.primaryThreadAvailable = primaryThreadAvailable;
		this.sideThreadAlreadyOpen = sideThreadAlreadyOpen;
		this.parentModel = parentModel == null ? "" : parentModel;
		this.parentReasoningEffort = parentReasoningEffort == null ? "" : parentReasoningEffort;
		this.parentServiceTier = parentServiceTier == null ? "" : parentServiceTier;
		this.parentApprovalPolicy = parentApprovalPolicy == null ? "" : parentApprovalPolicy;
		this.parentPermissionProfile = parentPermissionProfile == null ? "" : parentPermissionProfile;
		this.parentApprovalsReviewer = parentApprovalsReviewer == null ? "" : parentApprovalsReviewer;
		this.existingDeveloperInstructions = existingDeveloperInstructions == null ? "" : existingDeveloperInstructions;
		this.userMessageProvided = userMessageProvided;
		this.forkSucceeded = forkSucceeded;
		this.forkErrorMessage = forkErrorMessage == null ? "" : forkErrorMessage;
		this.injectBoundarySucceeded = injectBoundarySucceeded;
		this.switchSucceeded = switchSucceeded;
		this.activeChildAfterSwitch = activeChildAfterSwitch;
		this.discardCleanupSucceeded = discardCleanupSucceeded;
		this.activeThreadRestoredToParent = activeThreadRestoredToParent;
		this.eventOrderIndex = eventOrderIndex;
		this.previousEventCount = previousEventCount;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
