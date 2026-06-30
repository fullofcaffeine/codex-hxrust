package codexhx.runtime.tui.appserver;

/**
	Typed app-server JSON-RPC transport outcome for prompt requests.
**/
class TuiAppServerJsonRpcTransportOutcome {
	public final status:TuiAppServerJsonRpcTransportStatus;

	final codeValue:String;
	final responseValue:Null<TuiPromptJsonRpcResponse>;
	final notificationsValue:Array<TuiPromptJsonRpcNotification>;
	final streamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	final eventsValue:Array<TuiAppServerEvent>;
	final transcriptValue:TuiAppServerJsonRpcTransportTranscript;

	public function new(status:TuiAppServerJsonRpcTransportStatus, code:String, response:Null<TuiPromptJsonRpcResponse>,
			notifications:Array<TuiPromptJsonRpcNotification>, streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>,
			?transcript:TuiAppServerJsonRpcTransportTranscript) {
		this.status = status;
		this.codeValue = normalize(code, status.text());
		this.responseValue = response;
		this.notificationsValue = notifications == null ? [] : notifications.copy();
		this.streamNotificationsValue = streamNotifications == null ? [] : streamNotifications.copy();
		this.eventsValue = events == null ? [] : events.copy();
		this.transcriptValue = transcript == null ? TuiAppServerJsonRpcTransportTranscript.empty() : transcript;
	}

	public static function accepted(response:TuiPromptJsonRpcResponse, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>,
			?transcript:TuiAppServerJsonRpcTransportTranscript):TuiAppServerJsonRpcTransportOutcome {
		return new TuiAppServerJsonRpcTransportOutcome(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", response, notifications, streamNotifications,
			events, transcript);
	}

	public static function rejected(code:String, ?transcript:TuiAppServerJsonRpcTransportTranscript):TuiAppServerJsonRpcTransportOutcome {
		return new TuiAppServerJsonRpcTransportOutcome(TuiAppServerJsonRpcTransportStatus.Rejected, code, null, [], [], [], transcript);
	}

	public static function disconnected(code:String, ?transcript:TuiAppServerJsonRpcTransportTranscript):TuiAppServerJsonRpcTransportOutcome {
		return new TuiAppServerJsonRpcTransportOutcome(TuiAppServerJsonRpcTransportStatus.Disconnected, code, null, [], [], [], transcript);
	}

	public function isAccepted():Bool {
		return status == TuiAppServerJsonRpcTransportStatus.Accepted;
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

	public function transcript():TuiAppServerJsonRpcTransportTranscript {
		return transcriptValue;
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
