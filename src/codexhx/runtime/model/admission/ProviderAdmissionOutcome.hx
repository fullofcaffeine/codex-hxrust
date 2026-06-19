package codexhx.runtime.model.admission;

class ProviderAdmissionOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final providerId:String;
	public final modelId:String;
	public final modelProviderId:String;
	public final requiresOpenAiAuth:Bool;
	public final credentialKind:ProviderAdmissionCredentialKind;
	public final accountKind:ProviderAdmissionAccountKind;
	public final networkKind:ProviderAdmissionNetworkKind;
	public final credentialAccepted:Bool;
	public final credentialBucket:String;
	public final providerEnvKeyNameBucket:String;
	public final providerEnvKeyPresent:Bool;
	public final liveNetworkAllowed:Bool;
	public final admittedNetworkKind:String;
	public final accountVisible:String;
	public final errorMessage:String;
	public final sequence:String;

	function new(ok:Bool, code:String, request:ProviderAdmissionRequest, credentialAccepted:Bool, credentialBucket:String, admittedNetworkKind:String,
			accountVisible:String, errorMessage:String, sequence:String) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.providerId = request.provider == null ? "" : request.provider.providerId;
		this.modelId = request.model == null ? "" : request.model.modelId;
		this.modelProviderId = request.model == null ? "" : request.model.providerId;
		this.requiresOpenAiAuth = request.provider != null && request.provider.requiresOpenAiAuth;
		this.credentialKind = request.credentialKind;
		this.accountKind = request.accountKind;
		this.networkKind = request.networkKind;
		this.credentialAccepted = credentialAccepted;
		this.credentialBucket = credentialBucket;
		this.providerEnvKeyNameBucket = request.provider == null ? "none" : request.provider.envKeyNameBucket();
		this.providerEnvKeyPresent = request.provider != null && request.provider.envKeyPresent;
		this.liveNetworkAllowed = request.liveNetworkAllowed;
		this.admittedNetworkKind = admittedNetworkKind;
		this.accountVisible = accountVisible;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function admitted(request:ProviderAdmissionRequest, credentialAccepted:Bool, credentialBucket:String, admittedNetworkKind:String,
			accountVisible:String, sequence:String):ProviderAdmissionOutcome {
		return new ProviderAdmissionOutcome(true, "provider_admitted", request, credentialAccepted, credentialBucket, admittedNetworkKind, accountVisible, "",
			sequence);
	}

	public static function denied(request:ProviderAdmissionRequest, code:String, errorMessage:String, sequence:String):ProviderAdmissionOutcome {
		return new ProviderAdmissionOutcome(false, code, request, false, "none", "none", "none", errorMessage, sequence);
	}

	public function summary():String {
		return "code=" + code + ";ok=" + boolText(ok) + ";request=" + requestId + ";provider=" + providerId + ";model=" + modelId + ";modelProvider="
			+ modelProviderId + ";requiresOpenAiAuth=" + boolText(requiresOpenAiAuth) + ";credentialKind=" + credentialKind + ";accountKind=" + accountKind
			+ ";credentialAccepted=" + boolText(credentialAccepted) + ";credentialBucket=" + credentialBucket + ";providerEnvKeyName="
			+ providerEnvKeyNameBucket + ";providerEnvKeyPresent=" + boolText(providerEnvKeyPresent) + ";network=" + networkKind + ";liveNetworkAllowed="
			+ boolText(liveNetworkAllowed) + ";admittedNetwork=" + admittedNetworkKind + ";accountVisible=" + accountVisible + ";error=" + errorMessage
			+ ";sequence=" + sequence;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
