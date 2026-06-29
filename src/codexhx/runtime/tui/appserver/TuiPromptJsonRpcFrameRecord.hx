package codexhx.runtime.tui.appserver;

/**
	Ordered newline-oriented JSON-RPC prompt frame record.
**/
class TuiPromptJsonRpcFrameRecord {
	public final sequence:Int;
	public final direction:TuiPromptJsonRpcFrameDirection;
	public final kind:TuiPromptJsonRpcFrameKind;
	public final frame:TuiPromptJsonRpcFrame;

	public function new(sequence:Int, direction:TuiPromptJsonRpcFrameDirection, kind:TuiPromptJsonRpcFrameKind, frame:TuiPromptJsonRpcFrame) {
		this.sequence = sequence;
		this.direction = direction;
		this.kind = kind;
		this.frame = frame;
	}

	public function directionText():String {
		return direction.text();
	}

	public function kindText():String {
		return kind.text();
	}

	public function methodText():String {
		return switch frame {
			case TuiPromptJsonRpcFrame.Request(request):
				request.methodText();
			case TuiPromptJsonRpcFrame.Response(response):
				response.methodText();
			case TuiPromptJsonRpcFrame.StreamNotification(notification):
				streamNotificationMethodText(notification);
		}
	}

	public function messageJson():String {
		return switch frame {
			case TuiPromptJsonRpcFrame.Request(request):
				request.messageJson();
			case TuiPromptJsonRpcFrame.Response(response):
				response.messageJson();
			case TuiPromptJsonRpcFrame.StreamNotification(notification):
				streamNotificationMessageJson(notification);
		}
	}

	public function lineText():String {
		return messageJson() + "\n";
	}

	static function streamNotificationMethodText(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status.methodText();
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.methodText();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.methodText();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.methodText();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.methodText();
		}
	}

	static function streamNotificationMessageJson(notification:TuiPromptJsonRpcStreamNotification):String {
		return switch notification {
			case TuiPromptJsonRpcStreamNotification.ThreadStatusChanged(status):
				status.messageJson();
			case TuiPromptJsonRpcStreamNotification.Turn(turn):
				turn.messageJson();
			case TuiPromptJsonRpcStreamNotification.UserMessageCompleted(completed):
				completed.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageStarted(started):
				started.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageDelta(delta):
				delta.messageJson();
			case TuiPromptJsonRpcStreamNotification.RawResponseItemCompleted(completed):
				completed.messageJson();
			case TuiPromptJsonRpcStreamNotification.AgentMessageCompleted(completed):
				completed.messageJson();
		}
	}
}
