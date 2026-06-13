package codexhx.runtime.app.threadread;

class ThreadReadTryStartTurnIfIdlePolicy {
	public static function buildCases(requests:Array<ThreadReadTryStartTurnIfIdleRequest>):ThreadReadTryStartTurnIfIdleReport {
		final outcomes:Array<ThreadReadTryStartTurnIfIdleOutcome> = [];
		for (request in requests) {
			outcomes.push(build(request));
		}
		return new ThreadReadTryStartTurnIfIdleReport(outcomes);
	}

	public static function build(request:ThreadReadTryStartTurnIfIdleRequest):ThreadReadTryStartTurnIfIdleOutcome {
		if (request.inputEmpty) return ThreadReadTryStartTurnIfIdleOutcome.makeEmptyInputNoop();

		final itemSummary = request.steeringOutcome == null ? "item=none" : request.steeringOutcome.itemSummary();
		if (request.steeringOutcome == null || !request.steeringOutcome.ok || !request.steeringOutcome.emitted || request.steeringOutcome.item == null) {
			return ThreadReadTryStartTurnIfIdleOutcome.failure(
				"steering_item_not_available",
				itemSummary,
				"try_start_turn_if_idle requires an emitted steering response item"
			);
		}

		if (request.pendingTriggerTurnBeforeReservation) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.PendingTriggerTurn,
				false,
				itemSummary,
				"pending trigger-turn mailbox is prioritized before automatic idle work"
			);
		}

		if (request.collaborationPlanModeBeforeReservation) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.PlanMode,
				false,
				itemSummary,
				"plan collaboration mode rejects automatic idle work before reservation"
			);
		}

		if (request.activeTaskKind == ThreadReadTryStartTurnIfIdleActiveTaskKind.Regular) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.Busy,
				false,
				itemSummary,
				"active regular turn keeps the original steering item untouched"
			);
		}

		if (request.activeTaskKind == ThreadReadTryStartTurnIfIdleActiveTaskKind.Review) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.Busy,
				false,
				itemSummary,
				"active review turn maps to the same busy rejection and preserves input"
			);
		}

		if (request.pendingTriggerTurnAfterReservation) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.PendingTriggerTurn,
				true,
				itemSummary,
				"pending trigger-turn mailbox wins after reservation and clears the reservation"
			);
		}

		if (request.collaborationPlanModeAfterTurnContext) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.PlanMode,
				true,
				itemSummary,
				"turn context observed plan mode and cleared the idle reservation"
			);
		}

		if (request.pendingTriggerTurnAfterTurnContext) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.PendingTriggerTurn,
				true,
				itemSummary,
				"pending trigger-turn mailbox is rechecked before task start"
			);
		}

		if (request.reservationLostBeforeStart) {
			return reject(
				ThreadReadTryStartTurnIfIdleRejectionReason.Busy,
				true,
				itemSummary,
				"idle reservation was lost before task start"
			);
		}

		return ThreadReadTryStartTurnIfIdleOutcome.makeAccepted(itemSummary);
	}

	static function reject(
		reason:ThreadReadTryStartTurnIfIdleRejectionReason,
		reservationCreated:Bool,
		itemSummary:String,
		message:String
	):ThreadReadTryStartTurnIfIdleOutcome {
		return ThreadReadTryStartTurnIfIdleOutcome.makeRejected(reason, reservationCreated, itemSummary, message);
	}
}
