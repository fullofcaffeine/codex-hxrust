package codexhx.runtime.model.streamitem;

enum abstract ModelFreshSessionServiceTierDecisionKind(String) from String to String {
	final ConfiguredServiceTierPropagated = "configured_service_tier_propagated";
	final ConfiguredServiceTierCleared = "configured_service_tier_cleared";
}
