package codexhx.runtime.tui.appserver;

/**
	Typed result from a line-oriented app-server JSON-RPC exchange.
**/
class TuiAppServerJsonRpcLineOutcome {
	final status:TuiAppServerJsonRpcTransportStatus;
	final codeValue:String;
	final responseValue:Null<TuiPromptJsonRpcResponse>;
	final notificationsValue:Array<TuiPromptJsonRpcNotification>;
	final streamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	final eventsValue:Array<TuiAppServerEvent>;
	final inboundLinesValue:Array<String>;
	final transcriptValue:TuiAppServerJsonRpcLineTranscript;

	public function new(status:TuiAppServerJsonRpcTransportStatus, code:String, response:Null<TuiPromptJsonRpcResponse>,
			notifications:Array<TuiPromptJsonRpcNotification>, streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>,
			inboundLines:Array<String>, ?transcript:TuiAppServerJsonRpcLineTranscript) {
		this.status = status;
		this.codeValue = normalize(code, status.text());
		this.responseValue = response;
		this.notificationsValue = notifications == null ? [] : notifications.copy();
		this.streamNotificationsValue = streamNotifications == null ? [] : streamNotifications.copy();
		this.eventsValue = events == null ? [] : events.copy();
		this.inboundLinesValue = inboundLines == null ? [] : inboundLines.copy();
		this.transcriptValue = transcript == null ? TuiAppServerJsonRpcLineTranscript.empty() : transcript;
	}

	public static function accepted(response:TuiPromptJsonRpcResponse, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>, inboundLines:Array<String>,
			?transcript:TuiAppServerJsonRpcLineTranscript):TuiAppServerJsonRpcLineOutcome {
		return new TuiAppServerJsonRpcLineOutcome(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", response, notifications, streamNotifications,
			events, inboundLines, transcript);
	}

	public static function rejected(code:String, ?inboundLines:Array<String>, ?transcript:TuiAppServerJsonRpcLineTranscript):TuiAppServerJsonRpcLineOutcome {
		return new TuiAppServerJsonRpcLineOutcome(TuiAppServerJsonRpcTransportStatus.Rejected, code, null, [], [], [], inboundLines, transcript);
	}

	public static function disconnected(code:String, ?inboundLines:Array<String>,
			?transcript:TuiAppServerJsonRpcLineTranscript):TuiAppServerJsonRpcLineOutcome {
		return new TuiAppServerJsonRpcLineOutcome(TuiAppServerJsonRpcTransportStatus.Disconnected, code, null, [], [], [], inboundLines, transcript);
	}

	public function isAccepted():Bool {
		return status == TuiAppServerJsonRpcTransportStatus.Accepted;
	}

	public function statusText():String {
		return status.text();
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

	public function inboundLineCount():Int {
		return inboundLinesValue.length;
	}

	public function inboundLineAt(index:Int):String {
		if (index < 0 || index >= inboundLinesValue.length)
			return "";
		return inboundLinesValue[index];
	}

	public function inboundLines():Array<String> {
		return inboundLinesValue.copy();
	}

	public function transcript():TuiAppServerJsonRpcLineTranscript {
		return transcriptValue;
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
