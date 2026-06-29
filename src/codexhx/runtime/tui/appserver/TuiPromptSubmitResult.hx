package codexhx.runtime.tui.appserver;

/**
	Structured result from admitting a composer prompt into the fake app-server.
**/
class TuiPromptSubmitResult {
	final statusValue:TuiPromptSubmitStatus;
	final envelopeValue:Null<TuiPromptSubmitEnvelope>;
	final effectsValue:Array<TuiAppServerShellEffect>;

	public function new(status:TuiPromptSubmitStatus, envelope:Null<TuiPromptSubmitEnvelope>, effects:Array<TuiAppServerShellEffect>) {
		this.statusValue = status;
		this.envelopeValue = envelope;
		this.effectsValue = effects == null ? [] : effects;
	}

	public static function refused(status:TuiPromptSubmitStatus):TuiPromptSubmitResult {
		return new TuiPromptSubmitResult(status, null, []);
	}

	public static function accepted(envelope:TuiPromptSubmitEnvelope, effects:Array<TuiAppServerShellEffect>):TuiPromptSubmitResult {
		return new TuiPromptSubmitResult(TuiPromptSubmitStatus.Accepted, envelope, effects);
	}

	public function status():TuiPromptSubmitStatus {
		return statusValue;
	}

	public function acceptedPrompt():Bool {
		return switch statusValue {
			case Accepted:
				true;
			case _:
				false;
		}
	}

	public function envelope():Null<TuiPromptSubmitEnvelope> {
		return envelopeValue;
	}

	public function requestIdText():String {
		return envelopeValue == null ? "" : envelopeValue.requestId.toString();
	}

	public function sessionIdText():String {
		return envelopeValue == null ? "" : envelopeValue.sessionId.toString();
	}

	public function threadIdText():String {
		return envelopeValue == null ? "" : envelopeValue.threadId.toString();
	}

	public function promptText():String {
		return envelopeValue == null ? "" : envelopeValue.promptText;
	}

	public function effectCount():Int {
		return effectsValue.length;
	}

	public function effectAt(index:Int):Null<TuiAppServerShellEffect> {
		if (index < 0 || index >= effectsValue.length)
			return null;
		return effectsValue[index];
	}

	public function registeredPromptRequestCount():Int {
		var count = 0;
		for (effect in effectsValue) {
			switch effect {
				case TuiAppServerShellEffect.RequestRegistered(_, TuiAppServerRequestMethod.PromptSubmit):
					count = count + 1;
				case _:
			}
		}
		return count;
	}
}
