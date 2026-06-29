package codexhx.runtime.tui.appserver;

/**
	Encodes typed prompt frames into the newline-delimited JSON-RPC records used
	by app-server process transports.
**/
class TuiPromptJsonRpcFrameCodec {
	public static function records(frames:Array<TuiPromptJsonRpcFrame>):Array<TuiPromptJsonRpcFrameRecord> {
		final out:Array<TuiPromptJsonRpcFrameRecord> = [];
		var index = 0;
		for (frame in frames) {
			out.push(record(index, frame));
			index = index + 1;
		}
		return out;
	}

	public static function jsonLines(records:Array<TuiPromptJsonRpcFrameRecord>):String {
		final out:Array<String> = [];
		for (record in records)
			out.push(record.lineText());
		return out.join("");
	}

	static function record(sequence:Int, frame:TuiPromptJsonRpcFrame):TuiPromptJsonRpcFrameRecord {
		return switch frame {
			case TuiPromptJsonRpcFrame.Request(_):
				new TuiPromptJsonRpcFrameRecord(sequence, TuiPromptJsonRpcFrameDirection.Outbound, TuiPromptJsonRpcFrameKind.Request, frame);
			case TuiPromptJsonRpcFrame.Response(_):
				new TuiPromptJsonRpcFrameRecord(sequence, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Response, frame);
			case TuiPromptJsonRpcFrame.StreamNotification(_):
				new TuiPromptJsonRpcFrameRecord(sequence, TuiPromptJsonRpcFrameDirection.Inbound, TuiPromptJsonRpcFrameKind.Notification, frame);
		}
	}
}
