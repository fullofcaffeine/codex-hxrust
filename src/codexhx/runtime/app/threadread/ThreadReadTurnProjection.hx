package codexhx.runtime.app.threadread;

class ThreadReadTurnProjection {
	public static function projectCases(cases:Array<Array<RolloutSummaryItem>>):ThreadReadTurnProjectionReport {
		final outcomes:Array<ThreadReadTurnProjectionOutcome> = [];
		for (items in cases) {
			outcomes.push(project(items));
		}
		return new ThreadReadTurnProjectionReport(outcomes);
	}

	public static function project(items:Array<RolloutSummaryItem>):ThreadReadTurnProjectionOutcome {
		final state = new ProjectionState();
		var index = 0;
		while (index < items.length) {
			final item = items[index];
			final validation = validateItem(item, index);
			if (!validation.ok) return validation;
			applyItem(state, item, index);
			index = index + 1;
		}
		state.finishCurrent();
		return ThreadReadTurnProjectionOutcome.success(state.turns);
	}

	static function validateItem(item:RolloutSummaryItem, index:Int):ThreadReadTurnProjectionOutcome {
		if (item == null) {
			return ThreadReadTurnProjectionOutcome.failure("invalid_rollout_item", "rollout item " + Std.string(index) + " is missing");
		}
		if (!RolloutSummaryItemKind.isValid(item.kind)) {
			return ThreadReadTurnProjectionOutcome.failure("invalid_rollout_item_kind", "unsupported rollout item kind at index " + Std.string(index));
		}
		if ((item.kind == RolloutSummaryItemKind.TurnStarted || item.kind == RolloutSummaryItemKind.TurnComplete || item.kind == RolloutSummaryItemKind.TurnAborted)
			&& item.turnId.length == 0) {
			return ThreadReadTurnProjectionOutcome.failure("missing_turn_id", "turn boundary item requires turnId at index " + Std.string(index));
		}
		if ((item.kind == RolloutSummaryItemKind.UserMessage || item.kind == RolloutSummaryItemKind.AgentMessage || item.kind == RolloutSummaryItemKind.CommandExecution)
			&& item.text.length == 0) {
			return ThreadReadTurnProjectionOutcome.failure("missing_item_text", "renderable rollout item requires text at index " + Std.string(index));
		}
		return ThreadReadTurnProjectionOutcome.success([]);
	}

	static function applyItem(state:ProjectionState, item:RolloutSummaryItem, index:Int):Void {
		if (item.kind == RolloutSummaryItemKind.TurnStarted) {
			state.finishCurrent();
			state.open(item.turnId, true, index);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.UserMessage) {
			if (state.hasImplicitCurrent()) state.finishCurrent();
			state.ensureCurrent("rollout-" + Std.string(index), false, index);
			state.addItem(ThreadReadTurnItemKind.UserMessage, item.text);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.AgentMessage) {
			state.ensureCurrent("rollout-" + Std.string(index), false, index);
			state.addItem(ThreadReadTurnItemKind.AgentMessage, item.text);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.CommandExecution) {
			state.ensureCurrent("rollout-" + Std.string(index), false, index);
			state.addItem(ThreadReadTurnItemKind.CommandExecution, item.text);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.Compacted) {
			state.ensureCurrent("rollout-" + Std.string(index), false, index);
			state.addItem(ThreadReadTurnItemKind.Compacted, item.text.length == 0 ? "compacted" : item.text);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.TurnComplete) {
			if (state.markStatus(item.turnId, ThreadReadTurnStatus.Completed)) state.finishCurrent();
			return;
		}
		if (item.kind == RolloutSummaryItemKind.TurnAborted) {
			state.markStatus(item.turnId, ThreadReadTurnStatus.Interrupted);
			return;
		}
		if (item.kind == RolloutSummaryItemKind.Error && item.affectsTurnStatus) {
			state.markActive(ThreadReadTurnStatus.Failed);
		}
	}
}

class ProjectionState {
	public final turns:Array<ThreadReadTurnSummary>;
	var currentId:String;
	var currentStatus:ThreadReadTurnStatus;
	var currentItems:Array<ThreadReadTurnItemSummary>;
	var currentOpen:Bool;
	var currentExplicit:Bool;

	public function new() {
		turns = [];
		currentId = "";
		currentStatus = ThreadReadTurnStatus.Completed;
		currentItems = [];
		currentOpen = false;
		currentExplicit = false;
	}

	public function hasImplicitCurrent():Bool {
		return currentOpen && !currentExplicit && currentItems.length > 0;
	}

	public function open(id:String, explicit:Bool, index:Int):Void {
		currentId = id.length == 0 ? "rollout-" + Std.string(index) : id;
		currentStatus = explicit ? ThreadReadTurnStatus.InProgress : ThreadReadTurnStatus.Completed;
		currentItems = [];
		currentOpen = true;
		currentExplicit = explicit;
	}

	public function ensureCurrent(fallbackId:String, explicit:Bool, index:Int):Void {
		if (!currentOpen) open(fallbackId, explicit, index);
	}

	public function addItem(kind:ThreadReadTurnItemKind, text:String):Void {
		currentItems.push(new ThreadReadTurnItemSummary(kind, text));
	}

	public function markActive(status:ThreadReadTurnStatus):Void {
		if (currentOpen) currentStatus = status;
	}

	public function markStatus(turnId:String, status:ThreadReadTurnStatus):Bool {
		if (currentOpen && currentId == turnId) {
			currentStatus = status;
			return true;
		}
		var i = 0;
		while (i < turns.length) {
			if (turns[i].id == turnId) {
				turns[i] = new ThreadReadTurnSummary(turns[i].id, status, turns[i].items);
				return false;
			}
			i = i + 1;
		}
		return false;
	}

	public function finishCurrent():Void {
		if (!currentOpen) return;
		if (currentItems.length > 0 || currentExplicit) {
			turns.push(new ThreadReadTurnSummary(currentId, currentStatus, currentItems));
		}
		currentId = "";
		currentStatus = ThreadReadTurnStatus.Completed;
		currentItems = [];
		currentOpen = false;
		currentExplicit = false;
	}
}
