package codexhx.runtime.tui.appserver;

/**
	Typed frame transcript owned by the app-server JSON-RPC transport boundary.
**/
class TuiAppServerJsonRpcTransportTranscript {
	final requestValue:Null<TuiPromptJsonRpcRequest>;
	final inboundFramesValue:Array<TuiPromptJsonRpcFrame>;

	public function new(request:Null<TuiPromptJsonRpcRequest>, inboundFrames:Array<TuiPromptJsonRpcFrame>) {
		this.requestValue = request;
		this.inboundFramesValue = inboundFrames == null ? [] : inboundFrames.copy();
	}

	public static function empty():TuiAppServerJsonRpcTransportTranscript {
		return new TuiAppServerJsonRpcTransportTranscript(null, []);
	}

	public static function outbound(request:TuiPromptJsonRpcRequest):TuiAppServerJsonRpcTransportTranscript {
		return new TuiAppServerJsonRpcTransportTranscript(request, []);
	}

	public static function accepted(request:TuiPromptJsonRpcRequest, response:TuiPromptJsonRpcResponse,
			streamNotifications:Array<TuiPromptJsonRpcStreamNotification>):TuiAppServerJsonRpcTransportTranscript {
		final inbound:Array<TuiPromptJsonRpcFrame> = [];
		if (response != null)
			inbound.push(TuiPromptJsonRpcFrame.Response(response));
		if (streamNotifications != null) {
			for (notification in streamNotifications)
				inbound.push(TuiPromptJsonRpcFrame.StreamNotification(notification));
		}
		return new TuiAppServerJsonRpcTransportTranscript(request, inbound);
	}

	public function request():Null<TuiPromptJsonRpcRequest> {
		return requestValue;
	}

	public function inboundFrameCount():Int {
		return inboundFramesValue.length;
	}

	public function frameCount():Int {
		return (requestValue == null ? 0 : 1) + inboundFramesValue.length;
	}

	public function frameAt(index:Int):Null<TuiPromptJsonRpcFrame> {
		if (index < 0)
			return null;
		var inboundIndex = index;
		if (requestValue != null) {
			if (index == 0)
				return TuiPromptJsonRpcFrame.Request(requestValue);
			inboundIndex = index - 1;
		}
		if (inboundIndex >= inboundFramesValue.length)
			return null;
		return inboundFramesValue[inboundIndex];
	}

	public function frames():Array<TuiPromptJsonRpcFrame> {
		final out:Array<TuiPromptJsonRpcFrame> = [];
		if (requestValue != null)
			out.push(TuiPromptJsonRpcFrame.Request(requestValue));
		for (frame in inboundFramesValue)
			out.push(frame);
		return out;
	}
}
