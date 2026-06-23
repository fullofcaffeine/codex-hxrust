package codexhx.runtime.tui.resume.host;

class Dispatcher {
	final seenRequestIds:Array<String>;
	final outcomes:Array<DispatchOutcome>;
	final log:Array<String>;
	var nextSequence:Int;

	public function new() {
		this.seenRequestIds = [];
		this.outcomes = [];
		this.log = [];
		this.nextSequence = 1;
	}

	public function dispatch(envelope:Envelope, sourceOrder:Int):DispatchOutcome {
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

	function outcomeFor(envelope:Envelope, sourceOrder:Int):DispatchOutcome {
		if (envelope == null)
			return outcome(DispatchOutcomeKind.SerializationRefused, PendingRequestClassKind.Unknown, PayloadKind.JsonRpcError, "", "", sourceOrder, false,
				false, false, "missing_envelope");

		if (envelope.requestId.length > 0 && contains(seenRequestIds, envelope.requestId))
			return outcome(DispatchOutcomeKind.LateDuplicateRefused, envelope.requestClass, envelope.payloadKind, envelope.requestId, envelope.correlationKey,
				sourceOrder, false, false, false, "request_already_dispatched");

		if (envelope.kind == EnvelopeKind.ResolvePayload)
			return outcome(DispatchOutcomeKind.ResolveSent, envelope.requestClass, envelope.payloadKind, envelope.requestId, envelope.correlationKey,
				sourceOrder, true, true, true, "supported_response_refresh_scheduled");

		if (envelope.kind == EnvelopeKind.RejectError)
			return outcome(DispatchOutcomeKind.RejectSent, envelope.requestClass, envelope.payloadKind, envelope.requestId, envelope.correlationKey,
				sourceOrder, false, false, false, "rejected_without_refresh");

		if (envelope.kind == EnvelopeKind.MissingPendingNoop || envelope.localOnly || !envelope.sendIntentRecorded)
			return outcome(DispatchOutcomeKind.LocalNoop, envelope.requestClass, envelope.payloadKind, envelope.requestId, envelope.correlationKey,
				sourceOrder, false, false, false, "local_noop_without_refresh");

		return outcome(DispatchOutcomeKind.SerializationRefused, envelope.requestClass, envelope.payloadKind, envelope.requestId, envelope.correlationKey,
			sourceOrder, false, false, false, "unsupported_dispatch_envelope");
	}

	function outcome(kind:DispatchOutcomeKind, requestClass:PendingRequestClassKind, payloadKind:PayloadKind, requestId:String, correlationKey:String,
			sourceOrder:Int, refreshScheduled:Bool, pendingReplayRefresh:Bool, sideParentStatusUpdated:Bool, reason:String):DispatchOutcome {
		return new DispatchOutcome({
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

	static function shouldMarkSeen(outcome:DispatchOutcome):Bool {
		return outcome.requestId.length > 0
			&& (outcome.kind == DispatchOutcomeKind.ResolveSent || outcome.kind == DispatchOutcomeKind.RejectSent);
	}

	static function contains(values:Array<String>, value:String):Bool {
		for (entry in values)
			if (entry == value)
				return true;
		return false;
	}
}
