package codexhx.runtime.model.streamitem;

import codexhx.runtime.model.stream.ModelStreamRouteOutcome;
import codexhx.runtime.model.stream.ModelStreamRoutePolicy;

class ModelStreamItemReducerPolicy {
	public static function buildCases(requests:Array<ModelStreamItemReducerRequest>):ModelStreamItemReducerReport {
		final outcomes:Array<ModelStreamItemReducerOutcome> = [];
		for (request in requests)
			outcomes.push(build(request));
		return new ModelStreamItemReducerReport(outcomes);
	}

	public static function build(request:ModelStreamItemReducerRequest):ModelStreamItemReducerOutcome {
		final route = ModelStreamRoutePolicy.build(request.routeRequest);
		if (route == null || !route.ok) {
			return ModelStreamItemReducerOutcome.denied(request, route, route == null ? "missing stream route" : route.errorMessage,
				"model_stream_item_reducer->stream_route:error");
		}

		final runtimeEvents:Array<ModelStreamRuntimeEvent> = [];
		final sequence:Array<String> = ["model_stream_item_reducer", "stream_route:ok"];
		var activeItem:ModelStreamOutputItem = null;
		var activeToolCall:ModelStreamActiveToolCall = null;
		var activeDiffConsumer:ModelToolArgumentDiffConsumerState = null;
		var activeStreaming = false;
		var startedCount = 0;
		var completedCount = 0;
		var assistantDeltaCount = 0;
		var reasoningDeltaCount = 0;
		var rawReasoningDeltaCount = 0;
		var toolInputDeltaCount = 0;
		var toolInputDeltaIgnoredCount = 0;
		var toolArgumentDiffEventCount = 0;
		var toolCallCount = 0;
		var needsFollowUp = false;
		var lastAgentMessage = "";
		var terminalResponseId = "";
		var totalTokens = 0;

		for (event in request.events) {
			sequence.push(event.kind);
			if (event.kind == ModelStreamItemEventKind.OutputItemAdded) {
				final item = event.item;
				if (isNonToolItem(item)) {
					activeItem = item;
					activeStreaming = true;
					runtimeEvents.push(itemStarted(item));
					startedCount = startedCount + 1;
					activeToolCall = null;
					activeDiffConsumer = null;
				} else if (item != null && item.kind == ModelStreamOutputItemKind.CustomToolCall) {
					activeToolCall = ModelStreamActiveToolCall.fromItem(item);
					activeDiffConsumer = ModelToolArgumentDiffConsumerState.create(item.toolName, item.callId);
				} else if (item != null && item.kind == ModelStreamOutputItemKind.FunctionCall) {
					activeToolCall = null;
					activeDiffConsumer = null;
				}
			} else if (event.kind == ModelStreamItemEventKind.OutputTextDelta) {
				if (activeItem == null || !activeStreaming) {
					return ModelStreamItemReducerOutcome.failed(request, route, runtimeEvents, "OutputTextDelta without active item", sequence.join("->"));
				}
				runtimeEvents.push(new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.AgentMessageContentDelta, activeItem.kind, activeItem.itemId, "",
					"", event.delta, "", 0));
				assistantDeltaCount = assistantDeltaCount + 1;
			} else if (event.kind == ModelStreamItemEventKind.ReasoningSummaryDelta) {
				if (activeItem == null || !activeStreaming) {
					return ModelStreamItemReducerOutcome.failed(request, route, runtimeEvents, "ReasoningSummaryDelta without active item",
						sequence.join("->"));
				}
				runtimeEvents.push(new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ReasoningContentDelta, activeItem.kind, activeItem.itemId, "", "",
					event.delta, "", event.summaryIndex));
				reasoningDeltaCount = reasoningDeltaCount + 1;
			} else if (event.kind == ModelStreamItemEventKind.ReasoningContentDelta) {
				if (activeItem == null || !activeStreaming) {
					return ModelStreamItemReducerOutcome.failed(request, route, runtimeEvents, "ReasoningRawContentDelta without active item",
						sequence.join("->"));
				}
				if (request.showRawReasoning) {
					runtimeEvents.push(new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ReasoningRawContentDelta, activeItem.kind, activeItem.itemId,
						"", "", event.delta, "", event.contentIndex));
					rawReasoningDeltaCount = rawReasoningDeltaCount + 1;
				}
			} else if (event.kind == ModelStreamItemEventKind.ToolCallInputDelta) {
				if (activeToolCall == null) {
					final ignored = new ModelStreamToolInputDelta(event.callId, event.itemId, event.delta, "",
						ModelStreamToolInputDeltaStatus.IgnoredNoActiveToolCall, 1);
					runtimeEvents.push(toolInputDeltaEvent(ModelStreamRuntimeEventKind.ToolCallInputDeltaIgnored, ModelStreamOutputItemKind.Unknown, "", "",
						"", ignored));
					toolInputDeltaIgnoredCount = toolInputDeltaIgnoredCount + 1;
				} else if (!activeToolCall.accepts(event.callId)) {
					final ignored = activeToolCall.ignore(event.callId, event.delta, ModelStreamToolInputDeltaStatus.IgnoredCallMismatch);
					runtimeEvents.push(toolInputDeltaEvent(ModelStreamRuntimeEventKind.ToolCallInputDeltaIgnored, activeToolCall.itemKind,
						activeToolCall.itemId, activeToolCall.callId, activeToolCall.displayName(), ignored));
					toolInputDeltaIgnoredCount = toolInputDeltaIgnoredCount + 1;
				} else {
					final accepted = activeToolCall.accept(event.delta);
					runtimeEvents.push(toolInputDeltaEvent(ModelStreamRuntimeEventKind.ToolCallInputDelta, activeToolCall.itemKind, activeToolCall.itemId,
						activeToolCall.callId, activeToolCall.displayName(), accepted));
					toolInputDeltaCount = toolInputDeltaCount + 1;
					if (activeDiffConsumer != null) {
						final diffEvent = activeDiffConsumer.consume(accepted);
						if (activeDiffConsumer.hasError()) {
							return ModelStreamItemReducerOutcome.failed(request, route, runtimeEvents,
								"ToolArgumentDiffConsumer error: " + activeDiffConsumer.errorSummary(), sequence.join("->"));
						}
						if (diffEvent != null) {
							runtimeEvents.push(toolArgumentDiffEvent(diffEvent));
							toolArgumentDiffEventCount = toolArgumentDiffEventCount + 1;
						}
					}
				}
			} else if (event.kind == ModelStreamItemEventKind.OutputItemDone) {
				final item = event.item;
				if (isToolCall(item)) {
					if (activeDiffConsumer != null && activeToolCall != null && item.callId == activeToolCall.callId) {
						final finishedDiffEvent = activeDiffConsumer.finish();
						if (activeDiffConsumer.hasError()) {
							return ModelStreamItemReducerOutcome.failed(request, route, runtimeEvents,
								"ToolArgumentDiffConsumer error: " + activeDiffConsumer.errorSummary(), sequence.join("->"));
						}
						if (finishedDiffEvent != null) {
							runtimeEvents.push(toolArgumentDiffEvent(finishedDiffEvent));
							toolArgumentDiffEventCount = toolArgumentDiffEventCount + 1;
						}
					}
					final completedToolCall = toolCallWithStreamedInput(item, activeToolCall);
					runtimeEvents.push(toolCallQueued(completedToolCall));
					toolCallCount = toolCallCount + 1;
					needsFollowUp = true;
					if (activeToolCall != null && activeToolCall.callId == item.callId) {
						activeToolCall = null;
						activeDiffConsumer = null;
					}
					activeItem = null;
					activeStreaming = false;
				} else if (isNonToolItem(item)) {
					if (activeItem == null || activeItem.itemId != item.itemId) {
						runtimeEvents.push(itemStarted(item));
						startedCount = startedCount + 1;
					}
					final completed = finalizedItem(item, request.planMode);
					runtimeEvents.push(itemCompleted(completed));
					completedCount = completedCount + 1;
					if (completed.kind == ModelStreamOutputItemKind.AssistantMessage && completed.text.length > 0) {
						lastAgentMessage = completed.text;
					}
					activeItem = null;
					activeStreaming = false;
				}
			} else if (event.kind == ModelStreamItemEventKind.Completed) {
				terminalResponseId = event.responseId;
				totalTokens = event.totalTokens;
				runtimeEvents.push(new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.StreamCompleted, ModelStreamOutputItemKind.Unknown, "", "", "", "",
					event.endTurn ? "end_turn" : "follow_up", 0));
				if (!event.endTurn)
					needsFollowUp = true;
			}
		}

		return ModelStreamItemReducerOutcome.reduced(request, route, runtimeEvents, startedCount, completedCount, assistantDeltaCount, reasoningDeltaCount,
			rawReasoningDeltaCount, toolInputDeltaCount, toolInputDeltaIgnoredCount, toolArgumentDiffEventCount, toolCallCount, needsFollowUp,
			lastAgentMessage, terminalResponseId, totalTokens, sequence.join("->"));
	}

	static function isNonToolItem(item:ModelStreamOutputItem):Bool {
		return item != null
			&& (item.kind == ModelStreamOutputItemKind.AssistantMessage
				|| item.kind == ModelStreamOutputItemKind.Reasoning
				|| item.kind == ModelStreamOutputItemKind.WebSearchCall
				|| item.kind == ModelStreamOutputItemKind.ImageGenerationCall);
	}

	static function isToolCall(item:ModelStreamOutputItem):Bool {
		return item != null
			&& (item.kind == ModelStreamOutputItemKind.FunctionCall || item.kind == ModelStreamOutputItemKind.CustomToolCall);
	}

	static function finalizedItem(item:ModelStreamOutputItem, planMode:Bool):ModelStreamOutputItem {
		if (item.kind != ModelStreamOutputItemKind.AssistantMessage)
			return item;
		return new ModelStreamOutputItem(item.kind, item.itemId, item.role, stripHiddenAssistantMarkup(item.text, planMode), item.phase, item.summary,
			item.rawContent, item.callId, item.toolName, item.namespace, item.arguments, item.customInput, item.status);
	}

	static function toolCallWithStreamedInput(item:ModelStreamOutputItem, activeToolCall:ModelStreamActiveToolCall):ModelStreamOutputItem {
		if (item == null || activeToolCall == null || item.callId != activeToolCall.callId)
			return item;
		final streamedInput = activeToolCall.inputSnapshot();
		if (streamedInput.length == 0)
			return item;
		if (item.kind == ModelStreamOutputItemKind.CustomToolCall && item.customInput.length == 0) {
			return new ModelStreamOutputItem(item.kind, item.itemId, item.role, item.text, item.phase, item.summary, item.rawContent, item.callId,
				item.toolName, item.namespace, item.arguments, streamedInput, item.status);
		}
		if (item.kind == ModelStreamOutputItemKind.FunctionCall && item.arguments.length == 0) {
			return new ModelStreamOutputItem(item.kind, item.itemId, item.role, item.text, item.phase, item.summary, item.rawContent, item.callId,
				item.toolName, item.namespace, streamedInput, item.customInput, item.status);
		}
		return item;
	}

	static function itemStarted(item:ModelStreamOutputItem):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ItemStarted, item.kind, item.itemId, item.callId, toolDisplayName(item), "", item.text,
			0);
	}

	static function itemCompleted(item:ModelStreamOutputItem):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ItemCompleted, item.kind, item.itemId, item.callId, toolDisplayName(item), "",
			item.kind == ModelStreamOutputItemKind.Reasoning ? item.summary.join("|") : item.text, 0);
	}

	static function toolCallQueued(item:ModelStreamOutputItem):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ToolCallQueued, item.kind, item.itemId, item.callId, toolDisplayName(item), "",
			item.kind == ModelStreamOutputItemKind.CustomToolCall ? item.customInput : item.arguments, 0);
	}

	static function toolInputDeltaEvent(kind:ModelStreamRuntimeEventKind, itemKind:ModelStreamOutputItemKind, itemId:String, callId:String, toolName:String,
			inputDelta:ModelStreamToolInputDelta):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(kind, itemKind, itemId, callId, toolName, inputDelta.delta, inputDelta.summary(), inputDelta.index);
	}

	static function toolArgumentDiffEvent(diffEvent:ModelToolArgumentDiffConsumerEvent):ModelStreamRuntimeEvent {
		return new ModelStreamRuntimeEvent(ModelStreamRuntimeEventKind.ToolArgumentDiffUpdated, ModelStreamOutputItemKind.CustomToolCall, "",
			diffEvent.callId, diffEvent.kind, "", diffEvent.summary(), diffEvent.index);
	}

	static function toolDisplayName(item:ModelStreamOutputItem):String {
		if (item == null)
			return "";
		if (item.namespace.length > 0)
			return item.namespace + "." + item.toolName;
		return item.toolName;
	}

	static function stripHiddenAssistantMarkup(text:String, planMode:Bool):String {
		final withoutCitations = stripBlock(text, "<oai-mem-citation>", "</oai-mem-citation>");
		if (!planMode)
			return withoutCitations;
		return stripBlock(withoutCitations, "<proposed_plan>", "</proposed_plan>");
	}

	static function stripBlock(text:String, startTag:String, endTag:String):String {
		var remaining = text;
		var out = "";
		var start = remaining.indexOf(startTag);
		while (start >= 0) {
			out = out + remaining.substr(0, start);
			final afterStart = start + startTag.length;
			final end = remaining.indexOf(endTag, afterStart);
			if (end < 0)
				return out;
			remaining = remaining.substr(end + endTag.length);
			start = remaining.indexOf(startTag);
		}
		return out + remaining;
	}
}
