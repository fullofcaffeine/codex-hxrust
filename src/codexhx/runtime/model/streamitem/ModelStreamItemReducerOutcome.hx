package codexhx.runtime.model.streamitem;

import codexhx.runtime.model.stream.ModelStreamRouteOutcome;

class ModelStreamItemReducerOutcome {
	public final ok:Bool;
	public final code:String;
	public final requestId:String;
	public final routeCode:String;
	public final providerId:String;
	public final selectedModelId:String;
	public final runtimeEvents:Array<ModelStreamRuntimeEvent>;
	public final startedCount:Int;
	public final completedCount:Int;
	public final assistantDeltaCount:Int;
	public final reasoningDeltaCount:Int;
	public final rawReasoningDeltaCount:Int;
	public final toolCallCount:Int;
	public final needsFollowUp:Bool;
	public final lastAgentMessage:String;
	public final terminalResponseId:String;
	public final totalTokens:Int;
	public final liveNetworkAttempted:Bool;
	public final errorMessage:String;
	public final sequence:String;

	function new(
		ok:Bool,
		code:String,
		request:ModelStreamItemReducerRequest,
		route:ModelStreamRouteOutcome,
		runtimeEvents:Array<ModelStreamRuntimeEvent>,
		startedCount:Int,
		completedCount:Int,
		assistantDeltaCount:Int,
		reasoningDeltaCount:Int,
		rawReasoningDeltaCount:Int,
		toolCallCount:Int,
		needsFollowUp:Bool,
		lastAgentMessage:String,
		terminalResponseId:String,
		totalTokens:Int,
		liveNetworkAttempted:Bool,
		errorMessage:String,
		sequence:String
	) {
		this.ok = ok;
		this.code = code;
		this.requestId = request.requestId;
		this.routeCode = route == null ? "none" : route.code;
		this.providerId = route == null ? "" : route.providerId;
		this.selectedModelId = route == null ? "" : route.selectedModelId;
		this.runtimeEvents = runtimeEvents == null ? [] : runtimeEvents;
		this.startedCount = startedCount;
		this.completedCount = completedCount;
		this.assistantDeltaCount = assistantDeltaCount;
		this.reasoningDeltaCount = reasoningDeltaCount;
		this.rawReasoningDeltaCount = rawReasoningDeltaCount;
		this.toolCallCount = toolCallCount;
		this.needsFollowUp = needsFollowUp;
		this.lastAgentMessage = lastAgentMessage;
		this.terminalResponseId = terminalResponseId;
		this.totalTokens = totalTokens;
		this.liveNetworkAttempted = liveNetworkAttempted;
		this.errorMessage = errorMessage;
		this.sequence = sequence;
	}

	public static function reduced(
		request:ModelStreamItemReducerRequest,
		route:ModelStreamRouteOutcome,
		runtimeEvents:Array<ModelStreamRuntimeEvent>,
		startedCount:Int,
		completedCount:Int,
		assistantDeltaCount:Int,
		reasoningDeltaCount:Int,
		rawReasoningDeltaCount:Int,
		toolCallCount:Int,
		needsFollowUp:Bool,
		lastAgentMessage:String,
		terminalResponseId:String,
		totalTokens:Int,
		sequence:String
	):ModelStreamItemReducerOutcome {
		return new ModelStreamItemReducerOutcome(
			true,
			"model_stream_items_reduced",
			request,
			route,
			runtimeEvents,
			startedCount,
			completedCount,
			assistantDeltaCount,
			reasoningDeltaCount,
			rawReasoningDeltaCount,
			toolCallCount,
			needsFollowUp,
			lastAgentMessage,
			terminalResponseId,
			totalTokens,
			false,
			"",
			sequence
		);
	}

	public static function denied(
		request:ModelStreamItemReducerRequest,
		route:ModelStreamRouteOutcome,
		errorMessage:String,
		sequence:String
	):ModelStreamItemReducerOutcome {
		return new ModelStreamItemReducerOutcome(
			false,
			"model_stream_route_denied",
			request,
			route,
			[errorEvent(ModelStreamRuntimeEventKind.RouteDenied, errorMessage)],
			0,
			0,
			0,
			0,
			0,
			0,
			false,
			"",
			"",
			0,
			false,
			errorMessage,
			sequence
		);
	}

	public static function failed(
		request:ModelStreamItemReducerRequest,
		route:ModelStreamRouteOutcome,
		runtimeEvents:Array<ModelStreamRuntimeEvent>,
		errorMessage:String,
		sequence:String
	):ModelStreamItemReducerOutcome {
		final events = runtimeEvents == null ? [] : runtimeEvents;
		events.push(errorEvent(ModelStreamRuntimeEventKind.ReducerError, errorMessage));
		return new ModelStreamItemReducerOutcome(
			false,
			"model_stream_item_reducer_failed",
			request,
			route,
			events,
			countEvents(events, ModelStreamRuntimeEventKind.ItemStarted),
			countEvents(events, ModelStreamRuntimeEventKind.ItemCompleted),
			countEvents(events, ModelStreamRuntimeEventKind.AgentMessageContentDelta),
			countEvents(events, ModelStreamRuntimeEventKind.ReasoningContentDelta),
			countEvents(events, ModelStreamRuntimeEventKind.ReasoningRawContentDelta),
			countEvents(events, ModelStreamRuntimeEventKind.ToolCallQueued),
			false,
			"",
			"",
			0,
			false,
			errorMessage,
			sequence
		);
	}

	public function summary():String {
		final eventParts:Array<String> = [];
		for (event in runtimeEvents) eventParts.push(event.summary());
		return "code=" + code
			+ ";ok=" + boolText(ok)
			+ ";request=" + requestId
			+ ";routeCode=" + routeCode
			+ ";provider=" + providerId
			+ ";model=" + selectedModelId
			+ ";started=" + Std.string(startedCount)
			+ ";completed=" + Std.string(completedCount)
			+ ";assistantDeltas=" + Std.string(assistantDeltaCount)
			+ ";reasoningDeltas=" + Std.string(reasoningDeltaCount)
			+ ";rawReasoningDeltas=" + Std.string(rawReasoningDeltaCount)
			+ ";toolCalls=" + Std.string(toolCallCount)
			+ ";needsFollowUp=" + boolText(needsFollowUp)
			+ ";lastAgentMessage=" + noneIfEmpty(lastAgentMessage)
			+ ";terminalResponseId=" + noneIfEmpty(terminalResponseId)
			+ ";totalTokens=" + Std.string(totalTokens)
			+ ";liveNetworkAttempted=" + boolText(liveNetworkAttempted)
			+ ";error=" + errorMessage
			+ ";sequence=" + sequence
			+ ";events=[" + eventParts.join("##") + "]";
	}

	static function errorEvent(kind:ModelStreamRuntimeEventKind, message:String):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(kind, ModelStreamOutputItemKind.Unknown, "", "", "", "", message, 0);
	}

	static function countEvents(events:Array<ModelStreamRuntimeEvent>, kind:ModelStreamRuntimeEventKind):Int {
		var count = 0;
		for (event in events) if (event.kind == kind) count = count + 1;
		return count;
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}

	static function noneIfEmpty(value:String):String {
		return value == null || value.length == 0 ? "none" : value;
	}
}
