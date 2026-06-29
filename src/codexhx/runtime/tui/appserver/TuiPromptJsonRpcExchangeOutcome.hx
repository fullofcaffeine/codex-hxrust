package codexhx.runtime.tui.appserver;

/**
	Typed result from the fake JSON-RPC prompt exchange.
**/
class TuiPromptJsonRpcExchangeOutcome {
	final acceptedValue:Bool;
	final codeValue:String;
	final responseValue:Null<TuiPromptJsonRpcResponse>;
	final notificationsValue:Array<TuiPromptJsonRpcNotification>;
	final eventsValue:Array<TuiAppServerEvent>;

	public function new(accepted:Bool, code:String, response:Null<TuiPromptJsonRpcResponse>, notifications:Array<TuiPromptJsonRpcNotification>,
			events:Array<TuiAppServerEvent>) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "accepted" : "rejected");
		this.responseValue = response;
		this.notificationsValue = notifications == null ? [] : notifications.copy();
		this.eventsValue = events == null ? [] : events.copy();
	}

	public static function accepted(response:TuiPromptJsonRpcResponse, notifications:Array<TuiPromptJsonRpcNotification>,
			events:Array<TuiAppServerEvent>):TuiPromptJsonRpcExchangeOutcome {
		return new TuiPromptJsonRpcExchangeOutcome(true, "accepted", response, notifications, events);
	}

	public static function rejected(code:String):TuiPromptJsonRpcExchangeOutcome {
		return new TuiPromptJsonRpcExchangeOutcome(false, code, null, [], []);
	}

	public function isAccepted():Bool {
		return acceptedValue;
	}

	public function code():String {
		return codeValue;
	}

	public function response():Null<TuiPromptJsonRpcResponse> {
		return responseValue;
	}

	public function eventCount():Int {
		return eventsValue.length;
	}

	public function notificationCount():Int {
		return notificationsValue.length;
	}

	public function notificationAt(index:Int):Null<TuiPromptJsonRpcNotification> {
		if (index < 0 || index >= notificationsValue.length)
			return null;
		return notificationsValue[index];
	}

	public function notifications():Array<TuiPromptJsonRpcNotification> {
		return notificationsValue.copy();
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
