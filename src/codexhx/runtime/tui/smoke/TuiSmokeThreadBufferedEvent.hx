package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadBufferedEventFields = {
	final kind:TuiSmokeThreadBufferedEventKind;
	final request:Null<TuiSmokeAppServerRequest>;
	final notification:Null<TuiSmokeThreadNotification>;
}

class TuiSmokeThreadBufferedEvent {
	public final kind:TuiSmokeThreadBufferedEventKind;
	public final request:Null<TuiSmokeAppServerRequest>;
	public final notification:Null<TuiSmokeThreadNotification>;

	public function new(fields:TuiSmokeThreadBufferedEventFields) {
		this.kind = fields.kind == null ? TuiSmokeThreadBufferedEventKind.Unknown : fields.kind;
		this.request = fields.request;
		this.notification = fields.notification;
	}

	public static function requestEvent(request:TuiSmokeAppServerRequest):TuiSmokeThreadBufferedEvent {
		return new TuiSmokeThreadBufferedEvent({
			kind: TuiSmokeThreadBufferedEventKind.Request,
			request: request,
			notification: null
		});
	}

	public static function notificationEvent(notification:TuiSmokeThreadNotification):TuiSmokeThreadBufferedEvent {
		return new TuiSmokeThreadBufferedEvent({
			kind: TuiSmokeThreadBufferedEventKind.Notification,
			request: null,
			notification: notification
		});
	}
}
