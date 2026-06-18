package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadReplayEventFields = {
	final kind:TuiSmokeThreadReplayEventKind;
	final eventId:String;
	final threadId:String;
	final notification:Null<TuiSmokeThreadNotification>;
	final text:String;
	final category:String;
	final result:String;
	final success:Bool;
	final includeLogs:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadReplayEvent {
	public final kind:TuiSmokeThreadReplayEventKind;
	public final eventId:String;
	public final threadId:String;
	public final notification:Null<TuiSmokeThreadNotification>;
	public final text:String;
	public final category:String;
	public final result:String;
	public final success:Bool;
	public final includeLogs:Bool;


	public function displayText():String {
		return switch kind {
			case TuiSmokeThreadReplayEventKind.Notification:
				notification == null ? eventId : notification.displayText();
			case TuiSmokeThreadReplayEventKind.HistoryEntryResponse:
				text.length > 0 ? text : eventId;
			case TuiSmokeThreadReplayEventKind.FeedbackSubmission:
				result.length > 0 ? result : eventId;
			case _:
				eventId;
		}
	}
}
