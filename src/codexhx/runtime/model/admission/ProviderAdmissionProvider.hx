package codexhx.runtime.model.admission;

class ProviderAdmissionProvider {
	public final providerId:String;
	public final name:String;
	public final hasBaseUrl:Bool;
	public final baseUrl:String;
	public final envKeyConfigured:Bool;
	public final envKeyPresent:Bool;
	public final envKeyInstructionsPresent:Bool;
	public final requiresOpenAiAuth:Bool;
	public final supportsWebsockets:Bool;
	public final hasAwsAuth:Bool;
	public final hasCommandAuth:Bool;
	public final experimentalBearerTokenPresent:Bool;

	public function new(
		providerId:String,
		name:String,
		hasBaseUrl:Bool,
		baseUrl:String,
		envKeyConfigured:Bool,
		envKeyPresent:Bool,
		envKeyInstructionsPresent:Bool,
		requiresOpenAiAuth:Bool,
		supportsWebsockets:Bool,
		hasAwsAuth:Bool,
		hasCommandAuth:Bool,
		experimentalBearerTokenPresent:Bool
	) {
		this.providerId = providerId;
		this.name = name;
		this.hasBaseUrl = hasBaseUrl;
		this.baseUrl = baseUrl;
		this.envKeyConfigured = envKeyConfigured;
		this.envKeyPresent = envKeyPresent;
		this.envKeyInstructionsPresent = envKeyInstructionsPresent;
		this.requiresOpenAiAuth = requiresOpenAiAuth;
		this.supportsWebsockets = supportsWebsockets;
		this.hasAwsAuth = hasAwsAuth;
		this.hasCommandAuth = hasCommandAuth;
		this.experimentalBearerTokenPresent = experimentalBearerTokenPresent;
	}

	public function valid():Bool {
		return StringTools.trim(providerId).length > 0
			&& StringTools.trim(name).length > 0
			&& (!hasBaseUrl || StringTools.trim(baseUrl).length > 0);
	}

	public function envKeyNameBucket():String {
		return envKeyConfigured ? "configured" : "none";
	}

	public function validateAuthShape():ProviderAdmissionShapeRead {
		if (hasAwsAuth) {
			final conflicts:Array<String> = [];
			if (envKeyConfigured) conflicts.push("env_key");
			if (experimentalBearerTokenPresent) conflicts.push("experimental_bearer_token");
			if (hasCommandAuth) conflicts.push("auth");
			if (requiresOpenAiAuth) conflicts.push("requires_openai_auth");
			if (supportsWebsockets) conflicts.push("supports_websockets");
			if (conflicts.length > 0) return ProviderAdmissionShapeRead.failure("provider aws cannot be combined with " + conflicts.join(", "));
		}
		if (hasCommandAuth) {
			final conflicts:Array<String> = [];
			if (envKeyConfigured) conflicts.push("env_key");
			if (experimentalBearerTokenPresent) conflicts.push("experimental_bearer_token");
			if (requiresOpenAiAuth) conflicts.push("requires_openai_auth");
			if (conflicts.length > 0) return ProviderAdmissionShapeRead.failure("provider auth cannot be combined with " + conflicts.join(", "));
		}
		return ProviderAdmissionShapeRead.success();
	}

	public function summary():String {
		return "provider=" + providerId
			+ ";name=" + name
			+ ";baseUrl=" + (hasBaseUrl ? baseUrl : "none")
			+ ";envKeyName=" + envKeyNameBucket()
			+ ";envKeyPresent=" + boolText(envKeyPresent)
			+ ";requiresOpenAiAuth=" + boolText(requiresOpenAiAuth)
			+ ";supportsWebsockets=" + boolText(supportsWebsockets)
			+ ";aws=" + boolText(hasAwsAuth)
			+ ";commandAuth=" + boolText(hasCommandAuth)
			+ ";experimentalBearerToken=" + boolText(experimentalBearerTokenPresent);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}

class ProviderAdmissionShapeRead {
	public final ok:Bool;
	public final errorMessage:String;

	function new(ok:Bool, errorMessage:String) {
		this.ok = ok;
		this.errorMessage = errorMessage;
	}

	public static function success():ProviderAdmissionShapeRead {
		return new ProviderAdmissionShapeRead(true, "");
	}

	public static function failure(errorMessage:String):ProviderAdmissionShapeRead {
		return new ProviderAdmissionShapeRead(false, errorMessage);
	}
}
