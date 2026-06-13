package codexhx.runtime.app.threadread;

class ThreadReadActiveTurnGoalSteeringInjectionRequest {
	public final steeringOutcome:ThreadReadGoalSteeringOutcome;
	public final threadManagerAvailable:Bool;
	public final liveThreadAvailable:Bool;
	public final activeTurnRunning:Bool;

	public function new(
		steeringOutcome:ThreadReadGoalSteeringOutcome,
		threadManagerAvailable:Bool,
		liveThreadAvailable:Bool,
		activeTurnRunning:Bool
	) {
		this.steeringOutcome = steeringOutcome;
		this.threadManagerAvailable = threadManagerAvailable;
		this.liveThreadAvailable = liveThreadAvailable;
		this.activeTurnRunning = activeTurnRunning;
	}
}
