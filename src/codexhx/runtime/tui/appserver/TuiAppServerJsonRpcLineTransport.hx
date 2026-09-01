package codexhx.runtime.tui.appserver;

/** Line-oriented app-server transport for requests, responses, and events. */
interface TuiAppServerJsonRpcLineTransport {
	function sendPromptLine(request:TuiPromptJsonRpcRequest, envelope:TuiPromptSubmitEnvelope, outboundLine:String):TuiAppServerJsonRpcLineOutcome;
	function sendInterruptLine(request:TuiPromptTurnInterruptRequest, envelope:TuiPromptTurnInterruptEnvelope,
		outboundLine:String):TuiPromptTurnInterruptLineOutcome;
	function sendClientResponseLine(response:TuiAppServerClientResponse, outboundLine:String):TuiAppServerRequestResponseOutcome;
	function readLateJsonlBatchLines(maxLines:Int):TuiAppServerJsonRpcLateJsonlBatch;
	function isOpen():Bool;
	function stateText():String;
	function close(code:String):TuiAppServerJsonRpcLineCloseReport;
	function outboundLineCount():Int;
	function inboundLineCount():Int;
}
