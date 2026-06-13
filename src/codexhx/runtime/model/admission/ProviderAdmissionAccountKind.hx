package codexhx.runtime.model.admission;

enum abstract ProviderAdmissionAccountKind(String) to String {
	public var None = "none";
	public var ApiKey = "api_key";
	public var Chatgpt = "chatgpt";
	public var AgentIdentity = "agent_identity";
	public var PersonalAccessToken = "personal_access_token";
	public var AmazonBedrock = "amazon_bedrock";
}
