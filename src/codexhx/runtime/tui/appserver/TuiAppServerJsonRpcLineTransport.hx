package codexhx.runtime.tui.appserver;

/**
	Line-oriented app-server JSON-RPC transport for prompt requests.
**/
interface TuiAppServerJsonRpcLineTransport {
	function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome;
	function sendInterruptLine(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope,
		outboundLine:String):TuiPromptTurnInterruptLineOutcome;
	function isOpen():Bool;
	function stateText():String;
	function close(code:String):TuiAppServerJsonRpcLineCloseReport;
	function outboundLineCount():Int;
	function inboundLineCount():Int;
}
