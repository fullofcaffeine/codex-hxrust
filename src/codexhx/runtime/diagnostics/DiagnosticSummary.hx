package codexhx.runtime.diagnostics;

class DiagnosticSummary {
	public static function render(fields:Array<DiagnosticField>):String {
		final parts:Array<String> = [];
		for (field in fields) {
			parts.push(field.render());
		}
		return parts.join(";");
	}

	public static function text(name:String, value:String):DiagnosticField {
		return new DiagnosticField({name: name, value: value});
	}

	public static function intValue(name:String, value:Int):DiagnosticField {
		return text(name, Std.string(value));
	}

	public static function boolValue(name:String, value:Bool):DiagnosticField {
		return text(name, value ? "true" : "false");
	}

	public static function enumValue(name:String, value:String):DiagnosticField {
		return text(name, value);
	}

	public static function snapshot(name:String, value:String):DiagnosticField {
		return text(name, value.split("\n").join("\\n"));
	}

	public static function nested(name:String, summary:String):DiagnosticField {
		return text(name, "[" + summary + "]");
	}

	public static function logList(name:String, summaries:Array<String>):DiagnosticField {
		return nested(name, summaries.join("##"));
	}
}
