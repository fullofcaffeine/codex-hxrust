package codexhx.runtime.tui.render;

class TuiAnsiSanitizer {
	public static function strip(input:String):String {
		var output = "";
		var i = 0;
		while (i < input.length) {
			final ch = input.charAt(i);
			if (ch == "\x1b" && i + 1 < input.length && input.charAt(i + 1) == "[") {
				i = skipEscape(input, i + 2);
			} else {
				output = output + ch;
				i = i + 1;
			}
		}
		return output;
	}

	static function skipEscape(input:String, i:Int):Int {
		var cursor = i;
		while (cursor < input.length) {
			final code = input.charCodeAt(cursor);
			cursor = cursor + 1;
			if ((code >= 64 && code <= 126))
				return cursor;
		}
		return cursor;
	}
}
