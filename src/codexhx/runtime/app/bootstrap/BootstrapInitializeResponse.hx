package codexhx.runtime.app.bootstrap;

import codexhx.protocol.JsonScalar;

class BootstrapInitializeResponse {
	public final userAgent:String;
	public final codexHome:String;
	public final platformFamily:String;
	public final platformOs:String;

	public function new(userAgent:String, codexHome:String, platformFamily:String, platformOs:String) {
		this.userAgent = userAgent;
		this.codexHome = codexHome;
		this.platformFamily = platformFamily;
		this.platformOs = platformOs;
	}

	public function validate():BootstrapValidationOutcome {
		if (StringTools.trim(userAgent).length == 0)
			return BootstrapValidationOutcome.failure("invalid_user_agent", "userAgent must be non-empty");
		if (!isAbsolutePath(codexHome))
			return BootstrapValidationOutcome.failure("invalid_codex_home", "codexHome must be absolute");
		if (platformFamily != "unix" && platformFamily != "windows") {
			return BootstrapValidationOutcome.failure("invalid_platform_family", "platformFamily must be unix or windows");
		}
		if (StringTools.trim(platformOs).length == 0)
			return BootstrapValidationOutcome.failure("invalid_platform_os", "platformOs must be non-empty");
		return BootstrapValidationOutcome.success("initialize-response");
	}

	public function toJson():String {
		return "{\"codexHome\":" + quote(codexHome) + ",\"platformFamily\":" + quote(platformFamily) + ",\"platformOs\":" + quote(platformOs)
			+ ",\"userAgent\":" + quote(userAgent) + "}";
	}

	public function serverVersion():String {
		final slash = userAgent.indexOf("/");
		if (slash < 0 || slash + 1 >= userAgent.length)
			return "";
		final rest = userAgent.substr(slash + 1, userAgent.length - slash - 1);
		final space = rest.indexOf(" ");
		return space < 0 ? rest : rest.substr(0, space);
	}

	static function isAbsolutePath(path:String):Bool {
		if (path.length == 0)
			return false;
		if (path.charAt(0) == "/")
			return true;
		if (path.length >= 3 && path.charAt(1) == ":" && (path.charAt(2) == "\\" || path.charAt(2) == "/"))
			return true;
		return false;
	}

	static function quote(value:String):String {
		return JsonScalar.quote(value);
	}
}
