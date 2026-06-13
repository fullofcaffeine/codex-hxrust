package codexhx.runtime.model.admission;

enum abstract ProviderAdmissionNetworkKind(String) to String {
	public var FixtureOnly = "fixture_only";
	public var LiveNetwork = "live_network";
}
