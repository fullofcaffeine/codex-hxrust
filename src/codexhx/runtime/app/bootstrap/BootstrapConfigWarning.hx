package codexhx.runtime.app.bootstrap;

import codexhx.protocol.JsonScalar;

class BootstrapConfigWarning {
	public final summary:String;
	public final details:String;
	public final path:String;

	public function new(summary:String, details:String, path:String) {
		this.summary = summary;
		this.details = details;
		this.path = path;
	}

	public function validate():BootstrapValidationOutcome {
		if (StringTools.trim(summary).length == 0)
			return BootstrapValidationOutcome.failure("invalid_config_warning", "config warning summary must be non-empty");
		return BootstrapValidationOutcome.success("config-warning");
	}

	public function toJson():String {
		return "{\"details\":" + nullable(details) + ",\"path\":" + nullable(path) + ",\"summary\":" + JsonScalar.quote(summary) + "}";
	}

	static function nullable(value:String):String {
		return value.length == 0 ? "null" : JsonScalar.quote(value);
	}
}
