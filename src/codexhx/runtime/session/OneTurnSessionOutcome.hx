package codexhx.runtime.session;

import codexhx.runtime.model.ModelStreamEvent;

class OneTurnSessionOutcome {
	public final ok:Bool;
	public final terminalState:String;
	public final streamId:String;
	public final assistantText:String;
	public final events:Array<ModelStreamEvent>;
	public final errorCode:String;
	public final errorPath:String;
	public final errorMessage:String;

	function new(ok:Bool, terminalState:String, streamId:String, assistantText:String, events:Array<ModelStreamEvent>, errorCode:String, errorPath:String,
			errorMessage:String) {
		this.ok = ok;
		this.terminalState = terminalState;
		this.streamId = streamId;
		this.assistantText = assistantText;
		this.events = events;
		this.errorCode = errorCode;
		this.errorPath = errorPath;
		this.errorMessage = errorMessage;
	}

	public static function success(streamId:String, terminalState:String, events:Array<ModelStreamEvent>, assistantText:String):OneTurnSessionOutcome {
		return new OneTurnSessionOutcome(true, terminalState, streamId, assistantText, events, "", "", "");
	}

	public static function failure(streamId:String, code:String, path:String, message:String):OneTurnSessionOutcome {
		return new OneTurnSessionOutcome(false, "failed", streamId, "", [new ModelStreamEvent("session_error", "", "", "", code, message, 0)], code, path,
			message);
	}

	public static function cancelled(streamId:String, events:Array<ModelStreamEvent>, assistantText:String):OneTurnSessionOutcome {
		final cancelledEvents = events.copy();
		cancelledEvents.push(new ModelStreamEvent("session_cancelled", "", "", "", "cancelled", "session cancelled at safe checkpoint", 0));
		return new OneTurnSessionOutcome(true, "cancelled", streamId, assistantText, cancelledEvents, "", "", "");
	}

	public function canonicalEventsJson():String {
		final parts:Array<String> = [];
		for (event in events) {
			parts.push(event.canonicalJson());
		}
		return "[" + parts.join(",") + "]";
	}
}
