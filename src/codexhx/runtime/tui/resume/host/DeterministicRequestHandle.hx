package codexhx.runtime.tui.resume.host;

class DeterministicRequestHandle {
	final commands:Array<RequestDispatchCommand>;
	final log:Array<String>;

	public function new() {
		this.commands = [];
		this.log = [];
	}

	public function dispatch(intent:RequestResponseIntent, options:RequestDispatchOptions):RequestDispatchCommand {
		final safeOptions = options == null ? defaultOptions() : options;
		final command = commandFor(intent, safeOptions);
		commands.push(command);
		log.push("dispatch:" + command.summary());
		return command;
	}

	public function commandSummaries():Array<String> {
		final out:Array<String> = [];
		for (command in commands)
			out.push(command.summary());
		return out;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function commandCount():Int {
		return commands.length;
	}

	function commandFor(intent:RequestResponseIntent, options:RequestDispatchOptions):RequestDispatchCommand {
		if (intent == null)
			return command(RequestDispatchCommandKind.SerializationRefused, "", RequestResponseIntentKind.Unknown, options.previousDispatchCount, "",
				"missing_response_intent", "missing app-server response intent", options, false);
		if (!options.appServerSessionAvailable)
			return command(RequestDispatchCommandKind.MissingSessionNoop, intent.requestId, intent.kind, options.previousDispatchCount, intent.responseJson,
				"", "app-server session unavailable", options, false);
		if (intent.kind == RequestResponseIntentKind.Unknown)
			return command(RequestDispatchCommandKind.SerializationRefused, intent.requestId, intent.kind, options.previousDispatchCount, intent.responseJson,
				"unknown_response_intent", "unknown app-server response intent", options, false);
		if (intent.kind == RequestResponseIntentKind.Resolved && intent.responseJson.length == 0)
			return command(RequestDispatchCommandKind.SerializationRefused, intent.requestId, intent.kind, options.previousDispatchCount, "",
				"missing_response_payload", "resolved app-server request has no response payload", options, false);

		final dispatchKind = intent.kind == RequestResponseIntentKind.Resolved ? RequestDispatchCommandKind.ResolveServerRequest : RequestDispatchCommandKind.RejectServerRequest;
		final orderIndex = options.previousDispatchCount + 1;
		if (!options.transportSendSucceeds)
			return command(RequestDispatchCommandKind.SendFailed, intent.requestId, intent.kind, orderIndex, intent.responseJson,
				intent.failureCode.length == 0 ? "send_failed" : intent.failureCode, intent.reason.length == 0 ? "dispatch send failed" : intent.reason,
				options, true);
		return command(dispatchKind, intent.requestId, intent.kind, orderIndex, intent.responseJson, intent.failureCode, intent.reason, options, true);
	}

	function command(kind:RequestDispatchCommandKind, requestId:String, intentKind:RequestResponseIntentKind, orderIndex:Int, responseJson:String,
			errorCode:String, errorMessage:String, options:RequestDispatchOptions, transportSendIntentRecorded:Bool):RequestDispatchCommand {
		return new RequestDispatchCommand({
			kind: kind,
			requestId: requestId,
			intentKind: intentKind,
			orderIndex: orderIndex < 0 ? 0 : orderIndex,
			responseJson: responseJson,
			errorCode: errorCode,
			errorMessage: errorMessage,
			appServerSessionAvailable: options.appServerSessionAvailable,
			transportSendIntentRecorded: transportSendIntentRecorded,
			liveTransportAttempted: false,
			liveTransportSuppressed: true
		});
	}

	static function defaultOptions():RequestDispatchOptions {
		return new RequestDispatchOptions({
			appServerSessionAvailable: false,
			transportSendSucceeds: false,
			previousDispatchCount: 0
		});
	}
}
