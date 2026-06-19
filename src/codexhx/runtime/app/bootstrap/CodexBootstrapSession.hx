package codexhx.runtime.app.bootstrap;

class CodexBootstrapSession {
	public static function bootstrap(mode:BootstrapMode, requestId:String, params:BootstrapInitializeParams, response:BootstrapInitializeResponse,
			metadata:BootstrapStartupMetadata):BootstrapValidationOutcome {
		if (mode != BootstrapMode.InProcess && mode != BootstrapMode.Remote) {
			return BootstrapValidationOutcome.failure("invalid_bootstrap_mode", "bootstrap mode must be remote or in_process");
		}
		final paramsResult = params.validate();
		if (!paramsResult.ok)
			return paramsResult;
		final responseResult = response.validate();
		if (!responseResult.ok)
			return responseResult;
		final metadataResult = metadata.validate();
		if (!metadataResult.ok)
			return metadataResult;

		final initializeRequestJson = mode == BootstrapMode.Remote ? params.requestJson(requestId) : "";
		final initializedNotificationJson = mode == BootstrapMode.Remote ? "{\"method\":\"initialized\"}" : "";
		final summary = Std.string(mode) + ":" + params.clientInfo.name + ":" + response.platformFamily + "/" + response.platformOs + ":"
			+ response.serverVersion() + ":warnings=" + Std.string(metadata.configWarnings.length);

		return BootstrapValidationOutcome.completed(new BootstrapReport(mode, initializeRequestJson, initializedNotificationJson, response.toJson(),
			metadata.toJson(), response.serverVersion(), summary));
	}
}
