package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalStartupProbeActionFields = {
	final kind:TuiSmokeTerminalStartupProbeActionKind;
	final buffer:String;
	final cursorX:Int;
	final cursorY:Int;
	final foreground:String;
	final background:String;
	final queryKeyboard:Bool;
	final keyboardSupported:Bool;
	final fallbackSeen:Bool;
	final complete:Bool;
	final handleSource:String;
	final duplicatedStdio:Bool;
	final controllingTerminalFallback:Bool;
	final originalFlagsRestored:Bool;
	final timeoutMs:Int;
	final liveProbeAllowed:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalStartupProbeAction {
	public final kind:TuiSmokeTerminalStartupProbeActionKind;
	public final buffer:String;
	@:recordMin(-1)
	public final cursorX:Int;
	@:recordMin(-1)
	public final cursorY:Int;
	public final foreground:String;
	public final background:String;
	public final queryKeyboard:Bool;
	public final keyboardSupported:Bool;
	public final fallbackSeen:Bool;
	public final complete:Bool;
	public final handleSource:String;
	public final duplicatedStdio:Bool;
	public final controllingTerminalFallback:Bool;
	public final originalFlagsRestored:Bool;
	@:recordMin(0)
	public final timeoutMs:Int;
	public final liveProbeAllowed:Bool;
	public final failureCode:String;

	public function parsedCursor():String {
		final pos = parseCursor(buffer);
		return pos == null ? "" : pos.x + "," + pos.y;
	}

	public function cursorMatches():Bool {
		if (cursorX < 0 && cursorY < 0) return parsedCursor() == "";
		return parsedCursor() == cursorX + "," + cursorY;
	}

	public function computedForeground():String {
		return parseOscColor(buffer, 10);
	}

	public function computedBackground():String {
		return parseOscColor(buffer, 11);
	}

	public function defaultColorsComplete():Bool {
		return computedForeground() != "" && computedBackground() != "";
	}

	public function defaultColorsMatch():Bool {
		return computedForeground() == foreground && computedBackground() == background && defaultColorsComplete() == complete;
	}

	public function parsedKeyboardSupported():Bool {
		return buffer.indexOf(esc() + "[?7u") >= 0;
	}

	public function parsedFallbackSeen():Bool {
		return buffer.indexOf(esc() + "[?64;1;2c") >= 0;
	}

	public function keyboardMatches():Bool {
		return parsedKeyboardSupported() == keyboardSupported && parsedFallbackSeen() == fallbackSeen;
	}

	public function batchComplete():Bool {
		return cursorMatches() && defaultColorsMatch() && (!queryKeyboard || keyboardMatches());
	}

	static function parseCursor(value:String):Null<{x:Int, y:Int}> {
		final prefix = esc() + "[";
		var index = value.indexOf(prefix);
		while (index >= 0) {
			final end = value.indexOf("R", index + prefix.length);
			if (end < 0) return null;
			final body = value.substr(index + prefix.length, end - index - prefix.length);
			final parts = body.split(";");
			if (parts.length == 2) {
				final row = parseDecimal(parts[0]);
				final col = parseDecimal(parts[1]);
				if (row > 0 && col > 0) {
					return {x: col - 1, y: row - 1};
				}
			}
			index = value.indexOf(prefix, index + 1);
		}
		return null;
	}

	static function parseOscColor(value:String, colorSlot:Int):String {
		final prefix = esc() + "]" + colorSlot + ";";
		final start = value.indexOf(prefix);
		if (start < 0) return "";
		final payloadStart = start + prefix.length;
		var index = payloadStart;
		while (index < value.length) {
			if (value.substr(index, 1) == bel()) {
				return parseOscRgb(value.substr(payloadStart, index - payloadStart));
			}
			if (value.substr(index, 2) == esc() + "\\") {
				return parseOscRgb(value.substr(payloadStart, index - payloadStart));
			}
			index++;
		}
		return "";
	}

	static function parseOscRgb(value:String):String {
		final trimmed = StringTools.trim(value);
		final colon = trimmed.indexOf(":");
		if (colon < 0) return "";
		final prefix = trimmed.substr(0, colon).toLowerCase();
		if (prefix != "rgb" && prefix != "rgba") return "";
		final parts = trimmed.substr(colon + 1).split("/");
		if ((prefix == "rgb" && parts.length != 3) || (prefix == "rgba" && parts.length != 4)) return "";
		final r = parseComponent(parts[0]);
		final g = parseComponent(parts[1]);
		final b = parseComponent(parts[2]);
		if (r < 0 || g < 0 || b < 0) return "";
		if (prefix == "rgba" && parseComponent(parts[3]) < 0) return "";
		return r + "," + g + "," + b;
	}

	static function parseComponent(value:String):Int {
		if (value.length != 2 && value.length != 4) return -1;
		var out = 0;
		for (i in 0...value.length) {
			final digit = hexDigit(value.charAt(i));
			if (digit < 0) return -1;
			out = out * 16 + digit;
		}
		return value.length == 2 ? out : Std.int(out / 257);
	}

	static function parseDecimal(value:String):Int {
		if (value.length == 0) return -1;
		var out = 0;
		for (i in 0...value.length) {
			final digit = switch value.charAt(i) {
				case "0": 0;
				case "1": 1;
				case "2": 2;
				case "3": 3;
				case "4": 4;
				case "5": 5;
				case "6": 6;
				case "7": 7;
				case "8": 8;
				case "9": 9;
				case _: -1;
			}
			if (digit < 0) return -1;
			out = out * 10 + digit;
		}
		return out;
	}

	static function hexDigit(ch:String):Int {
		return switch ch {
			case "0": 0;
			case "1": 1;
			case "2": 2;
			case "3": 3;
			case "4": 4;
			case "5": 5;
			case "6": 6;
			case "7": 7;
			case "8": 8;
			case "9": 9;
			case "a" | "A": 10;
			case "b" | "B": 11;
			case "c" | "C": 12;
			case "d" | "D": 13;
			case "e" | "E": 14;
			case "f" | "F": 15;
			case _: -1;
		}
	}

	static function esc():String {
		return String.fromCharCode(27);
	}

	static function bel():String {
		return String.fromCharCode(7);
	}
}
