package codexhx.tools.sandbox;

import codexhx.protocol.JsonScalar;

class SandboxGateDecision {
	public static inline final schema = "codex-hxrust.sandbox-gate-decision.v1";

	public final ok:Bool;
	public final allowed:Bool;
	public final enforced:Bool;
	public final platform:String;
	public final sandboxMode:String;
	public final operation:String;
	public final path:String;
	public final errorCode:String;
	public final errorMessage:String;

	public function new(ok:Bool, allowed:Bool, enforced:Bool, platform:String, sandboxMode:String, operation:String, path:String, errorCode:String,
			errorMessage:String) {
		this.ok = ok;
		this.allowed = allowed;
		this.enforced = enforced;
		this.platform = platform;
		this.sandboxMode = sandboxMode;
		this.operation = operation;
		this.path = path;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
	}

	public static function allow(request:SandboxGateRequest):SandboxGateDecision {
		return new SandboxGateDecision(true, true, false, request.platform, request.sandboxMode, request.operation, request.path, "", "");
	}

	public static function deny(request:SandboxGateRequest, errorCode:String, errorMessage:String):SandboxGateDecision {
		return new SandboxGateDecision(false, false, false, request.platform, request.sandboxMode, request.operation, request.path, errorCode, errorMessage);
	}

	public function json():String {
		var out = "{";
		out += "\"schema\":" + quote(schema);
		out += ",\"ok\":" + bool(ok);
		out += ",\"allowed\":" + bool(allowed);
		out += ",\"enforced\":" + bool(enforced);
		out += ",\"platform\":" + quote(platform);
		out += ",\"sandboxMode\":" + quote(sandboxMode);
		out += ",\"operation\":" + quote(operation);
		out += ",\"path\":" + quote(path);
		out += ",\"errorCode\":" + quote(errorCode);
		out += ",\"errorMessage\":" + quote(errorMessage);
		out += "}";
		return out;
	}

	static function quote(value:String):String {
		return JsonScalar.quote(value);
	}

	static function bool(value:Bool):String {
		if (value)
			return "true";
		return "false";
	}
}
