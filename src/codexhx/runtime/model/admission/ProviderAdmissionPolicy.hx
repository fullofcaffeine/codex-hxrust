package codexhx.runtime.model.admission;

class ProviderAdmissionPolicy {
	public static function buildCases(requests:Array<ProviderAdmissionRequest>):ProviderAdmissionReport {
		final outcomes:Array<ProviderAdmissionOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ProviderAdmissionReport(outcomes);
	}

	public static function build(request:ProviderAdmissionRequest):ProviderAdmissionOutcome {
		if (request.provider == null || !request.provider.valid()) {
			return ProviderAdmissionOutcome.denied(request, "invalid_provider_metadata", "provider metadata is incomplete",
				"provider_admission->validate_provider:error");
		}
		if (request.model == null || !request.model.valid()) {
			return ProviderAdmissionOutcome.denied(request, "invalid_model_metadata", "model metadata is incomplete",
				"provider_admission->validate_model:error");
		}
		if (request.model.providerId != request.provider.providerId) {
			return ProviderAdmissionOutcome.denied(request, "provider_model_mismatch",
				"requested model belongs to "
				+ request.model.providerId
				+ " but active provider is "
				+ request.provider.providerId,
				"provider_admission->model_provider_match:error");
		}
		final providerShape = request.provider.validateAuthShape();
		if (!providerShape.ok) {
			return ProviderAdmissionOutcome.denied(request, "provider_auth_shape_conflict", providerShape.errorMessage,
				"provider_admission->model_provider_info.validate:error");
		}
		if (request.networkKind == ProviderAdmissionNetworkKind.LiveNetwork && !request.liveNetworkAllowed) {
			return ProviderAdmissionOutcome.denied(request, "live_network_disabled",
				"live provider traffic is disabled for this credential-free fixture gate", "provider_admission->network_policy:live_network_disabled");
		}
		if (request.provider.hasAwsAuth)
			return admitAws(request);
		if (request.provider.requiresOpenAiAuth)
			return admitOpenAiAuth(request);
		return admitProviderScoped(request);
	}

	static function admitAws(request:ProviderAdmissionRequest):ProviderAdmissionOutcome {
		if (request.accountKind != ProviderAdmissionAccountKind.AmazonBedrock
			|| request.credentialKind != ProviderAdmissionCredentialKind.Aws) {
			return ProviderAdmissionOutcome.denied(request, "aws_auth_required", "Amazon Bedrock providers require AWS auth account state",
				"provider_admission->aws_account_state:error");
		}
		return ProviderAdmissionOutcome.admitted(request, false, "aws_configured", admittedNetworkKind(request), "amazon_bedrock",
			"provider_admission->create_model_provider:amazon_bedrock->account_state:amazon_bedrock");
	}

	static function admitOpenAiAuth(request:ProviderAdmissionRequest):ProviderAdmissionOutcome {
		if (!openAiAccountKind(request.accountKind)
			|| request.credentialKind != ProviderAdmissionCredentialKind.OpenAiAuth
			|| !request.hasCredentialMaterial) {
			return ProviderAdmissionOutcome.denied(request, "missing_openai_auth",
				"active model provider requires OpenAI auth but no reusable credential is available",
				"provider_admission->requires_openai_auth:true->auth_manager:none");
		}
		return ProviderAdmissionOutcome.admitted(request, true, "present", admittedNetworkKind(request), accountVisible(request.accountKind),
			"provider_admission->requires_openai_auth:true->auth_provider_from_auth:" + request.accountKind + "->redact_token");
	}

	static function admitProviderScoped(request:ProviderAdmissionRequest):ProviderAdmissionOutcome {
		if (request.provider.envKeyConfigured) {
			if (!request.provider.envKeyPresent || request.credentialKind != ProviderAdmissionCredentialKind.ProviderEnv) {
				return ProviderAdmissionOutcome.denied(request, "missing_provider_env_key", "active model provider auth env var is missing",
					"provider_admission->requires_openai_auth:false->provider_env_key:missing");
			}
			return ProviderAdmissionOutcome.admitted(request, true, "configured", admittedNetworkKind(request), "none",
				"provider_admission->requires_openai_auth:false->provider_env_key:configured->redact_env_key_name");
		}
		return ProviderAdmissionOutcome.admitted(request, false, "none", admittedNetworkKind(request), "none",
			"provider_admission->requires_openai_auth:false->unauthenticated_provider");
	}

	static function admittedNetworkKind(request:ProviderAdmissionRequest):String {
		return request.networkKind == ProviderAdmissionNetworkKind.LiveNetwork ? "live_network" : "fixture_only";
	}

	static function openAiAccountKind(kind:ProviderAdmissionAccountKind):Bool {
		return kind == ProviderAdmissionAccountKind.ApiKey
			|| kind == ProviderAdmissionAccountKind.Chatgpt
			|| kind == ProviderAdmissionAccountKind.AgentIdentity
			|| kind == ProviderAdmissionAccountKind.PersonalAccessToken;
	}

	static function accountVisible(kind:ProviderAdmissionAccountKind):String {
		return switch kind {
			case ProviderAdmissionAccountKind.ApiKey: "api_key";
			case ProviderAdmissionAccountKind.Chatgpt: "chatgpt";
			case ProviderAdmissionAccountKind.AgentIdentity: "chatgpt";
			case ProviderAdmissionAccountKind.PersonalAccessToken: "chatgpt";
			case ProviderAdmissionAccountKind.AmazonBedrock: "amazon_bedrock";
			case ProviderAdmissionAccountKind.None: "none";
		}
	}
}
