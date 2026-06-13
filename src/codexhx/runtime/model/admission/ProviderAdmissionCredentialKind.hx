package codexhx.runtime.model.admission;

enum abstract ProviderAdmissionCredentialKind(String) to String {
	public var None = "none";
	public var NoCredentialTest = "no_credential_test";
	public var OpenAiAuth = "openai_auth";
	public var ProviderEnv = "provider_env";
	public var Aws = "aws";
}
