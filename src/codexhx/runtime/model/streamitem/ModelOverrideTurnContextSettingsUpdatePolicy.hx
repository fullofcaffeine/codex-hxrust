package codexhx.runtime.model.streamitem;

class ModelOverrideTurnContextSettingsUpdatePolicy {
	public static function apply(request:ModelOverrideTurnContextSettingsUpdateRequest):ModelOverrideTurnContextSettingsUpdateOutcome {
		if (request == null) return failure("", "missing override-turn-context settings update request");

		final canHandle = request.appCommandOverrideTurnContext
			&& request.primaryThreadRegistered
			&& request.threadId.length > 0
			&& request.appServerSessionAvailable;
		final threadSettingsUpdateSubmitted = canHandle && request.hasSettingsChanges;
		final handled = canHandle;
		final updateParamsCarriedRequestedSettings = threadSettingsUpdateSubmitted
			&& request.requestedModel.length > 0
			&& request.requestedEffort.length > 0
			&& request.requestedServiceTier.length > 0
			&& request.requestedApprovalPolicy.length > 0
			&& request.requestedApprovalsReviewer.length > 0
			&& request.requestedActivePermissionProfile.length > 0
			&& request.requestedCollaborationMode.length > 0
			&& request.requestedPersonality.length > 0;
		final cachedPrimarySessionUnchangedBeforeNotification = threadSettingsUpdateSubmitted;
		final notificationAppliedToCache = request.notificationReceived && threadSettingsUpdateSubmitted;
		final defaultMode = request.requestedCollaborationMode == "default";
		final primarySessionModelPreserved = notificationAppliedToCache && (!defaultMode || request.requestedModel == request.initialModel);
		final primarySessionEffortPreserved = notificationAppliedToCache && (!defaultMode || request.requestedEffort == request.initialEffort);
		final collaborationModeCached = notificationAppliedToCache && request.requestedCollaborationMode.length > 0;
		final collaborationSettingsRebasedToNotification = collaborationModeCached
			&& request.requestedCollaborationModel == request.requestedModel
			&& request.requestedCollaborationEffort == request.requestedEffort;
		final serviceTierCached = notificationAppliedToCache && request.requestedServiceTier.length > 0;
		final approvalPolicyCached = notificationAppliedToCache && request.requestedApprovalPolicy.length > 0;
		final approvalsReviewerCached = notificationAppliedToCache && request.requestedApprovalsReviewer.length > 0;
		final activePermissionProfileSubmitted = threadSettingsUpdateSubmitted && request.requestedActivePermissionProfile.length > 0;
		final personalityCached = notificationAppliedToCache && request.requestedPersonality.length > 0;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = threadSettingsUpdateSubmitted
			? ModelOverrideTurnContextSettingsUpdateDecisionKind.ThreadSettingsUpdateSubmitted
			: handled
				? ModelOverrideTurnContextSettingsUpdateDecisionKind.NoSettingsChangesNoop
				: ModelOverrideTurnContextSettingsUpdateDecisionKind.OverrideTurnContextNotHandled;
		final ok = handled
			&& threadSettingsUpdateSubmitted
			&& updateParamsCarriedRequestedSettings
			&& cachedPrimarySessionUnchangedBeforeNotification
			&& request.notificationReceived
			&& notificationAppliedToCache
			&& primarySessionModelPreserved
			&& primarySessionEffortPreserved
			&& collaborationSettingsRebasedToNotification
			&& serviceTierCached
			&& approvalPolicyCached
			&& approvalsReviewerCached
			&& activePermissionProfileSubmitted
			&& personalityCached
			&& eventOrderingPreserved;

		return new ModelOverrideTurnContextSettingsUpdateOutcome({
			ok: ok,
			code: ok ? "override_turn_context_settings_update_modeled" : "override_turn_context_settings_update_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			handled: handled,
			threadSettingsUpdateSubmitted: threadSettingsUpdateSubmitted,
			updateParamsCarriedRequestedSettings: updateParamsCarriedRequestedSettings,
			cachedPrimarySessionUnchangedBeforeNotification: cachedPrimarySessionUnchangedBeforeNotification,
			notificationReceived: request.notificationReceived,
			notificationAppliedToCache: notificationAppliedToCache,
			primarySessionModelPreserved: primarySessionModelPreserved,
			primarySessionEffortPreserved: primarySessionEffortPreserved,
			collaborationModeCached: collaborationModeCached,
			collaborationSettingsRebasedToNotification: collaborationSettingsRebasedToNotification,
			serviceTierCached: serviceTierCached,
			approvalPolicyCached: approvalPolicyCached,
			approvalsReviewerCached: approvalsReviewerCached,
			activePermissionProfileSubmitted: activePermissionProfileSubmitted,
			personalityCached: personalityCached,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "override-turn-context settings update invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelOverrideTurnContextSettingsUpdateOutcome {
		return new ModelOverrideTurnContextSettingsUpdateOutcome({
			ok: false,
			code: "override_turn_context_settings_update_failed",
			requestId: requestId,
			decisionKind: ModelOverrideTurnContextSettingsUpdateDecisionKind.OverrideTurnContextNotHandled,
			handled: false,
			threadSettingsUpdateSubmitted: false,
			updateParamsCarriedRequestedSettings: false,
			cachedPrimarySessionUnchangedBeforeNotification: false,
			notificationReceived: false,
			notificationAppliedToCache: false,
			primarySessionModelPreserved: false,
			primarySessionEffortPreserved: false,
			collaborationModeCached: false,
			collaborationSettingsRebasedToNotification: false,
			serviceTierCached: false,
			approvalPolicyCached: false,
			approvalsReviewerCached: false,
			activePermissionProfileSubmitted: false,
			personalityCached: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
