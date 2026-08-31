package codexhx.runtime.tui.appserver;

import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;

/** Typed result of the app-server bootstrap and thread-open exchange. */
class TuiAppServerStartupOutcome {
	final acceptedValue:Bool;
	final codeValue:String;
	final sessionIdValue:Null<SessionId>;
	final threadIdValue:Null<ThreadId>;
	final modelLabelValue:String;
	final protocolMethodsValue:Array<String>;
	final outboundLinesValue:Array<String>;

	function new(accepted:Bool, code:String, sessionId:Null<SessionId>, threadId:Null<ThreadId>, modelLabel:String, protocolMethods:Array<String>,
			outboundLines:Array<String>) {
		this.acceptedValue = accepted;
		this.codeValue = code;
		this.sessionIdValue = sessionId;
		this.threadIdValue = threadId;
		this.modelLabelValue = modelLabel == null ? "" : modelLabel;
		this.protocolMethodsValue = protocolMethods == null ? [] : protocolMethods.copy();
		this.outboundLinesValue = outboundLines == null ? [] : outboundLines.copy();
	}

	public static function accepted(sessionId:SessionId, threadId:ThreadId, modelLabel:String, protocolMethods:Array<String>,
			?outboundLines:Array<String>):TuiAppServerStartupOutcome {
		return new TuiAppServerStartupOutcome(true, "started", sessionId, threadId, modelLabel, protocolMethods, outboundLines);
	}

	public static function rejected(code:String):TuiAppServerStartupOutcome {
		return new TuiAppServerStartupOutcome(false, code == null || code.length == 0 ? "startup_rejected" : code, null, null, "", [], []);
	}

	public function isAccepted():Bool
		return acceptedValue;

	public function code():String
		return codeValue;

	public function sessionId():Null<SessionId>
		return sessionIdValue;

	public function threadId():Null<ThreadId>
		return threadIdValue;

	public function modelLabel():String
		return modelLabelValue;

	public function protocolMethods():Array<String>
		return protocolMethodsValue.copy();

	public function outboundLines():Array<String>
		return outboundLinesValue.copy();
}
