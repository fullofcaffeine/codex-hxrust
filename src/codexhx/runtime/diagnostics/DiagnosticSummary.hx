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

	public static function boundedSnapshot(name:String, value:String, maxChars:Int):DiagnosticField {
		return text(name, truncate(value.split("\n").join("\\n"), maxChars));
	}

	public static function nested(name:String, summary:String):DiagnosticField {
		return text(name, "[" + summary + "]");
	}

	public static function boundedNested(name:String, summary:String, maxChars:Int):DiagnosticField {
		return text(name, "[" + truncate(summary, maxChars) + "]");
	}

	public static function logList(name:String, summaries:Array<String>):DiagnosticField {
		return nested(name, summaries.join("##"));
	}

	public static function boundedLogList(name:String, summaries:Array<String>, maxItems:Int, maxItemChars:Int):DiagnosticField {
		final parts:Array<String> = [];
		final limit = maxItems < 0 ? 0 : maxItems;
		final itemCount = summaries.length < limit ? summaries.length : limit;
		for (i in 0...itemCount) {
			parts.push(truncate(summaries[i], maxItemChars));
		}
		final omitted = summaries.length - itemCount;
		if (omitted > 0)
			parts.push("...<omitted items=" + omitted + " total=" + summaries.length + ">");
		return nested(name, parts.join("##"));
	}

	public static function truncate(value:String, maxChars:Int):String {
		if (maxChars < 0 || value.length <= maxChars)
			return value;
		return value.substr(0, maxChars) + "...<truncated chars=" + value.length + ">";
	}
}
