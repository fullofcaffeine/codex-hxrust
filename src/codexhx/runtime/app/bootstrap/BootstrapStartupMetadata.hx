package codexhx.runtime.app.bootstrap;

import codexhx.protocol.JsonScalar;

class BootstrapStartupMetadata {
	public final accountAuthMode:String;
	public final accountPlanType:String;
	public final accountEmail:String;
	public final model:String;
	public final modelProvider:String;
	public final configWarnings:Array<BootstrapConfigWarning>;

	public function new(accountAuthMode:String, accountPlanType:String, accountEmail:String, model:String, modelProvider:String,
			configWarnings:Array<BootstrapConfigWarning>) {
		this.accountAuthMode = accountAuthMode;
		this.accountPlanType = accountPlanType;
		this.accountEmail = accountEmail;
		this.model = model;
		this.modelProvider = modelProvider;
		this.configWarnings = copyWarnings(configWarnings);
	}

	public function validate():BootstrapValidationOutcome {
		if (StringTools.trim(model).length == 0)
			return BootstrapValidationOutcome.failure("invalid_startup_model", "startup model must be non-empty");
		if (StringTools.trim(modelProvider).length == 0)
			return BootstrapValidationOutcome.failure("invalid_startup_model_provider", "startup model provider must be non-empty");
		for (warning in configWarnings) {
			final result = warning.validate();
			if (!result.ok)
				return result;
		}
		return BootstrapValidationOutcome.success("startup-metadata");
	}

	public function toJson():String {
		final warnings:Array<String> = [];
		for (warning in configWarnings) {
			warnings.push(warning.toJson());
		}
		return "{\"account\":{\"authMode\":" + nullable(accountAuthMode) + ",\"email\":" + nullable(accountEmail) + ",\"planType\":"
			+ nullable(accountPlanType) + "},\"configWarnings\":[" + warnings.join(",") + "]" + ",\"model\":{\"id\":" + JsonScalar.quote(model)
			+ ",\"provider\":" + JsonScalar.quote(modelProvider) + "}}";
	}

	static function copyWarnings(values:Array<BootstrapConfigWarning>):Array<BootstrapConfigWarning> {
		final out:Array<BootstrapConfigWarning> = [];
		for (value in values) {
			out.push(new BootstrapConfigWarning(value.summary, value.details, value.path));
		}
		return out;
	}

	static function nullable(value:String):String {
		return value.length == 0 ? "null" : JsonScalar.quote(value);
	}
}
