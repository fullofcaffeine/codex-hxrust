package codexhx.runtime.app.threadread;

class ThreadReadGoalToolExecutorDescriptor {
	public final kind:ThreadReadGoalToolExecutorKind;
	public final toolNamespace:String;
	public final toolName:String;
	public final threadId:String;
	public final stateDbAttached:Bool;
	public final accountingStateAttached:Bool;
	public final analyticsAttached:Bool;
	public final eventEmitterAttached:Bool;
	public final metricsAttached:Bool;
	public final orderIndex:Int;

	public function new(kind:ThreadReadGoalToolExecutorKind, toolNamespace:String, toolName:String, threadId:String, stateDbAttached:Bool,
			accountingStateAttached:Bool, analyticsAttached:Bool, eventEmitterAttached:Bool, metricsAttached:Bool, orderIndex:Int) {
		this.kind = kind;
		this.toolNamespace = toolNamespace;
		this.toolName = toolName;
		this.threadId = threadId;
		this.stateDbAttached = stateDbAttached;
		this.accountingStateAttached = accountingStateAttached;
		this.analyticsAttached = analyticsAttached;
		this.eventEmitterAttached = eventEmitterAttached;
		this.metricsAttached = metricsAttached;
		this.orderIndex = orderIndex;
	}

	public function summary():String {
		return "index="
			+ Std.string(orderIndex)
			+ ";kind="
			+ kind
			+ ";tool="
			+ (toolNamespace.length == 0 ? toolName : toolNamespace + "." + toolName)
			+ ";thread="
			+ threadId
			+ ";stateDb="
			+ boolText(stateDbAttached)
			+ ";accounting="
			+ boolText(accountingStateAttached)
			+ ";analytics="
			+ boolText(analyticsAttached)
			+ ";events="
			+ boolText(eventEmitterAttached)
			+ ";metrics="
			+ boolText(metricsAttached);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
