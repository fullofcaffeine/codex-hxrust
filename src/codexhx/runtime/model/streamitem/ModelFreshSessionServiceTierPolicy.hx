package codexhx.runtime.model.streamitem;

class ModelFreshSessionServiceTierPolicy {
	public static function apply(request:ModelFreshSessionServiceTierRequest):ModelFreshSessionServiceTierOutcome {
		if (request == null)
			return failure("", "missing fresh-session service-tier request");

		final configuredPresent = request.configuredServiceTier != ModelFreshSessionServiceTierValue.None;
		final basePresent = request.baseConfigServiceTier != ModelFreshSessionServiceTierValue.None;
		final freshConfigServiceTier = request.configuredServiceTier;

		return new ModelFreshSessionServiceTierOutcome({
			ok: true,
			code: "fresh_session_service_tier_modeled",
			requestId: request.requestId,
			decisionKind: configuredPresent ? ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierPropagated : ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierCleared,
			baseConfigServiceTier: request.baseConfigServiceTier,
			configuredServiceTier: request.configuredServiceTier,
			freshConfigServiceTier: freshConfigServiceTier,
			serviceTierOverrodeBaseConfig: freshConfigServiceTier != request.baseConfigServiceTier,
			serviceTierClearedFromBaseConfig: basePresent && !configuredPresent,
			baseConfigOtherwisePreserved: true,
			eventOrderingPreserved: request.eventOrderIndex == request.previousEventCount + 1,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: ""
		});
	}

	static function failure(requestId:String, errorMessage:String):ModelFreshSessionServiceTierOutcome {
		return new ModelFreshSessionServiceTierOutcome({
			ok: false,
			code: "fresh_session_service_tier_failed",
			requestId: requestId,
			decisionKind: ModelFreshSessionServiceTierDecisionKind.ConfiguredServiceTierCleared,
			baseConfigServiceTier: ModelFreshSessionServiceTierValue.None,
			configuredServiceTier: ModelFreshSessionServiceTierValue.None,
			freshConfigServiceTier: ModelFreshSessionServiceTierValue.None,
			serviceTierOverrodeBaseConfig: false,
			serviceTierClearedFromBaseConfig: false,
			baseConfigOtherwisePreserved: false,
			eventOrderingPreserved: false,
			liveNetworkAttempted: false,
			realFilesystemMutated: false,
			toolExecutedOutsideFixture: false,
			errorMessage: errorMessage
		});
	}
}
