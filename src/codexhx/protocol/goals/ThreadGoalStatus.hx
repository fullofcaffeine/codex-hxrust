package codexhx.protocol.goals;

class ThreadGoalStatus {
	public static inline final Active = "active";
	public static inline final Paused = "paused";
	public static inline final Blocked = "blocked";
	public static inline final UsageLimited = "usageLimited";
	public static inline final BudgetLimited = "budgetLimited";
	public static inline final Complete = "complete";

	public static function isValid(value:String):Bool {
		return value == Active || value == Paused || value == Blocked || value == UsageLimited || value == BudgetLimited || value == Complete;
	}

	public static function isTerminal(value:String):Bool {
		return value == BudgetLimited || value == Complete;
	}
}
