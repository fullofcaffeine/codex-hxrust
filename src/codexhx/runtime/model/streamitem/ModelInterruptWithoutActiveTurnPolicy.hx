package codexhx.runtime.model.streamitem;

class ModelInterruptWithoutActiveTurnPolicy {
	public static function apply(request:ModelInterruptWithoutActiveTurnRequest):ModelInterruptWithoutActiveTurnOutcome {
		if (request == null) return failure("", "missing interrupt without active turn request");

		final activeTurnPresent = request.activeTurnId.length > 0;
		final canSubmit = request.appCommandInterrupt
			&& request.primaryThreadRegistered
			&& request.threadId.length > 0
			&& request.appServerSessionAvailable;
		final turnInterruptSubmitted = canSubmit && activeTurnPresent;
		final startupInterruptSubmitted = canSubmit && !activeTurnPresent;
		final handled = (turnInterruptSubmitted || startupInterruptSubmitted) && (!startupInterruptSubmitted || request.startupInterruptSucceeded);
		final retryAttempted = false;
		final activeTurnRaceRetryUsed = false;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = turnInterruptSubmitted
			? ModelInterruptWithoutActiveTurnDecisionKind.ActiveTurnInterruptSubmitted
			: startupInterruptSubmitted
				? ModelInterruptWithoutActiveTurnDecisionKind.StartupInterruptSubmitted
				: ModelInterruptWithoutActiveTurnDecisionKind.InterruptNotHandled;
		final ok = request.appCommandInterrupt
			&& request.primaryThreadRegistered
			&& !activeTurnPresent
			&& startupInterruptSubmitted
			&& request.startupInterruptSucceeded
			&& handled
			&& !turnInterruptSubmitted
			&& !retryAttempted
			&& eventOrderingPreserved;

		return new ModelInterruptWithoutActiveTurnOutcome({
			ok: ok,
			code: ok ? "interrupt_without_active_turn_modeled" : "interrupt_without_active_turn_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			primaryThreadRegistered: request.primaryThreadRegistered,
			activeTurnPresent: activeTurnPresent,
			turnInterruptSubmitted: turnInterruptSubmitted,
			startupInterruptSubmitted: startupInterruptSubmitted,
			startupInterruptSucceeded: startupInterruptSubmitted && request.startupInterruptSucceeded,
			handled: handled,
			retryAttempted: retryAttempted,
			activeTurnRaceRetryUsed: activeTurnRaceRetryUsed,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "interrupt without active turn invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelInterruptWithoutActiveTurnOutcome {
		return new ModelInterruptWithoutActiveTurnOutcome({
			ok: false,
			code: "interrupt_without_active_turn_failed",
			requestId: requestId,
			decisionKind: ModelInterruptWithoutActiveTurnDecisionKind.InterruptNotHandled,
			primaryThreadRegistered: false,
			activeTurnPresent: false,
			turnInterruptSubmitted: false,
			startupInterruptSubmitted: false,
			startupInterruptSucceeded: false,
			handled: false,
			retryAttempted: false,
			activeTurnRaceRetryUsed: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
