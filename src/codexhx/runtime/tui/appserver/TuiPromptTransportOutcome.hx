package codexhx.runtime.tui.appserver;

/**
	Typed outcome from the prompt transport seam.
**/
class TuiPromptTransportOutcome {
	final acceptedValue:Bool;
	final codeValue:String;
	final responseValue:Null<TuiPromptTurnStartResponse>;
	final eventsValue:Array<TuiAppServerEvent>;

	public function new(accepted:Bool, code:String, response:Null<TuiPromptTurnStartResponse>, events:Array<TuiAppServerEvent>) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "accepted" : "rejected");
		this.responseValue = response;
		this.eventsValue = events == null ? [] : events.copy();
	}

	public static function accepted(events:Array<TuiAppServerEvent>):TuiPromptTransportOutcome {
		return new TuiPromptTransportOutcome(true, "accepted", null, events);
	}

	public static function acceptedWithResponse(response:TuiPromptTurnStartResponse, events:Array<TuiAppServerEvent>):TuiPromptTransportOutcome {
		return new TuiPromptTransportOutcome(true, "accepted", response, events);
	}

	public static function rejected(code:String):TuiPromptTransportOutcome {
		return new TuiPromptTransportOutcome(false, code, null, []);
	}

	public function isAccepted():Bool {
		return acceptedValue;
	}

	public function code():String {
		return codeValue;
	}

	public function eventCount():Int {
		return eventsValue.length;
	}

	public function response():Null<TuiPromptTurnStartResponse> {
		return responseValue;
	}

	public function eventAt(index:Int):Null<TuiAppServerEvent> {
		if (index < 0 || index >= eventsValue.length)
			return null;
		return eventsValue[index];
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
