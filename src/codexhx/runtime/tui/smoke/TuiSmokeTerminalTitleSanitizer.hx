package codexhx.runtime.tui.smoke;

class TuiSmokeTerminalTitleSanitizer {
	public static function defaultMaxChars():Int {
		return 240;
	}

	public static function sanitize(title:String, maxChars:Int):String {
		if (title == null || maxChars <= 0)
			return "";

		final out = new StringBuf();
		var charsWritten = 0;
		var pendingSpace = false;
		var i = 0;
		while (i < title.length && charsWritten < maxChars) {
			final code = title.charCodeAt(i);
			if (isWhitespace(code)) {
				pendingSpace = charsWritten > 0;
				i = i + 1;
				continue;
			}
			if (isDisallowed(code)) {
				i = i + 1;
				continue;
			}
			if (pendingSpace) {
				final remaining = maxChars - charsWritten;
				if (remaining > 1) {
					out.add(" ");
					charsWritten = charsWritten + 1;
				}
				pendingSpace = false;
			}
			if (charsWritten >= maxChars)
				break;
			out.addChar(code);
			charsWritten = charsWritten + 1;
			i = i + 1;
		}
		return out.toString();
	}

	static function isWhitespace(code:Int):Bool {
		return code == 9 || code == 10 || code == 11 || code == 12 || code == 13 || code == 32;
	}

	static function isDisallowed(code:Int):Bool {
		if (code < 32 || code == 127)
			return true;
		return switch code {
			case 0x061C | 0x200B | 0x200C | 0x200D | 0x200E | 0x200F | 0x202A | 0x202B | 0x202C | 0x202D | 0x202E | 0x2066 | 0x2067 | 0x2068 | 0x2069:
				true;
			case _:
				false;
		}
	}
}
