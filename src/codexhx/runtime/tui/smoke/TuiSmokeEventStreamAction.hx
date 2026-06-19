package codexhx.runtime.tui.smoke;

typedef TuiSmokeEventStreamActionFields = {
	final kind:TuiSmokeEventStreamActionKind;
	final stateBefore:TuiSmokeEventStreamBrokerState;
	final stateAfter:TuiSmokeEventStreamBrokerState;
	final sourceEvent:TuiSmokeEventStreamEventKind;
	final mappedEvent:TuiSmokeMappedTuiEventKind;
	final pollOrder:TuiSmokeEventStreamPollOrder;
	final key:TuiSmokeKeyKind;
	final paste:String;
	final dropSource:Bool;
	final wakeResume:Bool;
	final recreateSource:Bool;
	final drawSubscription:Bool;
	final sharedBroker:Bool;
	final terminalFocused:Bool;
	final paletteRequery:Bool;
	final altScreenActive:Bool;
	final keepRaw:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeEventStreamAction {
	public final kind:TuiSmokeEventStreamActionKind;
	public final stateBefore:TuiSmokeEventStreamBrokerState;
	public final stateAfter:TuiSmokeEventStreamBrokerState;
	@:recordDefault(TuiSmokeEventStreamEventKind.None)
	public final sourceEvent:TuiSmokeEventStreamEventKind;
	@:recordDefault(TuiSmokeMappedTuiEventKind.None)
	public final mappedEvent:TuiSmokeMappedTuiEventKind;
	public final pollOrder:TuiSmokeEventStreamPollOrder;
	@:recordDefault(TuiSmokeKeyKind.None)
	public final key:TuiSmokeKeyKind;
	public final paste:String;
	public final dropSource:Bool;
	public final wakeResume:Bool;
	public final recreateSource:Bool;
	public final drawSubscription:Bool;
	public final sharedBroker:Bool;
	public final terminalFocused:Bool;
	public final paletteRequery:Bool;
	public final altScreenActive:Bool;
	public final keepRaw:Bool;

	public function stateTransitionText():String {
		return stateBefore + "->" + stateAfter;
	}

	public function mappedText():String {
		return eventText(sourceEvent) + "->" + mappedEventText();
	}

	function mappedEventText():String {
		return switch mappedEvent {
			case TuiSmokeMappedTuiEventKind.Key:
				"key:" + key;
			case TuiSmokeMappedTuiEventKind.Paste:
				"paste:" + paste.length;
			case _:
				mappedEvent;
		}
	}

	function eventText(kind:TuiSmokeEventStreamEventKind):String {
		return switch kind {
			case TuiSmokeEventStreamEventKind.Key:
				"key:" + key;
			case TuiSmokeEventStreamEventKind.Paste:
				"paste:" + paste.length;
			case _:
				kind;
		}
	}
}
