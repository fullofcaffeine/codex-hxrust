package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;
import haxe.json.Value;

/** Client-owned boundary for replies to app-server initiated requests. */
interface TuiAppServerClientTransport {
	function resolveServerRequest(requestId:RequestId, result:Value):TuiAppServerRequestResponseOutcome;
	function rejectServerRequest(requestId:RequestId, error:TuiAppServerJsonRpcError):TuiAppServerRequestResponseOutcome;
}
