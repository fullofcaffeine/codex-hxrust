package codexhx.runtime.tui.smoke;

class TuiSmokeAppState {
	final name:String;
	final title:String;
	final model:String;
	final width:Int;
	final transcript:Array<TuiSmokeTranscriptRow>;
	final terminalMode:TuiSmokeTerminalMode;
	final allowLiveTerminal:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	var status:String;
	var input:String;

	public function new(frame:TuiSmokeFrameRequest) {
		this.name = frame.name;
		this.title = frame.title;
		this.model = frame.model;
		this.width = frame.width;
		this.transcript = frame.transcript;
		this.terminalMode = frame.terminalMode;
		this.allowLiveTerminal = frame.allowLiveTerminal;
		this.allowNetwork = frame.allowNetwork;
		this.allowModelCall = frame.allowModelCall;
		this.status = frame.status;
		this.input = frame.input;
	}

	public function updateStatus(value:String):Void {
		status = value == null ? "" : value;
	}

	public function updateInput(value:String):Void {
		input = value == null ? "" : value;
	}

	public function appendTranscript(row:TuiSmokeTranscriptRow):Void {
		if (row != null)
			transcript.push(row);
	}

	public function frame():TuiSmokeFrameRequest {
		return new TuiSmokeFrameRequest({
			name: name,
			title: title,
			status: status,
			model: model,
			width: width,
			transcript: transcript,
			input: input,
			terminalMode: terminalMode,
			key: TuiSmokeKeyKind.None,
			expectedExit: TuiSmokeExitKind.Rendered,
			allowLiveTerminal: allowLiveTerminal,
			allowNetwork: allowNetwork,
			allowModelCall: allowModelCall,
			expectedSnapshot: ""
		});
	}
}
