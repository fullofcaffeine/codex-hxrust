package codexhx.runtime.app.persistence;

class PersistedThreadHistorySummary {
	public final includeTurns:Bool;
	public final historyItemCount:Int;
	public final persistedItemCount:Int;
	public final visibleTurnCount:Int;
	public final pendingPersistCount:Int;

	public function new(includeTurns:Bool, historyItemCount:Int, persistedItemCount:Int) {
		this.includeTurns = includeTurns;
		this.historyItemCount = historyItemCount;
		this.persistedItemCount = persistedItemCount;
		this.visibleTurnCount = includeTurns ? historyItemCount : 0;
		this.pendingPersistCount = historyItemCount - persistedItemCount;
	}

	public function mode():String {
		return includeTurns ? "history_included" : "metadata_only";
	}

	public function summary():String {
		return "turns=" + Std.string(visibleTurnCount) + ";history=" + Std.string(historyItemCount) + ";persisted=" + Std.string(persistedItemCount)
			+ ";pending=" + Std.string(pendingPersistCount) + ";mode=" + mode();
	}
}
