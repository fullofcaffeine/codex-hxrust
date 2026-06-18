package codexhx.runtime.tui.smoke;

typedef TuiSmokeDesktopNotificationActionFields = {
	final kind:TuiSmokeDesktopNotificationActionKind;
	final method:TuiSmokeDesktopNotificationMethodKind;
	final terminalName:String;
	final multiplexer:String;
	final backend:TuiSmokeDesktopNotificationBackendKind;
	final condition:TuiSmokeDesktopNotificationConditionKind;
	final terminalFocused:Bool;
	final shouldEmit:Bool;
	final message:String;
	final escapedMessage:String;
	final dcsPassthrough:Bool;
	final liveWriteAllowed:Bool;
	final emitted:Bool;
	final disabledAfterFailure:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeDesktopNotificationAction {
	public final kind:TuiSmokeDesktopNotificationActionKind;
	public final method:TuiSmokeDesktopNotificationMethodKind;
	public final terminalName:String;
	public final multiplexer:String;
	public final backend:TuiSmokeDesktopNotificationBackendKind;
	public final condition:TuiSmokeDesktopNotificationConditionKind;
	public final terminalFocused:Bool;
	public final shouldEmit:Bool;
	public final message:String;
	public final escapedMessage:String;
	public final dcsPassthrough:Bool;
	public final liveWriteAllowed:Bool;
	public final emitted:Bool;
	public final disabledAfterFailure:Bool;
	public final failureCode:String;

	public function computedBackend():TuiSmokeDesktopNotificationBackendKind {
		return switch method {
			case TuiSmokeDesktopNotificationMethodKind.Osc9:
				TuiSmokeDesktopNotificationBackendKind.Osc9;
			case TuiSmokeDesktopNotificationMethodKind.Bel:
				TuiSmokeDesktopNotificationBackendKind.Bel;
			case TuiSmokeDesktopNotificationMethodKind.Auto:
				supportsOsc9(terminalName) ? TuiSmokeDesktopNotificationBackendKind.Osc9 : TuiSmokeDesktopNotificationBackendKind.Bel;
			case _:
				TuiSmokeDesktopNotificationBackendKind.Unknown;
		}
	}

	public function backendMatches():Bool {
		return backend == TuiSmokeDesktopNotificationBackendKind.Unknown
			|| backend == TuiSmokeDesktopNotificationBackendKind.None
			|| computedBackend() == backend;
	}

	public function computedShouldEmit():Bool {
		return switch condition {
			case TuiSmokeDesktopNotificationConditionKind.Always:
				true;
			case TuiSmokeDesktopNotificationConditionKind.Unfocused:
				!terminalFocused;
			case _:
				false;
		}
	}

	public function shouldEmitMatches():Bool {
		return condition == TuiSmokeDesktopNotificationConditionKind.Unknown || computedShouldEmit() == shouldEmit;
	}

	public function computedEscapedMessage():String {
		if (!dcsPassthrough) {
			return message;
		}
		final esc = String.fromCharCode(27);
		return StringTools.replace(message, esc, esc + esc);
	}

	public function escapedMessageMatches():Bool {
		return escapedMessage == "" || computedEscapedMessage() == escapedMessage;
	}

	public function messageEscapeCount():Int {
		return countEscapes(message);
	}

	public function escapedMessageEscapeCount():Int {
		return countEscapes(computedEscapedMessage());
	}

	public function backendTraceName():String {
		return backend == TuiSmokeDesktopNotificationBackendKind.Unknown ? computedBackend() : backend;
	}

	static function supportsOsc9(name:String):Bool {
		final normalized = name.toLowerCase();
		return normalized == "ghostty"
			|| normalized == "iterm2"
			|| normalized == "kitty"
			|| normalized == "warp"
			|| normalized == "warpterminal"
			|| normalized == "warp_terminal"
			|| normalized == "wezterm";
	}

	static function countEscapes(value:String):Int {
		var count = 0;
		for (i in 0...value.length) {
			if (value.charCodeAt(i) == 27) {
				count++;
			}
		}
		return count;
	}
}
