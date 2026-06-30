package codexhx.runtime.tui.appserver;

/**
	Typed result from decoding inbound app-server prompt JSONL records.

	Why
	- Process-backed line transport receives raw stdout lines, but the existing
	  wire/session layers consume typed prompt response and stream-notification
	  values.

	What
	- Carries the decoded `turn/start` response, selected turn notifications,
	  stream notifications, and any shell events produced by the decoded stream.

	How
	- Keeps parse failures as stable boundary codes so callers can reject the
	  process exchange without throwing or hiding the raw line transcript.
**/
class TuiPromptJsonRpcInboundLineDecodeOutcome {
	final acceptedValue:Bool;
	final codeValue:String;
	final responseValue:Null<TuiPromptJsonRpcResponse>;
	final notificationsValue:Array<TuiPromptJsonRpcNotification>;
	final streamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	final eventsValue:Array<TuiAppServerEvent>;

	public function new(accepted:Bool, code:String, response:Null<TuiPromptJsonRpcResponse>, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>) {
		this.acceptedValue = accepted;
		this.codeValue = normalize(code, accepted ? "accepted" : "rejected");
		this.responseValue = response;
		this.notificationsValue = notifications == null ? [] : notifications.copy();
		this.streamNotificationsValue = streamNotifications == null ? [] : streamNotifications.copy();
		this.eventsValue = events == null ? [] : events.copy();
	}

	public static function accepted(response:TuiPromptJsonRpcResponse, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>):TuiPromptJsonRpcInboundLineDecodeOutcome {
		return new TuiPromptJsonRpcInboundLineDecodeOutcome(true, "accepted", response, notifications, streamNotifications, events);
	}

	public static function rejected(code:String):TuiPromptJsonRpcInboundLineDecodeOutcome {
		return new TuiPromptJsonRpcInboundLineDecodeOutcome(false, code, null, [], [], []);
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

	public function notifications():Array<TuiPromptJsonRpcNotification> {
		return notificationsValue.copy();
	}

	public function streamNotifications():Array<TuiPromptJsonRpcStreamNotification> {
		return streamNotificationsValue.copy();
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
