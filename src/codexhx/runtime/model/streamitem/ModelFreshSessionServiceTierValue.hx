package codexhx.runtime.model.streamitem;

enum abstract ModelFreshSessionServiceTierValue(String) from String to String {
	final None = "";
	final Priority = "priority";
	final Flex = "flex";
	final Default = "default";
}
