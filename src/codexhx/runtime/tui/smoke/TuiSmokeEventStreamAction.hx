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

class TuiSmokeEventStreamAction {
	public final kind:TuiSmokeEventStreamActionKind;
	public final stateBefore:TuiSmokeEventStreamBrokerState;
	public final stateAfter:TuiSmokeEventStreamBrokerState;
	public final sourceEvent:TuiSmokeEventStreamEventKind;
	public final mappedEvent:TuiSmokeMappedTuiEventKind;
	public final pollOrder:TuiSmokeEventStreamPollOrder;
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

	public function new(fields:TuiSmokeEventStreamActionFields) {
		this.kind = fields.kind == null ? TuiSmokeEventStreamActionKind.Unknown : fields.kind;
		this.stateBefore = fields.stateBefore == null ? TuiSmokeEventStreamBrokerState.Unknown : fields.stateBefore;
		this.stateAfter = fields.stateAfter == null ? TuiSmokeEventStreamBrokerState.Unknown : fields.stateAfter;
		this.sourceEvent = fields.sourceEvent == null ? TuiSmokeEventStreamEventKind.None : fields.sourceEvent;
		this.mappedEvent = fields.mappedEvent == null ? TuiSmokeMappedTuiEventKind.None : fields.mappedEvent;
		this.pollOrder = fields.pollOrder == null ? TuiSmokeEventStreamPollOrder.Unknown : fields.pollOrder;
		this.key = fields.key == null ? TuiSmokeKeyKind.None : fields.key;
		this.paste = fields.paste == null ? "" : fields.paste;
		this.dropSource = fields.dropSource;
		this.wakeResume = fields.wakeResume;
		this.recreateSource = fields.recreateSource;
		this.drawSubscription = fields.drawSubscription;
		this.sharedBroker = fields.sharedBroker;
		this.terminalFocused = fields.terminalFocused;
		this.paletteRequery = fields.paletteRequery;
		this.altScreenActive = fields.altScreenActive;
		this.keepRaw = fields.keepRaw;
	}

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
