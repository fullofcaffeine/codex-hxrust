package codexhx.runtime.tui;

class TuiStoryKeyEvent {
	public final code:String;
	public final modifiers:String;
	public final pressKind:String;

	public function new(code:String, modifiers:String, pressKind:String) {
		this.code = code;
		this.modifiers = modifiers;
		this.pressKind = pressKind;
	}

	public static function parse(raw:String):TuiStoryKeyEvent {
		final code = between(raw, "code: ", ", modifiers");
		final modifiers = between(raw, "modifiers: KeyModifiers(", "), kind");
		final pressKind = between(raw, "kind: ", ", state");
		return new TuiStoryKeyEvent(normalizeCode(code), normalizeModifiers(modifiers), pressKind);
	}

	public function typedCharacter():String {
		if (pressKind != "Press")
			return "";
		if (code == "Enter")
			return "\n";
		if (code.length == 1)
			return code;
		return "";
	}

	public function summary():String {
		return code + "/" + modifiers + "/" + pressKind;
	}

	static function normalizeCode(code:String):String {
		final trimmed = StringTools.trim(code);
		if (trimmed.indexOf("Char('") == 0 && trimmed.length >= 8) {
			return trimmed.substr(6, trimmed.length - 8);
		}
		return trimmed;
	}

	static function normalizeModifiers(value:String):String {
		final trimmed = StringTools.trim(value);
		if (trimmed == "0x0")
			return "none";
		return trimmed;
	}

	static function between(value:String, left:String, right:String):String {
		final start = value.indexOf(left);
		if (start < 0)
			return "";
		final bodyStart = start + left.length;
		final end = value.indexOf(right, bodyStart);
		if (end < 0)
			return value.substr(bodyStart);
		return value.substr(bodyStart, end - bodyStart);
	}
}
