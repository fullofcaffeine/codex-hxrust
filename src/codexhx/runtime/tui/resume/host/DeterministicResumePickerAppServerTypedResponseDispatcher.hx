package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerAppServerTypedResponseDispatcher {
	final seenRequestIds:Array<String>;
	final outcomes:Array<ResumePickerAppServerTypedResponseDispatchOutcome>;
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.seenRequestIds = [];
		this.outcomes = [];
		this.log = [];
		this.nextSequence = 1;
	}

	public function dispatch(envelope:ResumePickerAppServerTypedResponseEnvelope, sourceOrder:Int):ResumePickerAppServerTypedResponseDispatchOutcome {
		final outcome = outcomeFor(envelope, sourceOrder);
		outcomes.push(outcome);
		log.push("dispatch:" + outcome.summary());
		if (shouldMarkSeen(outcome))
			seenRequestIds.push(outcome.requestId);
		nextSequence = nextSequence + 1;
		return outcome;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function outcomeSummaries():Array<String> {
		final out:Array<String> = [];
		for (outcome in outcomes)
			out.push(outcome.summary());
		return out;
	}

	function outcomeFor(envelope:ResumePickerAppServerTypedResponseEnvelope, sourceOrder:Int):ResumePickerAppServerTypedResponseDispatchOutcome {
		if (envelope == null)
			return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.SerializationRefused, ResumePickerAppServerPendingRequestClassKind.Unknown,
				ResumePickerAppServerTypedResponsePayloadKind.JsonRpcError, "", "", sourceOrder, false, false, false, "missing_envelope");

		if (envelope.requestId.length > 0 && contains(seenRequestIds, envelope.requestId))
			return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.LateDuplicateRefused, envelope.requestClass, envelope.payloadKind,
				envelope.requestId, envelope.correlationKey, sourceOrder, false, false, false, "request_already_dispatched");

		if (envelope.kind == ResumePickerAppServerTypedResponseEnvelopeKind.ResolvePayload)
			return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.ResolveSent, envelope.requestClass, envelope.payloadKind, envelope.requestId,
				envelope.correlationKey, sourceOrder, true, true, true, "supported_response_refresh_scheduled");

		if (envelope.kind == ResumePickerAppServerTypedResponseEnvelopeKind.RejectError)
			return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.RejectSent, envelope.requestClass, envelope.payloadKind, envelope.requestId,
				envelope.correlationKey, sourceOrder, false, false, false, "rejected_without_refresh");

		if (envelope.kind == ResumePickerAppServerTypedResponseEnvelopeKind.MissingPendingNoop
			|| envelope.localOnly
			|| !envelope.sendIntentRecorded)
			return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.LocalNoop, envelope.requestClass, envelope.payloadKind, envelope.requestId,
				envelope.correlationKey, sourceOrder, false, false, false, "local_noop_without_refresh");

		return outcome(ResumePickerAppServerTypedResponseDispatchOutcomeKind.SerializationRefused, envelope.requestClass, envelope.payloadKind,
			envelope.requestId, envelope.correlationKey, sourceOrder, false, false, false, "unsupported_dispatch_envelope");
	}

	function outcome(kind:ResumePickerAppServerTypedResponseDispatchOutcomeKind, requestClass:ResumePickerAppServerPendingRequestClassKind,
			payloadKind:ResumePickerAppServerTypedResponsePayloadKind, requestId:String, correlationKey:String, sourceOrder:Int, refreshScheduled:Bool,
			pendingReplayRefresh:Bool, sideParentStatusUpdated:Bool, reason:String):ResumePickerAppServerTypedResponseDispatchOutcome {
		return new ResumePickerAppServerTypedResponseDispatchOutcome({
			kind: kind,
			requestClass: requestClass,
			payloadKind: payloadKind,
			requestId: requestId,
			correlationKey: correlationKey,
			sequence: nextSequence,
			sourceOrder: sourceOrder,
			refreshScheduled: refreshScheduled,
			pendingReplayRefresh: pendingReplayRefresh,
			sideParentStatusUpdated: sideParentStatusUpdated,
			liveTransportAttempted: false,
			liveTransportSuppressed: true,
			reason: reason
		});
	}

	static function shouldMarkSeen(outcome:ResumePickerAppServerTypedResponseDispatchOutcome):Bool {
		return outcome.requestId.length > 0
			&& (outcome.kind == ResumePickerAppServerTypedResponseDispatchOutcomeKind.ResolveSent
				|| outcome.kind == ResumePickerAppServerTypedResponseDispatchOutcomeKind.RejectSent);
	}

	static function contains(values:Array<String>, value:String):Bool {
		for (entry in values)
			if (entry == value)
				return true;
		return false;
	}
}
