package codexhx.runtime.tui.smoke;

typedef TuiSmokeTerminalHyperlinkActionFields = {
	final kind:TuiSmokeTerminalHyperlinkActionKind;
	final text:String;
	final destination:String;
	final safeDestination:String;
	final decoratedText:String;
	final strippedText:String;
	final startColumn:Int;
	final endColumn:Int;
	final prefixWidth:Int;
	final shiftedStartColumn:Int;
	final shiftedEndColumn:Int;
	final validWebDestination:Bool;
	final osc8PairCount:Int;
	final liveWriteAllowed:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeTerminalHyperlinkAction {
	public final kind:TuiSmokeTerminalHyperlinkActionKind;
	public final text:String;
	public final destination:String;
	public final safeDestination:String;
	public final decoratedText:String;
	public final strippedText:String;
	public final startColumn:Int;
	public final endColumn:Int;
	public final prefixWidth:Int;
	public final shiftedStartColumn:Int;
	public final shiftedEndColumn:Int;
	public final validWebDestination:Bool;
	public final osc8PairCount:Int;
	public final liveWriteAllowed:Bool;
	public final failureCode:String;

	public function computedSafeDestination():String {
		return stripControlChars(destination);
	}

	public function computedValidWebDestination():Bool {
		return webDestination(computedSafeDestination());
	}

	public function destinationMatches():Bool {
		return safeDestination == "" || safeDestination == computedSafeDestination();
	}

	public function validWebDestinationMatches():Bool {
		return computedValidWebDestination() == validWebDestination;
	}

	public function computedDecoratedText():String {
		if (!computedValidWebDestination()) {
			return text;
		}
		final esc = String.fromCharCode(27);
		final bel = String.fromCharCode(7);
		return esc + "]8;;" + computedSafeDestination() + bel + text + esc + "]8;;" + bel;
	}

	public function decoratedMatches():Bool {
		return decoratedText == "" || decoratedText == computedDecoratedText();
	}

	public function computedStrippedText():String {
		return stripOsc8(decoratedText == "" ? computedDecoratedText() : decoratedText);
	}

	public function strippedMatches():Bool {
		return strippedText == "" || strippedText == computedStrippedText();
	}

	public function computedOsc8PairCount():Int {
		final decorated = decoratedText == "" ? computedDecoratedText() : decoratedText;
		final marker = String.fromCharCode(27) + "]8;;";
		var count = 0;
		var offset = 0;
		while (offset < decorated.length) {
			final index = decorated.indexOf(marker, offset);
			if (index < 0) {
				break;
			}
			count++;
			offset = index + marker.length;
		}
		return Std.int(count / 2);
	}

	public function osc8PairCountMatches():Bool {
		return osc8PairCount <= 0 || computedOsc8PairCount() == osc8PairCount;
	}

	public function computedStartColumn():Int {
		final candidate = discoveredCandidate();
		if (candidate == "") {
			return -1;
		}
		return text.indexOf(candidate);
	}

	public function computedEndColumn():Int {
		final start = computedStartColumn();
		return start < 0 ? -1 : start + discoveredCandidate().length;
	}

	public function columnsMatch():Bool {
		if (startColumn < 0 || endColumn < 0) {
			return true;
		}
		return computedStartColumn() == startColumn && computedEndColumn() == endColumn;
	}

	public function computedShiftedStartColumn():Int {
		return startColumn + prefixWidth;
	}

	public function computedShiftedEndColumn():Int {
		return endColumn + prefixWidth;
	}

	public function shiftedColumnsMatch():Bool {
		if (shiftedStartColumn < 0 || shiftedEndColumn < 0) {
			return true;
		}
		return computedShiftedStartColumn() == shiftedStartColumn && computedShiftedEndColumn() == shiftedEndColumn;
	}

	public function discoveredDestination():String {
		return discoveredCandidate();
	}

	static function stripControlChars(value:String):String {
		final out = new StringBuf();
		for (i in 0...value.length) {
			final code = value.charCodeAt(i);
			if (code >= 32 && code != 127) {
				out.addChar(code);
			}
		}
		return out.toString();
	}

	static function webDestination(value:String):Bool {
		final schemeEnd = value.indexOf("://");
		if (schemeEnd < 0) {
			return false;
		}
		final scheme = value.substr(0, schemeEnd);
		if (scheme != "http" && scheme != "https") {
			return false;
		}
		final hostStart = schemeEnd + 3;
		if (hostStart >= value.length) {
			return false;
		}
		final slash = value.indexOf("/", hostStart);
		final host = slash < 0 ? value.substr(hostStart) : value.substr(hostStart, slash - hostStart);
		return host != "";
	}

	static function stripOsc8(value:String):String {
		final esc = String.fromCharCode(27);
		final bel = String.fromCharCode(7);
		final marker = esc + "]8;;";
		final out = new StringBuf();
		var index = 0;
		while (index < value.length) {
			if (value.substr(index, marker.length) == marker) {
				index += marker.length;
				while (index < value.length) {
					if (value.substr(index, 1) == bel) {
						index++;
						break;
					}
					if (value.substr(index, 2) == esc + "\\") {
						index += 2;
						break;
					}
					index++;
				}
			} else {
				out.add(value.substr(index, 1));
				index++;
			}
		}
		return out.toString();
	}

	function discoveredCandidate():String {
		for (rawToken in text.split(" ")) {
			final candidate = trimUrlToken(rawToken);
			if (webDestination(stripControlChars(candidate))) {
				return stripControlChars(candidate);
			}
		}
		return "";
	}

	static function trimUrlToken(token:String):String {
		var start = 0;
		while (start < token.length && isLeadingPunctuation(token.charAt(start))) {
			start++;
		}
		var end = token.length;
		while (end > start && shouldTrimTrailing(token.substr(start, end - start), token.charAt(end - 1))) {
			end--;
		}
		return start >= end ? "" : token.substr(start, end - start);
	}

	static function isLeadingPunctuation(ch:String):Bool {
		return ch == "(" || ch == ")" || ch == "[" || ch == "]" || ch == "{" || ch == "}" || ch == "<" || ch == ">" || ch == "," || ch == "." || ch == ";"
			|| ch == "!" || ch == "'" || ch == "\"";
	}

	static function shouldTrimTrailing(candidate:String, ch:String):Bool {
		return ch == ","
			|| ch == "."
			|| ch == ";"
			|| ch == "!"
			|| ch == "'"
			|| ch == "\""
			|| ((ch == ")" || ch == "]" || ch == "}" || ch == ">") && hasUnmatchedClosingDelimiter(candidate, ch));
	}

	static function hasUnmatchedClosingDelimiter(candidate:String, closing:String):Bool {
		final opening = switch closing {
			case ")": "(";
			case "]": "[";
			case "}": "{";
			case ">": "<";
			case _: "";
		}
		if (opening == "") {
			return false;
		}
		return countChar(candidate, closing) > countChar(candidate, opening);
	}

	static function countChar(value:String, ch:String):Int {
		var count = 0;
		for (i in 0...value.length) {
			if (value.charAt(i) == ch) {
				count++;
			}
		}
		return count;
	}
}
