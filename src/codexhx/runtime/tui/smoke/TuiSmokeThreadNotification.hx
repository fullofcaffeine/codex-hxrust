package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadNotificationFields = {
	final kind:TuiSmokeThreadNotificationKind;
	final notificationId:String;
	final threadId:String;
	final status:String;
	final delta:String;
	final message:String;
}

class TuiSmokeThreadNotification {
	public final kind:TuiSmokeThreadNotificationKind;
	public final notificationId:String;
	public final threadId:String;
	public final status:String;
	public final delta:String;
	public final message:String;

	public function new(fields:TuiSmokeThreadNotificationFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadNotificationKind.Unknown : fields.kind;
		this.notificationId = fields.notificationId == null ? "" : fields.notificationId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.status = fields.status == null ? "" : fields.status;
		this.delta = fields.delta == null ? "" : fields.delta;
		this.message = fields.message == null ? "" : fields.message;
	}

	public function displayText():String {
		return switch kind {
			case TuiSmokeThreadNotificationKind.ThreadStatus:
				status.length > 0 ? status : notificationId;
			case TuiSmokeThreadNotificationKind.AssistantDelta:
				delta.length > 0 ? delta : notificationId;
			case TuiSmokeThreadNotificationKind.Warning | TuiSmokeThreadNotificationKind.ThreadClosed:
				message.length > 0 ? message : notificationId;
			case _:
				notificationId;
		}
	}
}
