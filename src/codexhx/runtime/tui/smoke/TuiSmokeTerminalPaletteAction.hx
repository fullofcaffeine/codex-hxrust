package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalPaletteActionFields = {
	final kind:TuiSmokeTerminalPaletteActionKind;
	final slot:Int;
	final payload:String;
	final buffer:String;
	final color:String;
	final foreground:String;
	final background:String;
	final valid:Bool;
	final startupAttempted:Bool;
	final startupValue:String;
	final requeryRequested:Bool;
	final requeryValue:String;
	final skippedBecauseUnavailable:Bool;
	final liveQueryAllowed:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalPaletteAction {
	public final kind:TuiSmokeTerminalPaletteActionKind;
	@:recordMin(0)
	public final slot:Int;
	public final payload:String;
	public final buffer:String;
	public final color:String;
	public final foreground:String;
	public final background:String;
	public final valid:Bool;
	public final startupAttempted:Bool;
	public final startupValue:String;
	public final requeryRequested:Bool;
	public final requeryValue:String;
	public final skippedBecauseUnavailable:Bool;
	public final liveQueryAllowed:Bool;
	public final failureCode:String;

	public function computedColor():String {
		return parseOscColor(buffer, slot);
	}

	public function colorMatches():Bool {
		return color == "" || computedColor() == color;
	}

	public function computedRgb():String {
		return parseOscRgb(payload);
	}

	public function rgbMatches():Bool {
		return color == "" || computedRgb() == color;
	}

	public function computedForeground():String {
		return parseOscColor(buffer, 10);
	}

	public function computedBackground():String {
		return parseOscColor(buffer, 11);
	}

	public function defaultColorsValid():Bool {
		return computedForeground() != "" && computedBackground() != "";
	}

	public function defaultColorsMatch():Bool {
		return computedForeground() == foreground && computedBackground() == background && defaultColorsValid() == valid;
	}

	public function cacheResult():String {
		if (startupAttempted && startupValue == "" && skippedBecauseUnavailable) {
			return "attempted-unavailable";
		}
		if (requeryRequested && requeryValue != "") {
			return requeryValue;
		}
		return startupValue;
	}

	static function parseOscColor(value:String, colorSlot:Int):String {
		final esc = String.fromCharCode(27);
		final bel = String.fromCharCode(7);
		final prefix = esc + "]" + colorSlot + ";";
		final start = value.indexOf(prefix);
		if (start < 0) {
			return "";
		}
		final payloadStart = start + prefix.length;
		var index = payloadStart;
		while (index < value.length) {
			if (value.substr(index, 1) == bel) {
				return parseOscRgb(value.substr(payloadStart, index - payloadStart));
			}
			if (value.substr(index, 2) == esc + "\\") {
				return parseOscRgb(value.substr(payloadStart, index - payloadStart));
			}
			index++;
		}
		return "";
	}

	static function parseOscRgb(value:String):String {
		final trimmed = StringTools.trim(value);
		final colon = trimmed.indexOf(":");
		if (colon < 0) {
			return "";
		}
		final prefix = trimmed.substr(0, colon).toLowerCase();
		if (prefix != "rgb" && prefix != "rgba") {
			return "";
		}
		final parts = trimmed.substr(colon + 1).split("/");
		if ((prefix == "rgb" && parts.length != 3) || (prefix == "rgba" && parts.length != 4)) {
			return "";
		}
		final r = parseComponent(parts[0]);
		final g = parseComponent(parts[1]);
		final b = parseComponent(parts[2]);
		if (r < 0 || g < 0 || b < 0) {
			return "";
		}
		if (prefix == "rgba" && parseComponent(parts[3]) < 0) {
			return "";
		}
		return r + "," + g + "," + b;
	}

	static function parseComponent(value:String):Int {
		if (value.length != 2 && value.length != 4) {
			return -1;
		}
		for (i in 0...value.length) {
			if (hexDigit(value.charAt(i)) < 0) {
				return -1;
			}
		}
		final parsed = parseHex(value);
		if (parsed < 0) {
			return -1;
		}
		return value.length == 2 ? parsed : Std.int(parsed / 257);
	}

	static function parseHex(value:String):Int {
		var out = 0;
		for (i in 0...value.length) {
			final digit = hexDigit(value.charAt(i));
			if (digit < 0) {
				return -1;
			}
			out = out * 16 + digit;
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
}
