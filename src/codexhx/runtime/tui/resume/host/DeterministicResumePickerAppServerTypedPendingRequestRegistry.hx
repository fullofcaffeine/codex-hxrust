package codexhx.runtime.tui.resume.host;

class DeterministicResumePickerAppServerTypedPendingRequestRegistry {
	final records:Array<ResumePickerAppServerTypedPendingRequestRecord>;
	final log:Array<String>;
	var nextOrderIndex:Int;

	public function new() {
		this.records = [];
		this.log = [];
		this.nextOrderIndex = 1;
	}

	public function register(requestClass:ResumePickerAppServerPendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String,
			serverName:String, mcpRequestId:String, detail:String):ResumePickerAppServerTypedPendingRequestEvent {
		final before = records.length;
		if (!isSupported(requestClass))
			return record(event(ResumePickerAppServerTypedPendingRequestEventKind.UnsupportedRefused, requestClass, requestId, key, turnId, itemId,
				serverName, mcpRequestId, before, before, 0, "unsupported_request_class"));
		final duplicateIndex = duplicateIndex(requestClass, requestId, key, turnId, itemId, serverName, mcpRequestId);
		if (duplicateIndex >= 0)
			return record(event(ResumePickerAppServerTypedPendingRequestEventKind.DuplicateRejected, requestClass, requestId, key, turnId, itemId, serverName,
				mcpRequestId, before, before, records[duplicateIndex].orderIndex, "duplicate_request_key"));

		final order = nextOrderIndex;
		nextOrderIndex = nextOrderIndex + 1;
		records.push(new ResumePickerAppServerTypedPendingRequestRecord({
			requestClass: requestClass,
			requestId: requestId,
			key: key,
			turnId: turnId,
			itemId: itemId,
			serverName: serverName,
			mcpRequestId: mcpRequestId,
			detail: detail,
			orderIndex: order
		}));
		return record(event(ResumePickerAppServerTypedPendingRequestEventKind.Registered, requestClass, requestId, key, turnId, itemId, serverName,
			mcpRequestId, before, records.length, order, ""));
	}

	public function resolveKey(requestClass:ResumePickerAppServerPendingRequestClassKind, key:String):ResumePickerAppServerTypedPendingRequestEvent {
		return remove(indexForClassKey(requestClass, key), ResumePickerAppServerTypedPendingRequestEventKind.ResolvedByKey, requestClass, "", key, "", "", "",
			"", "matched_request_key");
	}

	public function popUserInput(turnId:String):ResumePickerAppServerTypedPendingRequestEvent {
		return remove(indexForUserInputTurn(turnId), ResumePickerAppServerTypedPendingRequestEventKind.UserInputFifoPopped,
			ResumePickerAppServerPendingRequestClassKind.UserInput, "", "", turnId, "", "", "", "matched_turn_fifo");
	}

	public function resolveMcp(serverName:String, mcpRequestId:String):ResumePickerAppServerTypedPendingRequestEvent {
		return remove(indexForMcp(serverName, mcpRequestId), ResumePickerAppServerTypedPendingRequestEventKind.McpMatched,
			ResumePickerAppServerPendingRequestClassKind.McpElicitation, "", "", "", "", serverName, mcpRequestId, "matched_mcp_request");
	}

	public function resolveNotification(requestId:String):ResumePickerAppServerTypedPendingRequestEvent {
		return remove(indexOfRequest(requestId), ResumePickerAppServerTypedPendingRequestEventKind.NotificationRemoved,
			ResumePickerAppServerPendingRequestClassKind.Unknown, requestId, "", "", "", "", "", "server_request_resolved_notification");
	}

