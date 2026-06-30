package codexhx.runtime.tui.appserver;

/**
	Boundary that binds opened app-server line connections to line transports.
**/
interface TuiAppServerJsonRpcLineTransportAttacher {
	function attach(outcome:TuiAppServerJsonRpcLineOpenOutcome):TuiAppServerJsonRpcLineTransportAttachment;
	function transportFor(attachment:TuiAppServerJsonRpcLineTransportAttachment):Null<TuiAppServerJsonRpcLineTransport>;
}
