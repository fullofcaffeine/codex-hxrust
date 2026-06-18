package codexhx.runtime.tui.smoke;

typedef TuiSmokeThreadBufferedEventFields = {
	final kind:TuiSmokeThreadBufferedEventKind;
	final request:Null<TuiSmokeAppServerRequest>;
	final notification:Null<TuiSmokeThreadNotification>;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeThreadBufferedEvent {
	public final kind:TuiSmokeThreadBufferedEventKind;
	public final request:Null<TuiSmokeAppServerRequest>;
	public final notification:Null<TuiSmokeThreadNotification>;

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
