package codexhx.runtime.model.streamitem;

class ModelTerminalStopHookRequest {
	public final requestId:String;
	public final integrationOutcome:ModelSamplingResultIntegrationOutcome;
	public final promptPreparationOutcome:ModelPromptPreparationOutcome;
	public final targetKind:ModelTerminalStopHookTargetKind;
	public final previewRunCount:Int;
	public final completedRunCount:Int;
	public final completedRunStatusKind:ModelTerminalStopHookRunStatusKind;
	public final shouldBlock:Bool;
	public final continuationFragmentCount:Int;
	public final continuationPromptRenderable:Bool;
	public final shouldStop:Bool;
	public final legacyAfterAgentEnabled:Bool;
	public final legacyAfterAgentAbort:Bool;
	public final stopHookAlreadyActive:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		integrationOutcome:ModelSamplingResultIntegrationOutcome,
		promptPreparationOutcome:ModelPromptPreparationOutcome,
		targetKind:ModelTerminalStopHookTargetKind,
		previewRunCount:Int,
		completedRunCount:Int,
		completedRunStatusKind:ModelTerminalStopHookRunStatusKind,
		shouldBlock:Bool,
		continuationFragmentCount:Int,
		continuationPromptRenderable:Bool,
		shouldStop:Bool,
		legacyAfterAgentEnabled:Bool,
		legacyAfterAgentAbort:Bool,
		stopHookAlreadyActive:Bool,
		secretProbe:String
	) {
		this.requestId = requestId == null ? "" : requestId;
		this.integrationOutcome = integrationOutcome;
		this.promptPreparationOutcome = promptPreparationOutcome;
		this.targetKind = targetKind == null ? ModelTerminalStopHookTargetKind.Stop : targetKind;
		this.previewRunCount = previewRunCount < 0 ? 0 : previewRunCount;
		this.completedRunCount = completedRunCount < 0 ? 0 : completedRunCount;
		this.completedRunStatusKind = completedRunStatusKind == null ? ModelTerminalStopHookRunStatusKind.Completed : completedRunStatusKind;
		this.shouldBlock = shouldBlock;
		this.continuationFragmentCount = continuationFragmentCount < 0 ? 0 : continuationFragmentCount;
		this.continuationPromptRenderable = continuationPromptRenderable;
		this.shouldStop = shouldStop;
		this.legacyAfterAgentEnabled = legacyAfterAgentEnabled;
		this.legacyAfterAgentAbort = legacyAfterAgentAbort;
		this.stopHookAlreadyActive = stopHookAlreadyActive;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
