package codexhx.runtime.model.streamitem;

class ModelInactiveThreadSettingsNotificationPolicy {
	public static function apply(request:ModelInactiveThreadSettingsNotificationRequest):ModelInactiveThreadSettingsNotificationOutcome {
		if (request == null)
			return failure("", "missing inactive-thread settings notification request");

		final inactiveTarget = request.inactiveThreadId.length > 0
			&& request.activeThreadId != request.inactiveThreadId
			&& request.primaryThreadId != request.inactiveThreadId;
		final notificationAccepted = request.notificationKindThreadSettingsUpdated
			&& request.notificationThreadMatchesInactive
			&& inactiveTarget
			&& request.primaryThreadRegistered
			&& request.inactiveThreadChannelPresent;
		final inactiveChannelRetained = notificationAccepted && request.inactiveThreadChannelPresent;
		final inactiveSessionUpdated = inactiveChannelRetained && request.inactiveSessionCached;
		final defaultMode = request.notificationCollaborationMode == "default";
		final primarySessionUnchanged = notificationAccepted && request.primaryThreadId == request.activeThreadId;
		final inactiveSessionModelPreserved = inactiveSessionUpdated
			&& (!defaultMode || request.notificationModel == request.initialInactiveModel);
		final inactiveSessionEffortPreserved = inactiveSessionUpdated
			&& (!defaultMode || request.notificationEffort == request.initialInactiveEffort);
		final collaborationModeCached = inactiveSessionUpdated && request.notificationCollaborationMode.length > 0;
		final collaborationSettingsRebasedToNotification = collaborationModeCached
			&& request.notificationCollaborationModel == request.notificationModel
			&& request.notificationCollaborationEffort == request.notificationEffort;
		final modelProviderCached = inactiveSessionUpdated && request.notificationModelProvider.length > 0;
		final serviceTierCached = inactiveSessionUpdated;
		final approvalPolicyCached = inactiveSessionUpdated && request.notificationApprovalPolicy.length > 0;
		final approvalsReviewerCached = inactiveSessionUpdated && request.notificationApprovalsReviewer.length > 0;
		final permissionProfileCached = inactiveSessionUpdated && request.notificationSandboxPolicy.length > 0;
		final activePermissionProfileCached = inactiveSessionUpdated && request.notificationActivePermissionProfile.length > 0;
		final personalityCached = inactiveSessionUpdated && request.notificationPersonality.length > 0;
		final notificationBuffered = notificationAccepted;
		final chatWidgetHandoffApplied = request.handoffToChatWidget && inactiveSessionUpdated;
		final chatWidgetCollaborationModeActive = chatWidgetHandoffApplied && request.notificationCollaborationMode.length > 0;
		final chatWidgetCurrentModelFromCollaborationSettings = chatWidgetHandoffApplied
			&& request.notificationCollaborationModel == request.notificationModel;
		final chatWidgetCurrentCollaborationModeModelPreservesSessionModel = chatWidgetHandoffApplied
			&& request.initialInactiveModel.length > 0
			&& request.initialInactiveModel != request.notificationModel;
		final chatWidgetCurrentEffortFromNotification = chatWidgetHandoffApplied
			&& request.notificationCollaborationEffort == request.notificationEffort
			&& request.notificationEffort.length > 0;
		final chatWidgetPersonalityApplied = chatWidgetHandoffApplied && personalityCached;
		final eventOrderingPreserved = request.eventOrderIndex == request.previousEventCount + 1;
		final decisionKind = notificationAccepted ? ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationCached : request.notificationKindThreadSettingsUpdated ? ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationIgnored : ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationUnavailable;
		final ok = notificationAccepted
			&& inactiveChannelRetained
			&& inactiveSessionUpdated
			&& primarySessionUnchanged
			&& inactiveSessionModelPreserved
			&& inactiveSessionEffortPreserved
			&& collaborationModeCached
			&& collaborationSettingsRebasedToNotification
			&& modelProviderCached
			&& serviceTierCached
			&& approvalPolicyCached
			&& approvalsReviewerCached
			&& permissionProfileCached
			&& activePermissionProfileCached
			&& personalityCached
			&& notificationBuffered
			&& chatWidgetHandoffApplied
			&& chatWidgetCollaborationModeActive
			&& chatWidgetCurrentModelFromCollaborationSettings
			&& chatWidgetCurrentCollaborationModeModelPreservesSessionModel
			&& chatWidgetCurrentEffortFromNotification
			&& chatWidgetPersonalityApplied
			&& eventOrderingPreserved;

		return new ModelInactiveThreadSettingsNotificationOutcome({
			ok: ok,
			code: ok ? "inactive_thread_settings_notification_modeled" : "inactive_thread_settings_notification_unmet",
			requestId: request.requestId,
			decisionKind: decisionKind,
			notificationAccepted: notificationAccepted,
			inactiveChannelRetained: inactiveChannelRetained,
			inactiveSessionUpdated: inactiveSessionUpdated,
			primarySessionUnchanged: primarySessionUnchanged,
			inactiveSessionModelPreserved: inactiveSessionModelPreserved,
			inactiveSessionEffortPreserved: inactiveSessionEffortPreserved,
			collaborationModeCached: collaborationModeCached,
			collaborationSettingsRebasedToNotification: collaborationSettingsRebasedToNotification,
			modelProviderCached: modelProviderCached,
			serviceTierCached: serviceTierCached,
			approvalPolicyCached: approvalPolicyCached,
			approvalsReviewerCached: approvalsReviewerCached,
			permissionProfileCached: permissionProfileCached,
			activePermissionProfileCached: activePermissionProfileCached,
			personalityCached: personalityCached,
			notificationBuffered: notificationBuffered,
			chatWidgetHandoffApplied: chatWidgetHandoffApplied,
			chatWidgetCollaborationModeActive: chatWidgetCollaborationModeActive,
			chatWidgetCurrentModelFromCollaborationSettings: chatWidgetCurrentModelFromCollaborationSettings,
			chatWidgetCurrentCollaborationModeModelPreservesSessionModel: chatWidgetCurrentCollaborationModeModelPreservesSessionModel,
			chatWidgetCurrentEffortFromNotification: chatWidgetCurrentEffortFromNotification,
			chatWidgetPersonalityApplied: chatWidgetPersonalityApplied,
			eventOrderingPreserved: eventOrderingPreserved,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ok ? "" : "inactive-thread settings notification invariants were not satisfied"
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelInactiveThreadSettingsNotificationOutcome {
		return new ModelInactiveThreadSettingsNotificationOutcome({
			ok: false,
			code: "inactive_thread_settings_notification_failed",
			requestId: requestId,
			decisionKind: ModelInactiveThreadSettingsNotificationDecisionKind.InactiveThreadSettingsNotificationUnavailable,
			notificationAccepted: false,
			inactiveChannelRetained: false,
			inactiveSessionUpdated: false,
			primarySessionUnchanged: false,
			inactiveSessionModelPreserved: false,
			inactiveSessionEffortPreserved: false,
			collaborationModeCached: false,
			collaborationSettingsRebasedToNotification: false,
			modelProviderCached: false,
			serviceTierCached: false,
			approvalPolicyCached: false,
			approvalsReviewerCached: false,
			permissionProfileCached: false,
			activePermissionProfileCached: false,
			personalityCached: false,
			notificationBuffered: false,
			chatWidgetHandoffApplied: false,
			chatWidgetCollaborationModeActive: false,
			chatWidgetCurrentModelFromCollaborationSettings: false,
			chatWidgetCurrentCollaborationModeModelPreservesSessionModel: false,
			chatWidgetCurrentEffortFromNotification: false,
			chatWidgetPersonalityApplied: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
