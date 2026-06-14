package codexhx.runtime.model.stream;

import codexhx.runtime.model.request.ModelRequestEnvelopePolicy;

class ModelStreamRoutePolicy {
	public static function buildCases(requests:Array<ModelStreamRouteRequest>):ModelStreamRouteReport {
		final outcomes:Array<ModelStreamRouteOutcome> = [];
		for (request in requests) outcomes.push(build(request));
		return new ModelStreamRouteReport(outcomes);
	}

	public static function build(request:ModelStreamRouteRequest):ModelStreamRouteOutcome {
		final envelope = ModelRequestEnvelopePolicy.build(request.envelopeRequest);
		if (envelope == null || !envelope.ok) {
			return ModelStreamRouteOutcome.denied(
				request,
				envelope,
				"model_request_envelope_denied",
				envelope == null ? "missing model request envelope" : envelope.errorMessage,
				"model_stream_route->model_request_envelope:error"
			);
		}
		var itemsAdded = 0;
		var totalTokens = 0;
		var lastModelRequestId = request.upstreamRequestId;
		var lastModelResponseId = "";
		final sequence:Array<String> = ["model_stream_route", "envelope:ok"];
		for (event in request.events) {
			sequence.push(event.kind);
			if (event.kind == ModelStreamFixtureEventKind.OutputItemDone) {
				itemsAdded = itemsAdded + 1;
			} else if (event.kind == ModelStreamFixtureEventKind.Completed) {
				lastModelResponseId = event.responseId;
				totalTokens = event.totalTokens;
				return ModelStreamRouteOutcome.mapped(
					request,
					envelope,
					lastModelRequestId,
					lastModelResponseId,
					true,
					false,
					false,
					event.endTurn,
					itemsAdded,
					totalTokens,
					false,
					"",
					sequence.join("->")
				);
			} else if (event.kind == ModelStreamFixtureEventKind.ProviderError) {
				if (event.upstreamRequestId.length > 0) lastModelRequestId = event.upstreamRequestId;
				return ModelStreamRouteOutcome.mapped(
					request,
					envelope,
					lastModelRequestId,
					lastModelResponseId,
					false,
					true,
					false,
					false,
					itemsAdded,
					totalTokens,
					false,
					event.errorCode + ":" + event.errorMessage,
					sequence.join("->")
				);
			} else if (event.kind == ModelStreamFixtureEventKind.ConsumerDropped) {
				return ModelStreamRouteOutcome.mapped(
					request,
					envelope,
					lastModelRequestId,
					lastModelResponseId,
					false,
					false,
					true,
					false,
					itemsAdded,
					totalTokens,
					false,
					"response stream dropped before provider terminal event",
					sequence.join("->")
				);
			} else if (event.kind == ModelStreamFixtureEventKind.StreamClosed) {
				return ModelStreamRouteOutcome.mapped(
					request,
					envelope,
					lastModelRequestId,
					lastModelResponseId,
					false,
					true,
					false,
					false,
					itemsAdded,
					totalTokens,
					false,
					"stream closed before response.completed",
					sequence.join("->")
				);
			}
		}
		sequence.push("implicit_stream_closed");
		return ModelStreamRouteOutcome.mapped(
			request,
			envelope,
			lastModelRequestId,
			lastModelResponseId,
			false,
			true,
			false,
			false,
			itemsAdded,
			totalTokens,
			false,
			"stream closed before response.completed",
			sequence.join("->")
		);
	}
}