	public function replayDecision(requestId:String):ResumePickerAppServerTypedPendingRequestEvent {
		final before = records.length;
		final index = indexOfRequest(requestId);
		if (index >= 0) {
			final value = records[index];
			return record(event(ResumePickerAppServerTypedPendingRequestEventKind.Registered, value.requestClass, value.requestId, value.key, value.turnId,
				value.itemId, value.serverName, value.mcpRequestId, before, before, value.orderIndex, "replay_request_still_pending"));
		}
		return record(event(ResumePickerAppServerTypedPendingRequestEventKind.StaleReplaySkipped, ResumePickerAppServerPendingRequestClassKind.Unknown,
			requestId, "", "", "", "", "", before, before, 0, "request_not_pending"));
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

	function remove(index:Int, kind:ResumePickerAppServerTypedPendingRequestEventKind, fallbackClass:ResumePickerAppServerPendingRequestClassKind,
			fallbackRequestId:String, fallbackKey:String, fallbackTurnId:String, fallbackItemId:String, fallbackServerName:String,
			fallbackMcpRequestId:String, reason:String):ResumePickerAppServerTypedPendingRequestEvent {
		final before = records.length;
		if (index < 0)
			return record(event(ResumePickerAppServerTypedPendingRequestEventKind.MissingPendingRefused, fallbackClass, fallbackRequestId, fallbackKey,
				fallbackTurnId, fallbackItemId, fallbackServerName, fallbackMcpRequestId, before, before, 0, "request_not_pending"));

		final removed = records.splice(index, 1)[0];
		return record(event(kind, removed.requestClass, removed.requestId, removed.key, removed.turnId, removed.itemId, removed.serverName,
			removed.mcpRequestId, before, records.length, removed.orderIndex, reason));
	}

	function duplicateIndex(requestClass:ResumePickerAppServerPendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String,
			serverName:String, mcpRequestId:String):Int {
		var i = 0;
		while (i < records.length) {
			final record = records[i];
			if (record.requestId == requestId)
				return i;
			if (requestClass != ResumePickerAppServerPendingRequestClassKind.UserInput
				&& requestClass != ResumePickerAppServerPendingRequestClassKind.McpElicitation
				&& record.requestClass == requestClass
				&& record.key == key)
				return i;
			if (requestClass == ResumePickerAppServerPendingRequestClassKind.McpElicitation
				&& record.requestClass == requestClass
				&& record.serverName == serverName
				&& record.mcpRequestId == mcpRequestId)
				return i;
			if (requestClass == ResumePickerAppServerPendingRequestClassKind.UserInput
				&& record.requestClass == requestClass
				&& record.turnId == turnId
				&& record.itemId == itemId)
				return i;
			i = i + 1;
		}
		return -1;
	}

	function indexForClassKey(requestClass:ResumePickerAppServerPendingRequestClassKind, key:String):Int {
		var i = 0;
		while (i < records.length) {
			if (records[i].requestClass == requestClass && records[i].key == key)
				return i;
			i = i + 1;
		}
		return -1;
	}

	function indexForUserInputTurn(turnId:String):Int {
		var selected = -1;
		var selectedOrder = 0;
		var i = 0;
		while (i < records.length) {
			final record = records[i];
			if (record.requestClass == ResumePickerAppServerPendingRequestClassKind.UserInput && record.turnId == turnId) {
				if (selected < 0 || record.orderIndex < selectedOrder) {
					selected = i;
					selectedOrder = record.orderIndex;
				}
			}
			i = i + 1;
		}
		return selected;
	}

	function indexForMcp(serverName:String, mcpRequestId:String):Int {
		var i = 0;
		while (i < records.length) {
			final record = records[i];
			if (record.requestClass == ResumePickerAppServerPendingRequestClassKind.McpElicitation
				&& record.serverName == serverName
				&& record.mcpRequestId == mcpRequestId)
				return i;
			i = i + 1;
		}
		return -1;
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

	static function isSupported(kind:ResumePickerAppServerPendingRequestClassKind):Bool {
		return kind == ResumePickerAppServerPendingRequestClassKind.ExecApproval
			|| kind == ResumePickerAppServerPendingRequestClassKind.FileChangeApproval
			|| kind == ResumePickerAppServerPendingRequestClassKind.PermissionsApproval
			|| kind == ResumePickerAppServerPendingRequestClassKind.UserInput
			|| kind == ResumePickerAppServerPendingRequestClassKind.McpElicitation;
	}

	function record(value:ResumePickerAppServerTypedPendingRequestEvent):ResumePickerAppServerTypedPendingRequestEvent {
		log.push(value.summary());
		return value;
	}

	function event(kind:ResumePickerAppServerTypedPendingRequestEventKind, requestClass:ResumePickerAppServerPendingRequestClassKind, requestId:String,
			key:String, turnId:String, itemId:String, serverName:String, mcpRequestId:String, pendingBefore:Int, pendingAfter:Int, orderIndex:Int,
			reason:String):ResumePickerAppServerTypedPendingRequestEvent {
		return new ResumePickerAppServerTypedPendingRequestEvent({
			kind: kind,
			requestClass: requestClass,
			requestId: requestId,
			key: key,
			turnId: turnId,
			itemId: itemId,
			serverName: serverName,
			mcpRequestId: mcpRequestId,
			pendingBefore: pendingBefore,
			pendingAfter: pendingAfter,
			orderIndex: orderIndex,
			reason: reason
		});
	}
}
