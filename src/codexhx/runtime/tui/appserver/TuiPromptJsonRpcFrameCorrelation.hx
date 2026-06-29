package codexhx.runtime.tui.appserver;

/**
	Typed correlation report for an ordered prompt JSON-RPC frame log.
**/
class TuiPromptJsonRpcFrameCorrelation {
	public final status:TuiPromptJsonRpcCorrelationStatus;
	public final requestIdText:String;
	public final requestIdJsonScalar:String;
	public final responseIdText:String;
	public final responseIdJsonScalar:String;
	public final streamNotificationCount:Int;

	public function new(status:TuiPromptJsonRpcCorrelationStatus, requestIdText:String, requestIdJsonScalar:String, responseIdText:String,
			responseIdJsonScalar:String, streamNotificationCount:Int) {
		this.status = status;
		this.requestIdText = normalize(requestIdText);
		this.requestIdJsonScalar = normalize(requestIdJsonScalar);
		this.responseIdText = normalize(responseIdText);
		this.responseIdJsonScalar = normalize(responseIdJsonScalar);
		this.streamNotificationCount = streamNotificationCount < 0 ? 0 : streamNotificationCount;
	}

	public static function fromFrames(frames:Array<TuiPromptJsonRpcFrame>):TuiPromptJsonRpcFrameCorrelation {
		var requestIdText = "";
		var requestIdJsonScalar = "";
		var responseIdText = "";
		var responseIdJsonScalar = "";
		var hasRequest = false;
		var hasResponse = false;
		var streamCount = 0;
		if (frames != null) {
			for (frame in frames) {
				switch frame {
					case TuiPromptJsonRpcFrame.Request(request):
						if (!hasRequest) {
							hasRequest = true;
							requestIdText = request.requestId.toString();
							requestIdJsonScalar = request.requestId.toJsonScalar();
						}
					case TuiPromptJsonRpcFrame.Response(response):
						if (!hasResponse) {
							hasResponse = true;
							responseIdText = response.requestId.toString();
							responseIdJsonScalar = response.requestId.toJsonScalar();
						}
					case TuiPromptJsonRpcFrame.StreamNotification(_):
						streamCount = streamCount + 1;
				}
			}
		}
		if (!hasRequest)
			return new TuiPromptJsonRpcFrameCorrelation(TuiPromptJsonRpcCorrelationStatus.MissingRequest, "", "", responseIdText, responseIdJsonScalar,
				streamCount);
		if (!hasResponse)
			return new TuiPromptJsonRpcFrameCorrelation(TuiPromptJsonRpcCorrelationStatus.RequestOnly, requestIdText, requestIdJsonScalar, "", "", streamCount);
		final status = requestIdJsonScalar == responseIdJsonScalar ? TuiPromptJsonRpcCorrelationStatus.Complete : TuiPromptJsonRpcCorrelationStatus.ResponseIdMismatch;
		return new TuiPromptJsonRpcFrameCorrelation(status, requestIdText, requestIdJsonScalar, responseIdText, responseIdJsonScalar, streamCount);
	}

	public function isComplete():Bool {
		return status.text() == TuiPromptJsonRpcCorrelationStatus.Complete.text();
	}

	public function statusText():String {
		return status.text();
	}

	public function code():String {
		return status.text();
	}

	static function normalize(value:String):String {
		return value == null ? "" : value;
	}
}
