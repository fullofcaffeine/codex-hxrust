package codexhx.runtime.tui.appserver;

/**
	Typed result from a line-oriented `turn/interrupt` JSON-RPC exchange.
**/
class TuiPromptTurnInterruptLineOutcome {
	public final status:TuiAppServerJsonRpcTransportStatus;

	final codeValue:String;
	final responseValue:Null<TuiPromptTurnInterruptResponse>;
	final eventsValue:Array<TuiAppServerEvent>;
	final inboundLinesValue:Array<String>;
	final transcriptValue:TuiAppServerJsonRpcLineTranscript;

	public function new(status:TuiAppServerJsonRpcTransportStatus, code:String, response:Null<TuiPromptTurnInterruptResponse>,
			events:Array<TuiAppServerEvent>, inboundLines:Array<String>, ?transcript:TuiAppServerJsonRpcLineTranscript) {
		this.status = status;
		this.codeValue = normalize(code, status.text());
		this.responseValue = response;
		this.eventsValue = events == null ? [] : events.copy();
		this.inboundLinesValue = inboundLines == null ? [] : inboundLines.copy();
		this.transcriptValue = transcript == null ? TuiAppServerJsonRpcLineTranscript.empty() : transcript;
	}

	public static function accepted(response:TuiPromptTurnInterruptResponse, events:Array<TuiAppServerEvent>, inboundLines:Array<String>,
			?transcript:TuiAppServerJsonRpcLineTranscript):TuiPromptTurnInterruptLineOutcome {
		return new TuiPromptTurnInterruptLineOutcome(TuiAppServerJsonRpcTransportStatus.Accepted, "accepted", response, events, inboundLines, transcript);
	}

	public static function rejected(code:String, ?inboundLines:Array<String>, ?transcript:TuiAppServerJsonRpcLineTranscript):TuiPromptTurnInterruptLineOutcome {
		return new TuiPromptTurnInterruptLineOutcome(TuiAppServerJsonRpcTransportStatus.Rejected, code, null, [], inboundLines, transcript);
	}

	public static function disconnected(code:String, ?inboundLines:Array<String>,
			?transcript:TuiAppServerJsonRpcLineTranscript):TuiPromptTurnInterruptLineOutcome {
		return new TuiPromptTurnInterruptLineOutcome(TuiAppServerJsonRpcTransportStatus.Disconnected, code, null, [], inboundLines, transcript);
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

	public function response():Null<TuiPromptTurnInterruptResponse> {
		return responseValue;
	}

	public function eventCount():Int {
		return eventsValue.length;
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
