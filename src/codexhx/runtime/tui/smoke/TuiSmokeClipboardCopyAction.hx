package codexhx.runtime.tui.smoke;

typedef TuiSmokeClipboardCopyActionFields = {
	final kind:TuiSmokeClipboardCopyActionKind;
	final text:String;
	final sshSession:Bool;
	final wslSession:Bool;
	final tmuxSession:Bool;
	final nativeOk:Bool;
	final nativeLease:Bool;
	final wslOk:Bool;
	final tmuxOk:Bool;
	final osc52Ok:Bool;
	final expectedBackend:String;
	final expectedSequence:String;
	final tmuxSetClipboard:String;
	final tmuxInfo:String;
	final expectedReady:Bool;
	final rawBytes:Int;
	final maxRawBytes:Int;
	final failureCode:String;
	final liveClipboardAllowed:Bool;
	final liveTerminalWriteAllowed:Bool;
	final processSpawnAllowed:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeClipboardCopyAction {
	public final kind:TuiSmokeClipboardCopyActionKind;
	public final text:String;
	public final sshSession:Bool;
	public final wslSession:Bool;
	public final tmuxSession:Bool;
	public final nativeOk:Bool;
	public final nativeLease:Bool;
	public final wslOk:Bool;
	public final tmuxOk:Bool;
	public final osc52Ok:Bool;
	public final expectedBackend:String;
	public final expectedSequence:String;
	public final tmuxSetClipboard:String;
	public final tmuxInfo:String;
	public final expectedReady:Bool;
	@:recordMin(0)
	public final rawBytes:Int;
	@:recordMin(0)
	public final maxRawBytes:Int;
	public final failureCode:String;
	public final liveClipboardAllowed:Bool;
	public final liveTerminalWriteAllowed:Bool;
	public final processSpawnAllowed:Bool;

	public function routedBackend():String {
		if (sshSession) {
			return terminalBackend();
		}
		if (nativeOk) {
			return nativeLease ? "native_lease" : "native";
		}
		if (wslSession && wslOk) {
			return "wsl_powershell";
		}
		return terminalBackend();
	}

	public function routeMatches():Bool {
		return expectedBackend == "" || routedBackend() == expectedBackend;
	}

	public function computedOsc52Sequence():String {
		if (text.length > maxRawBytes) return "";
		final encoded = base64Ascii(text);
		return tmuxSession ? esc() + "Ptmux;" + esc() + esc() + "]52;c;" + encoded + bel() + esc() + "\\" : esc() + "]52;c;" + encoded + bel();
	}

	public function osc52Matches():Bool {
		return expectedSequence == "" || computedOsc52Sequence() == expectedSequence;
	}

	public function rawByteCountMatches():Bool {
		return rawBytes == 0 || rawBytes == text.length;
	}

	public function computedTmuxReady():Bool {
		if (StringTools.trim(tmuxSetClipboard) == "off") return false;
		if (tmuxInfo.indexOf("Ms: [missing]") >= 0) return false;
		return tmuxSetClipboard.length > 0 && tmuxInfo.length > 0;
	}

	public function tmuxReadyMatches():Bool {
		return computedTmuxReady() == expectedReady;
	}

	function terminalBackend():String {
		if (tmuxSession) {
			if (tmuxOk) return "tmux";
			if (osc52Ok) return "osc52_after_tmux_failure";
			return "failed_terminal";
		}
		return osc52Ok ? "osc52" : "failed_osc52";
	}

	static function base64Ascii(value:String):String {
		final alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
		final out = new StringBuf();
		var index = 0;
		while (index < value.length) {
			final b0 = codeUnitAt(value, index);
			final hasB1 = index + 1 < value.length;
			final hasB2 = index + 2 < value.length;
			final b1 = hasB1 ? codeUnitAt(value, index + 1) : 0;
			final b2 = hasB2 ? codeUnitAt(value, index + 2) : 0;
			out.add(alphabet.charAt((b0 >> 2) & 63));
			out.add(alphabet.charAt(((b0 & 3) << 4) | ((b1 >> 4) & 15)));
			out.add(hasB1 ? alphabet.charAt(((b1 & 15) << 2) | ((b2 >> 6) & 3)) : "=");
			out.add(hasB2 ? alphabet.charAt(b2 & 63) : "=");
			index += 3;
		}
		return out.toString();
	}

	static function codeUnitAt(value:String, index:Int):Int {
		final code = value.charCodeAt(index);
		return code == null ? 0 : code;
	}

	static function esc():String {
		return String.fromCharCode(27);
	}

	static function bel():String {
		return String.fromCharCode(7);
	}
}
