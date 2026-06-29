package codexhx.runtime.tui.appserver;

/**
	Projects typed JSON-RPC prompt notifications into shell-owned app-server
	events while preserving the fake stream events used by the minimal live TUI.
**/
class TuiPromptJsonRpcNotificationProjector {
	public static function projectWithStreamEvents(notifications:Array<TuiPromptJsonRpcNotification>,
			streamEvents:Array<TuiAppServerEvent>):Array<TuiAppServerEvent> {
		final events:Array<TuiAppServerEvent> = [];
		appendStarted(events, notifications);
		appendEvents(events, streamEvents);
		appendCompleted(events, notifications);
		return events;
	}

	static function appendStarted(events:Array<TuiAppServerEvent>, notifications:Array<TuiPromptJsonRpcNotification>):Void {
		if (notifications == null)
			return;
		for (notification in notifications) {
			if (notification != null && notification.method == TuiPromptJsonRpcNotificationMethod.TurnStarted)
				events.push(TuiAppServerEvent.ThreadStatus(notification.threadId, TuiAppServerThreadStatus.Working("submitted")));
		}
	}

	static function appendCompleted(events:Array<TuiAppServerEvent>, notifications:Array<TuiPromptJsonRpcNotification>):Void {
		if (notifications == null)
			return;
		for (notification in notifications) {
			if (notification != null && notification.method == TuiPromptJsonRpcNotificationMethod.TurnCompleted)
				events.push(TuiAppServerEvent.ThreadStatus(notification.threadId, TuiAppServerThreadStatus.Ready("ready")));
		}
	}

	static function appendEvents(target:Array<TuiAppServerEvent>, source:Array<TuiAppServerEvent>):Void {
		if (source == null)
			return;
		for (event in source)
			target.push(event);
	}
}
