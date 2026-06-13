package codexhx.runtime.model.catalog;

enum abstract ModelCatalogRefreshStrategy(String) to String {
	public var Offline = "offline";
	public var Online = "online";
	public var OnlineIfUncached = "online_if_uncached";
}
