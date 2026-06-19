package codexhx.runtime.app.transport;

import codexhx.runtime.app.CodexRuntimeCommand;
import codexhx.runtime.app.InMemoryAppServerClient;
import codexhx.runtime.app.RuntimeClientOutcome;

class FixtureLiveTransport {
	final client:InMemoryAppServerClient;
	var closed:Bool;
	var closeMessage:String;

	public function new(queueCapacity:Int) {
		this.client = new InMemoryAppServerClient(queueCapacity);
		this.closed = false;
		this.closeMessage = "";
	}

	public function sendRequest(requestId:String, method:String, paramsJson:String):RuntimeClientOutcome {
		if (closed)
			return closedOutcome(requestId, method);
		return client.send(CodexRuntimeCommand.appRequest(requestId, method, paramsJson));
	}

	public function completeResponse(requestId:String, method:String, resultJson:String):RuntimeClientOutcome {
		if (closed)
			return closedOutcome(requestId, method);
		return client.complete(CodexRuntimeCommand.completeResponse(requestId, method, resultJson));
	}

	public function failResponse(requestId:String, method:String, errorJson:String):RuntimeClientOutcome {
		if (closed)
			return closedOutcome(requestId, method);
		return client.fail(CodexRuntimeCommand.failResponse(requestId, method, errorJson));
	}

	public function cancelRequest(requestId:String, method:String, reason:String):RuntimeClientOutcome {
		if (closed)
			return closedOutcome(requestId, method);
		return client.cancelPending(requestId, method, reason);
	}

	public function receiveNotification(method:String, paramsJson:String):RuntimeClientOutcome {
		if (closed)
			return closedOutcome("", method);
		return client.receiveNotification(method, paramsJson);
	}

	public function disconnect(message:String):RuntimeClientOutcome {
		if (closed)
			return RuntimeClientOutcome.failure("transport_closed", closeMessage, "", "", clientPendingCount());
		closed = true;
		closeMessage = message;
		return client.disconnect(message);
	}

	public function drainEventSummaries():Array<String> {
		return client.drainEventSummaries();
	}

	public function pendingCount():Int {
		return clientPendingCount();
	}

	public function isClosed():Bool {
		return closed;
	}

	function closedOutcome(requestId:String, method:String):RuntimeClientOutcome {
		return RuntimeClientOutcome.failure("transport_closed", closeMessage, requestId, method, clientPendingCount());
	}

	function clientPendingCount():Int {
		return client.pendingRequestCount();
	}
}
