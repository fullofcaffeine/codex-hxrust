package codexhx.runtime.tui.appserver;

/**
	Strict decode outcome for inbound `turn/interrupt` JSONL.
**/
class TuiPromptTurnInterruptInboundLineDecodeOutcome {
	final acceptedValue:Bool;
	final codeValue:String;
	final responseValue:Null<TuiPromptTurnInterruptResponse>;
	final eventsValue:Array<TuiAppServerEvent>;

	public function new(accepted:Bool, code:String, response:Null<TuiPromptTurnInterruptResponse>, events:Array<TuiAppServerEvent>) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "accepted" : "rejected");
		this.responseValue = response;
		this.eventsValue = events == null ? [] : events.copy();
	}

	public static function accepted(response:TuiPromptTurnInterruptResponse, events:Array<TuiAppServerEvent>):TuiPromptTurnInterruptInboundLineDecodeOutcome {
		return new TuiPromptTurnInterruptInboundLineDecodeOutcome(true, "accepted", response, events);
	}

	public static function rejected(code:String):TuiPromptTurnInterruptInboundLineDecodeOutcome {
		return new TuiPromptTurnInterruptInboundLineDecodeOutcome(false, code, null, []);
	}

	public function isAccepted():Bool {
		return acceptedValue;
	}

	public function code():String {
		return codeValue;
	}

	public function response():Null<TuiPromptTurnInterruptResponse> {
		return responseValue;
	}

	public function events():Array<TuiAppServerEvent> {
		return eventsValue.copy();
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
