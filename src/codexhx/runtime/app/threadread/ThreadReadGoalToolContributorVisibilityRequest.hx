package codexhx.runtime.app.threadread;

class ThreadReadGoalToolContributorVisibilityRequest {
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final toolsAvailableForThread:Bool;
	public final threadId:String;
	public final stateDbAvailable:Bool;
	public final accountingStateAvailable:Bool;
	public final analyticsAvailable:Bool;
	public final eventEmitterAvailable:Bool;
	public final metricsAvailable:Bool;

	public function new(
		runtimeAvailable:Bool,
		runtimeEnabled:Bool,
		toolsAvailableForThread:Bool,
		threadId:String,
		stateDbAvailable:Bool,
		accountingStateAvailable:Bool,
		analyticsAvailable:Bool,
		eventEmitterAvailable:Bool,
		metricsAvailable:Bool
	) {
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.toolsAvailableForThread = toolsAvailableForThread;
		this.threadId = threadId;
		this.stateDbAvailable = stateDbAvailable;
		this.accountingStateAvailable = accountingStateAvailable;
		this.analyticsAvailable = analyticsAvailable;
		this.eventEmitterAvailable = eventEmitterAvailable;
		this.metricsAvailable = metricsAvailable;
	}
}
