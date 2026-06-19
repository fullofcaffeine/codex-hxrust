package codexhx.runtime.app.threadread;

class ThreadReadGoalTokenUsageRecordRequest {
	public final turnStoreLevelId:String;
	public final currentTurnId:String;
	public final runtimeAvailable:Bool;
	public final runtimeEnabled:Bool;
	public final turnKnown:Bool;
	public final accountTokens:Bool;
	public final previousCurrentUsage:ThreadReadTokenUsageBreakdown;
	public final lastAccountedUsage:ThreadReadTokenUsageBreakdown;
	public final totalUsage:ThreadReadTokenUsageBreakdown;
	public final otherUnflushedTokenDelta:Int;

	public function new(turnStoreLevelId:String, currentTurnId:String, runtimeAvailable:Bool, runtimeEnabled:Bool, turnKnown:Bool, accountTokens:Bool,
			previousCurrentUsage:ThreadReadTokenUsageBreakdown, lastAccountedUsage:ThreadReadTokenUsageBreakdown, totalUsage:ThreadReadTokenUsageBreakdown,
			otherUnflushedTokenDelta:Int) {
		this.turnStoreLevelId = turnStoreLevelId;
		this.currentTurnId = currentTurnId;
		this.runtimeAvailable = runtimeAvailable;
		this.runtimeEnabled = runtimeEnabled;
		this.turnKnown = turnKnown;
		this.accountTokens = accountTokens;
		this.previousCurrentUsage = previousCurrentUsage;
		this.lastAccountedUsage = lastAccountedUsage;
		this.totalUsage = totalUsage;
		this.otherUnflushedTokenDelta = otherUnflushedTokenDelta;
	}
}
