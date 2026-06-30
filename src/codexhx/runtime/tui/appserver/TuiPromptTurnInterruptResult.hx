package codexhx.runtime.tui.appserver;

/**
	Facade-level result for a live-shell active-turn interrupt request.
**/
class TuiPromptTurnInterruptResult {
	final acceptedValue:Bool;
	final codeValue:String;
	final envelopeValue:Null<TuiPromptTurnInterruptEnvelope>;
	final effectsValue:Array<TuiAppServerShellEffect>;

	public function new(accepted:Bool, code:String, envelope:Null<TuiPromptTurnInterruptEnvelope>, effects:Array<TuiAppServerShellEffect>) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "accepted" : "rejected");
		this.envelopeValue = envelope;
		this.effectsValue = effects == null ? [] : effects.copy();
	}

	public static function accepted(envelope:TuiPromptTurnInterruptEnvelope, effects:Array<TuiAppServerShellEffect>):TuiPromptTurnInterruptResult {
		return new TuiPromptTurnInterruptResult(true, "accepted", envelope, effects);
	}

	public static function rejected(code:String):TuiPromptTurnInterruptResult {
		return new TuiPromptTurnInterruptResult(false, code, null, []);
	}

	public static function transportRejected(envelope:TuiPromptTurnInterruptEnvelope, effects:Array<TuiAppServerShellEffect>,
			code:String):TuiPromptTurnInterruptResult {
		return new TuiPromptTurnInterruptResult(false, code, envelope, effects);
	}

	public function acceptedInterrupt():Bool {
		return acceptedValue;
	}

	public function code():String {
		return codeValue;
	}

	public function envelope():Null<TuiPromptTurnInterruptEnvelope> {
		return envelopeValue;
	}

	public function effectCount():Int {
		return effectsValue.length;
	}

	public function effectAt(index:Int):Null<TuiAppServerShellEffect> {
		if (index < 0 || index >= effectsValue.length)
			return null;
		return effectsValue[index];
	}

	public function effects():Array<TuiAppServerShellEffect> {
		return effectsValue.copy();
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
