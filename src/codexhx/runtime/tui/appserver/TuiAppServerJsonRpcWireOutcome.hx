package codexhx.runtime.tui.appserver;

/**
	Typed result from one app-server JSON-RPC wire-session exchange.
**/
class TuiAppServerJsonRpcWireOutcome {
	final status:TuiAppServerJsonRpcTransportStatus;
	final codeValue:String;
	final responseValue:Null<TuiPromptJsonRpcResponse>;
	final notificationsValue:Array<TuiPromptJsonRpcNotification>;
	final streamNotificationsValue:Array<TuiPromptJsonRpcStreamNotification>;
	final eventsValue:Array<TuiAppServerEvent>;
	final inboundRecordsValue:Array<TuiPromptJsonRpcFrameRecord>;

	public function new(status:TuiAppServerJsonRpcTransportStatus, code:String, response:Null<TuiPromptJsonRpcResponse>,
			notifications:Array<TuiPromptJsonRpcNotification>, streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>,
			inboundRecords:Array<TuiPromptJsonRpcFrameRecord>) {
		this.status = status;
		this.codeValue = normalize(code, status.text());
		this.responseValue = response;
		this.notificationsValue = notifications == null ? [] : notifications.copy();
		this.streamNotificationsValue = streamNotifications == null ? [] : streamNotifications.copy();
		this.eventsValue = events == null ? [] : events.copy();
		this.inboundRecordsValue = inboundRecords == null ? [] : inboundRecords.copy();
	}

	public static function accepted(response:TuiPromptJsonRpcResponse, notifications:Array<TuiPromptJsonRpcNotification>,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>, events:Array<TuiAppServerEvent>,
			inboundRecords:Array<TuiPromptJsonRpcFrameRecord>):TuiAppServerJsonRpcWireOutcome {
		return new TuiAppServerJsonRpcWireOutcome(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", response, notifications, streamNotifications,
			events, inboundRecords);
	}

	public static function rejected(code:String, ?inboundRecords:Array<TuiPromptJsonRpcFrameRecord>):TuiAppServerJsonRpcWireOutcome {
		return new TuiAppServerJsonRpcWireOutcome(TuiAppServerJsonRpcTransportStatus.Rejected, code, null, [], [], [], inboundRecords);
	}

	public static function disconnected(code:String, ?inboundRecords:Array<TuiPromptJsonRpcFrameRecord>):TuiAppServerJsonRpcWireOutcome {
		return new TuiAppServerJsonRpcWireOutcome(TuiAppServerJsonRpcTransportStatus.Disconnected, code, null, [], [], [], inboundRecords);
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

	public function inboundRecordCount():Int {
		return inboundRecordsValue.length;
	}

	public function inboundRecordAt(index:Int):Null<TuiPromptJsonRpcFrameRecord> {
		if (index < 0 || index >= inboundRecordsValue.length)
			return null;
		return inboundRecordsValue[index];
	}

	public function inboundRecords():Array<TuiPromptJsonRpcFrameRecord> {
		return inboundRecordsValue.copy();
	}

	public function inboundFrames():Array<TuiPromptJsonRpcFrame> {
		final out:Array<TuiPromptJsonRpcFrame> = [];
		for (record in inboundRecordsValue)
			out.push(record.frame);
		return out;
	}

	static function normalize(value:String, fallback:String):String {
		if (value == null || value.length == 0)
			return fallback;
		return value;
	}
}
