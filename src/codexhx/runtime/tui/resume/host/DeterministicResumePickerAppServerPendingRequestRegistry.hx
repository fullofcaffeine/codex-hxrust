package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerAppServerPendingRequestRegistry {
	final records:Array<ResumePickerAppServerPendingRequestRegistryRecord>;
	final log:Array<String>;
	var nextOrderIndex:Int;

	public function new() {
		this.records = [];
		this.log = [];
		this.nextOrderIndex = 1;
	}

	public function register(requestId:String, detail:String):ResumePickerAppServerPendingRequestRegistryEvent {
		final before = records.length;
		if (requestId.length == 0)
			return record(event(ResumePickerAppServerPendingRequestRegistryEventKind.InvalidRequestRefused, requestId, detail, before, before, 0,
				"missing_request_id"));
		if (indexOfRequest(requestId) >= 0)
			return record(event(ResumePickerAppServerPendingRequestRegistryEventKind.DuplicateRejected, requestId, detail, before, before, orderOf(requestId),
				"duplicate_request_id"));

		final order = nextOrderIndex;
		nextOrderIndex = nextOrderIndex + 1;
		records.push(new ResumePickerAppServerPendingRequestRegistryRecord({
			requestId: requestId,
			detail: detail,
			orderIndex: order
		}));
		return record(event(ResumePickerAppServerPendingRequestRegistryEventKind.Registered, requestId, detail, before, records.length, order, ""));
	}

	public function resolve(requestId:String):ResumePickerAppServerPendingRequestRegistryEvent {
		return remove(requestId, ResumePickerAppServerPendingRequestRegistryEventKind.ResolvedRemoved, "resolved_server_request");
	}

	public function reject(requestId:String):ResumePickerAppServerPendingRequestRegistryEvent {
		return remove(requestId, ResumePickerAppServerPendingRequestRegistryEventKind.RejectedRemoved, "rejected_server_request");
	}

	public function cleanupAbandoned(reason:String):Array<ResumePickerAppServerPendingRequestRegistryEvent> {
		final out:Array<ResumePickerAppServerPendingRequestRegistryEvent> = [];
		while (records.length > 0) {
			final before = records.length;
			final removed = records[0];
			records.splice(0, 1);
			out.push(record(event(ResumePickerAppServerPendingRequestRegistryEventKind.AbandonedCleaned, removed.requestId, removed.detail, before,
				records.length, removed.orderIndex, reason)));
		}
		return out;
	}

	public function contains(requestId:String):Bool {
		return indexOfRequest(requestId) >= 0;
	}

	public function count():Int {
		return records.length;
	}

	public function summaries():Array<String> {
		return log.copy();
	}

	public function pendingSummaries():Array<String> {
		final out:Array<String> = [];
		for (record in records)
			out.push(record.summary());
		return out;
	}

	function remove(requestId:String, kind:ResumePickerAppServerPendingRequestRegistryEventKind,
			reason:String):ResumePickerAppServerPendingRequestRegistryEvent {
		final before = records.length;
		final index = indexOfRequest(requestId);
		if (index < 0)
			return record(event(ResumePickerAppServerPendingRequestRegistryEventKind.LateResponseRefused, requestId, "", before, before, 0,
				"request_not_pending"));

		final removed = records.splice(index, 1)[0];
		return record(event(kind, requestId, removed.detail, before, records.length, removed.orderIndex, reason));
	}

	function record(value:ResumePickerAppServerPendingRequestRegistryEvent):ResumePickerAppServerPendingRequestRegistryEvent {
		log.push(value.summary());
		return value;
	}

	function event(kind:ResumePickerAppServerPendingRequestRegistryEventKind, requestId:String, detail:String, pendingBefore:Int, pendingAfter:Int,
			orderIndex:Int, reason:String):ResumePickerAppServerPendingRequestRegistryEvent {
		return new ResumePickerAppServerPendingRequestRegistryEvent({
			kind: kind,
			requestId: requestId,
			detail: detail,
			pendingBefore: pendingBefore,
			pendingAfter: pendingAfter,
			orderIndex: orderIndex,
			reason: reason
		});
	}

	function indexOfRequest(requestId:String):Int {
		var i = 0;
		while (i < records.length) {
			if (records[i].requestId == requestId)
				return i;
			i = i + 1;
		}
		return -1;
	}

	function orderOf(requestId:String):Int {
		final index = indexOfRequest(requestId);
		return index < 0 ? 0 : records[index].orderIndex;
	}
}
