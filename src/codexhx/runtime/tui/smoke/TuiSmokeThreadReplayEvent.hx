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

	public function new(fields:TuiSmokeThreadReplayEventFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadReplayEventKind.Unknown : fields.kind;
		this.eventId = fields.eventId == null ? "" : fields.eventId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.notification = fields.notification;
		this.text = fields.text == null ? "" : fields.text;
		this.category = fields.category == null ? "" : fields.category;
		this.result = fields.result == null ? "" : fields.result;
		this.success = fields.success;
		this.includeLogs = fields.includeLogs;
	}

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
