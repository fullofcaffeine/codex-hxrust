package codexhx.diagnostics;

import codexhx.protocol.JsonScalar;

class DiagnosticFailureReport {
	public static inline final schema = "codex-hxrust.failure-report.v1";

	public final id:String;
	public final errorCode:String;
	public final errorMessage:String;
	public final fixtureIds:Array<String>;
	public final redacted:Bool;

	public function new(id:String, errorCode:String, errorMessage:String, fixtureIds:Array<String>, redacted:Bool) {
		this.id = id;
		this.errorCode = errorCode;
		this.errorMessage = errorMessage;
		this.fixtureIds = fixtureIds;
		this.redacted = redacted;
	}

	public function json():String {
		var out = "{";
		out += "\"schema\":" + quote(schema);
		out += ",\"id\":" + quote(id);
		out += ",\"errorCode\":" + quote(errorCode);
		out += ",\"errorMessage\":" + quote(errorMessage);
		out += ",\"fixtureIds\":" + stringArray(fixtureIds);
		out += ",\"redacted\":" + bool(redacted);
		out += "}";
		return out;
	}

	static function stringArray(values:Array<String>):String {
		var out = "[";
		for (i in 0...values.length) {
			if (i > 0)
				out += ",";
			out += quote(values[i]);
		}
		return out + "]";
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
