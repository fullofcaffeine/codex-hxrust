package codexhx.runtime.model.streamitem;

class ModelClearOnlySkillWarningRerenderPolicy {
	public static function apply(request:ModelClearOnlySkillWarningRerenderRequest):ModelClearOnlySkillWarningRerenderOutcome {
		if (request == null) return failure("", "missing clear-only skill warning rerender request");

		final warningKeyPresent = request.warningPath.length > 0 && request.warningMessage.length > 0;
		final firstWarningRendered = warningKeyPresent && request.firstScanInputCount == 1;
		final repeatedWarningSuppressed = firstWarningRendered && request.repeatedScanInputCount == 1;
		final resetClearedWarningMemory = request.resetInvoked && request.clearOnlyResetClearsWarnings;
		final postResetWarningRenderedAgain = resetClearedWarningMemory && warningKeyPresent && request.postResetScanInputCount == 1;
		final sameWarningKeyReused = firstWarningRendered && repeatedWarningSuppressed && postResetWarningRenderedAgain;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = postResetWarningRenderedAgain
			? ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningRerenderEnabled
			: repeatedWarningSuppressed
				? ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningStillSuppressed
				: ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningUnavailable;
		final ok = warningKeyPresent
			&& firstWarningRendered
			&& repeatedWarningSuppressed
			&& resetClearedWarningMemory
			&& postResetWarningRenderedAgain
			&& sameWarningKeyReused
			&& eventOrderingPreserved;

		return new ModelClearOnlySkillWarningRerenderOutcome({
			ok: ok,
			code: ok ? "clear_only_skill_warning_rerender_modeled" : "clear_only_skill_warning_rerender_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			warningKeyPresent: warningKeyPresent,
			firstWarningRendered: firstWarningRendered,
			repeatedWarningSuppressed: repeatedWarningSuppressed,
			resetClearedWarningMemory: resetClearedWarningMemory,
			postResetWarningRenderedAgain: postResetWarningRenderedAgain,
			sameWarningKeyReused: sameWarningKeyReused,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "clear-only skill warning rerender invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelClearOnlySkillWarningRerenderOutcome {
		return new ModelClearOnlySkillWarningRerenderOutcome({
			ok: false,
			code: "clear_only_skill_warning_rerender_failed",
			requestId: requestId,
			decisionKind: ModelClearOnlySkillWarningRerenderDecisionKind.SkillWarningUnavailable,
			warningKeyPresent: false,
			firstWarningRendered: false,
			repeatedWarningSuppressed: false,
			resetClearedWarningMemory: false,
			postResetWarningRenderedAgain: false,
			sameWarningKeyReused: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
