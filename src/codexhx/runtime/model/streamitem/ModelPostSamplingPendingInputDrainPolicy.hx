package codexhx.runtime.model.streamitem;

class ModelPostSamplingPendingInputDrainPolicy {
	public static function drain(request:ModelPostSamplingPendingInputDrainRequest):ModelPostSamplingPendingInputDrainOutcome {
		if (request == null) return failure("", "missing post-sampling pending input drain request");
		final integration = request.integrationOutcome;
		if (integration == null || !integration.ok) return failure(request.requestId, "pending input drain requires an integrated sampling result");

		final canDrain = canDrain(integration);
		if (!canDrain) {
			return skipped(request, skipKind(integration), false, false, false, "");
		}

		final ordered = orderedItems(request);
		final drainedCount = ordered.length;
		final drainKind = drainedCount == 0 ? ModelPostSamplingPendingInputDrainKind.SkippedNoPending : ModelPostSamplingPendingInputDrainKind.Drained;
		return new ModelPostSamplingPendingInputDrainOutcome(
			true,
			"post_sampling_pending_input_drain_modeled",
			request.requestId,
			integration.requestId,
			drainKind,
			true,
			request.acceptsMailboxDelivery,
			request.activeTurnItems.length,
			request.acceptsMailboxDelivery ? request.mailboxItems.length : 0,
			drainedCount,
			countKind(ordered, ModelSamplingInputItemKind.PendingUserInput),
			drainedCount - countKind(ordered, ModelSamplingInputItemKind.PendingUserInput),
			mailboxAfterActiveTurn(ordered),
			true,
			true,
			integration.liveNetworkAttempted,
			integration.realFilesystemMutated,
			integration.toolExecutedOutsideFixture,
			orderedSummary(ordered),
			""
		);
	}

	static function canDrain(integration:ModelSamplingResultIntegrationOutcome):Bool {
		if (!integration.samplingOutcomeReturned) return false;
		if (!integration.pendingInputDrainEnabled) return false;
		if (integration.bypassedForCancellation || integration.bypassedForError) return false;
		if (integration.breakTurnLoop) return false;
		if (integration.decisionKind == ModelSamplingResultIntegrationDecisionKind.AutoCompact) {
			return integration.canDrainPendingInputAfterAutoCompact;
		}
		return true;
	}

	static function skipKind(integration:ModelSamplingResultIntegrationOutcome):ModelPostSamplingPendingInputDrainKind {
		if (!integration.samplingOutcomeReturned || integration.bypassedForCancellation || integration.bypassedForError) {
			return ModelPostSamplingPendingInputDrainKind.Bypassed;
		}
		if (integration.breakTurnLoop) return ModelPostSamplingPendingInputDrainKind.SkippedTerminal;
		if (integration.decisionKind == ModelSamplingResultIntegrationDecisionKind.AutoCompact) return ModelPostSamplingPendingInputDrainKind.SkippedAutoCompact;
		return ModelPostSamplingPendingInputDrainKind.Bypassed;
	}

	static function skipped(
		request:ModelPostSamplingPendingInputDrainRequest,
		drainKind:ModelPostSamplingPendingInputDrainKind,
		hookRecordingAttempted:Bool,
		promptAssemblyAfterHooks:Bool,
		canDrainPendingInput:Bool,
		errorMessage:String
	):ModelPostSamplingPendingInputDrainOutcome {
		final integration = request.integrationOutcome;
		return new ModelPostSamplingPendingInputDrainOutcome(
			true,
			"post_sampling_pending_input_drain_modeled",
			request.requestId,
			integration.requestId,
			drainKind,
			canDrainPendingInput,
			request.acceptsMailboxDelivery,
			request.activeTurnItems.length,
			request.acceptsMailboxDelivery ? request.mailboxItems.length : 0,
			0,
			0,
			0,
			true,
			hookRecordingAttempted,
			promptAssemblyAfterHooks,
			integration.liveNetworkAttempted,
			integration.realFilesystemMutated,
			integration.toolExecutedOutsideFixture,
			"",
			errorMessage
		);
	}

	static function orderedItems(request:ModelPostSamplingPendingInputDrainRequest):Array<ModelPostSamplingPendingInputDrainItem> {
		final out = request.activeTurnItems.copy();
		if (request.acceptsMailboxDelivery) {
			for (item in request.mailboxItems) out.push(item);
		}
		return out;
	}

	static function countKind(items:Array<ModelPostSamplingPendingInputDrainItem>, kind:ModelSamplingInputItemKind):Int {
		var count = 0;
		for (item in items) if (item.inputKind == kind) count = count + 1;
		return count;
	}

	static function mailboxAfterActiveTurn(items:Array<ModelPostSamplingPendingInputDrainItem>):Bool {
		var seenMailbox = false;
		for (item in items) {
			if (item.sourceKind == ModelPostSamplingPendingInputSourceKind.Mailbox) {
				seenMailbox = true;
			} else if (seenMailbox) {
				return false;
			}
		}
		return true;
	}

	static function orderedSummary(items:Array<ModelPostSamplingPendingInputDrainItem>):String {
		final parts:Array<String> = [];
		for (item in items) parts.push(item.summary());
		return parts.join("|");
	}

	static function failure(requestId:String, errorMessage:String):ModelPostSamplingPendingInputDrainOutcome {
		return new ModelPostSamplingPendingInputDrainOutcome(
			false,
			"post_sampling_pending_input_drain_failed",
			requestId,
			"",
			ModelPostSamplingPendingInputDrainKind.Bypassed,
			false,
			false,
			0,
			0,
			0,
			0,
			0,
			true,
			false,
			false,
			false,
			false,
			false,
			"",
			errorMessage
		);
	}
}
