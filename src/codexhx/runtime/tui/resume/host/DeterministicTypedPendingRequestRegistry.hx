package codexhx.runtime.tui.resume.host;

class DeterministicTypedPendingRequestRegistry {
	final records:Array<TypedPendingRequestRecord>;
	final log:Array<String>;
	var nextOrderIndex:Int;

	public function new() {
		this.records = [];
		this.log = [];
		this.nextOrderIndex = 1;
	}

	public function register(requestClass:PendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String, serverName:String,
			mcpRequestId:String, detail:String):TypedPendingRequestEvent {
		final before = records.length;
		if (!isSupported(requestClass))
			return record(event(TypedPendingRequestEventKind.UnsupportedRefused, requestClass, requestId, key, turnId, itemId, serverName, mcpRequestId,
				before, before, 0, "unsupported_request_class"));
		final duplicateIndex = duplicateIndex(requestClass, requestId, key, turnId, itemId, serverName, mcpRequestId);
		if (duplicateIndex >= 0)
			return record(event(TypedPendingRequestEventKind.DuplicateRejected, requestClass, requestId, key, turnId, itemId, serverName, mcpRequestId,
				before, before, records[duplicateIndex].orderIndex, "duplicate_request_key"));

		final order = nextOrderIndex;
		nextOrderIndex = nextOrderIndex + 1;
		records.push(new TypedPendingRequestRecord({
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
		return record(event(TypedPendingRequestEventKind.Registered, requestClass, requestId, key, turnId, itemId, serverName, mcpRequestId, before,
			records.length, order, ""));
	}

	public function resolveKey(requestClass:PendingRequestClassKind, key:String):TypedPendingRequestEvent {
		return remove(indexForClassKey(requestClass, key), TypedPendingRequestEventKind.ResolvedByKey, requestClass, "", key, "", "", "", "",
			"matched_request_key");
	}

	public function popUserInput(turnId:String):TypedPendingRequestEvent {
		return remove(indexForUserInputTurn(turnId), TypedPendingRequestEventKind.UserInputFifoPopped, PendingRequestClassKind.UserInput, "", "", turnId, "",
			"", "", "matched_turn_fifo");
	}

	public function resolveMcp(serverName:String, mcpRequestId:String):TypedPendingRequestEvent {
		return remove(indexForMcp(serverName, mcpRequestId), TypedPendingRequestEventKind.McpMatched, PendingRequestClassKind.McpElicitation, "", "", "", "",
			serverName, mcpRequestId, "matched_mcp_request");
	}

	public function resolveNotification(requestId:String):TypedPendingRequestEvent {
		return remove(indexOfRequest(requestId), TypedPendingRequestEventKind.NotificationRemoved, PendingRequestClassKind.Unknown, requestId, "", "", "", "",
			"", "server_request_resolved_notification");
	}

	public function replayDecision(requestId:String):TypedPendingRequestEvent {
		final before = records.length;
		final index = indexOfRequest(requestId);
		if (index >= 0) {
			final value = records[index];
			return record(event(TypedPendingRequestEventKind.Registered, value.requestClass, value.requestId, value.key, value.turnId, value.itemId,
				value.serverName, value.mcpRequestId, before, before, value.orderIndex, "replay_request_still_pending"));
		}
		return record(event(TypedPendingRequestEventKind.StaleReplaySkipped, PendingRequestClassKind.Unknown, requestId, "", "", "", "", "", before, before,
			0, "request_not_pending"));
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

	function remove(index:Int, kind:TypedPendingRequestEventKind, fallbackClass:PendingRequestClassKind, fallbackRequestId:String, fallbackKey:String,
			fallbackTurnId:String, fallbackItemId:String, fallbackServerName:String, fallbackMcpRequestId:String, reason:String):TypedPendingRequestEvent {
		final before = records.length;
		if (index < 0)
			return record(event(TypedPendingRequestEventKind.MissingPendingRefused, fallbackClass, fallbackRequestId, fallbackKey, fallbackTurnId,
				fallbackItemId, fallbackServerName, fallbackMcpRequestId, before, before, 0, "request_not_pending"));

		final removed = records.splice(index, 1)[0];
		return record(event(kind, removed.requestClass, removed.requestId, removed.key, removed.turnId, removed.itemId, removed.serverName,
			removed.mcpRequestId, before, records.length, removed.orderIndex, reason));
	}

	function duplicateIndex(requestClass:PendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String, serverName:String,
			mcpRequestId:String):Int {
		var i = 0;
		while (i < records.length) {
			final record = records[i];
			if (record.requestId == requestId)
				return i;
			if (requestClass != PendingRequestClassKind.UserInput
				&& requestClass != PendingRequestClassKind.McpElicitation
				&& record.requestClass == requestClass
				&& record.key == key)
				return i;
			if (requestClass == PendingRequestClassKind.McpElicitation
				&& record.requestClass == requestClass
				&& record.serverName == serverName
				&& record.mcpRequestId == mcpRequestId)
				return i;
			if (requestClass == PendingRequestClassKind.UserInput
				&& record.requestClass == requestClass
				&& record.turnId == turnId
				&& record.itemId == itemId)
				return i;
			i = i + 1;
		}
		return -1;
	}

	function indexForClassKey(requestClass:PendingRequestClassKind, key:String):Int {
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
			if (record.requestClass == PendingRequestClassKind.UserInput && record.turnId == turnId) {
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
			if (record.requestClass == PendingRequestClassKind.McpElicitation
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

	static function isSupported(kind:PendingRequestClassKind):Bool {
		return kind == PendingRequestClassKind.ExecApproval
			|| kind == PendingRequestClassKind.FileChangeApproval
			|| kind == PendingRequestClassKind.PermissionsApproval
			|| kind == PendingRequestClassKind.UserInput
			|| kind == PendingRequestClassKind.McpElicitation;
	}

	function record(value:TypedPendingRequestEvent):TypedPendingRequestEvent {
		log.push(value.summary());
		return value;
	}

	function event(kind:TypedPendingRequestEventKind, requestClass:PendingRequestClassKind, requestId:String, key:String, turnId:String, itemId:String,
			serverName:String, mcpRequestId:String, pendingBefore:Int, pendingAfter:Int, orderIndex:Int, reason:String):TypedPendingRequestEvent {
		return new TypedPendingRequestEvent({
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
