package codexhx.runtime.model.streamitem;

class ModelSamplingInputAssemblyPolicy {
	public static function assemble(request:ModelSamplingInputAssemblyRequest):ModelSamplingInputAssemblyOutcome {
		if (request == null) return failure("", "missing sampling input assembly request");
		if (request.responseInputOutcome == null || !request.responseInputOutcome.ok) {
			return failure(request.requestId, "sampling input assembly requires response input outcome");
		}
		if (request.continuationOutcome == null || !request.continuationOutcome.ok) {
			return failure(request.requestId, "sampling input assembly requires continuation outcome");
		}
		if (!request.continuationOutcome.nextSamplingRequestRequired) {
			return failure(request.requestId, "sampling input assembly requires a planned next request");
		}

		final items:Array<ModelSamplingInputItem> = [];
		if (request.continuationOutcome.responseInputCarried) {
			items.push(new ModelSamplingInputItem(
				ModelSamplingInputItemKind.ToolResponseOutput,
				request.responseInputOutcome.responseOrderIndex,
				request.responseInputOutcome.callId,
				request.responseInputOutcome.responseKind,
				request.responseInputOutcome.outputText,
				false,
				request.responseInputOutcome.conversationItemRecorded
			));
		}

		if (request.continuationOutcome.pendingInputDrainedBeforeNextRequest) {
			for (item in request.pendingInputItems) {
				items.push(item);
			}
		}

		final ordered = orderItems(items);
		final responseCount = countKind(ordered, ModelSamplingInputItemKind.ToolResponseOutput);
		final pendingCount = ordered.length - responseCount;
		final firstKind = ordered.length == 0 ? ModelSamplingInputItemKind.PendingResponseItem : ordered[0].kind;
		final lastKind = ordered.length == 0 ? ModelSamplingInputItemKind.PendingResponseItem : ordered[ordered.length - 1].kind;
		return new ModelSamplingInputAssemblyOutcome(
			true,
			"sampling_input_assembled",
			request.requestId,
			request.continuationOutcome.continuationKind,
			request.continuationOutcome.nextSamplingRequestIndex,
			request.previousPromptItemCount,
			ordered.length,
			request.previousPromptItemCount + ordered.length,
			responseCount,
			pendingCount,
			request.continuationOutcome.pendingInputDrainedBeforeNextRequest,
			true,
			true,
			request.modelSupportsImages,
			firstKind,
			lastKind,
			orderedSummary(ordered),
			false,
			false,
			false,
			""
		);
	}

	static function orderItems(items:Array<ModelSamplingInputItem>):Array<ModelSamplingInputItem> {
		final out = items.copy();
		out.sort(function(a, b) {
			if (a.orderIndex == b.orderIndex) return 0;
			return a.orderIndex < b.orderIndex ? -1 : 1;
		});
		return out;
	}

	static function countKind(items:Array<ModelSamplingInputItem>, kind:ModelSamplingInputItemKind):Int {
		var count = 0;
		for (item in items) {
			if (item.kind == kind) count = count + 1;
		}
		return count;
	}

	static function orderedSummary(items:Array<ModelSamplingInputItem>):String {
		final parts:Array<String> = [];
		for (item in items) {
			parts.push(item.summary());
		}
		return parts.join("|");
	}

	static function failure(requestId:String, errorMessage:String):ModelSamplingInputAssemblyOutcome {
		return new ModelSamplingInputAssemblyOutcome(
			false,
			"sampling_input_assembly_failed",
			requestId,
			ModelSamplingContinuationKind.None,
			0,
			0,
			0,
			0,
			0,
			0,
			false,
			false,
			false,
			false,
			ModelSamplingInputItemKind.PendingResponseItem,
			ModelSamplingInputItemKind.PendingResponseItem,
			"",
			false,
			false,
			false,
			errorMessage
		);
	}
}
