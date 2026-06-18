package codexhx.runtime.tui.smoke;

typedef TuiSmokeFrameRequestFields = {
	final name:String;
	final title:String;
	final status:String;
	final model:String;
	final width:Int;
	final transcript:Array<TuiSmokeTranscriptRow>;
	final input:String;
	final terminalMode:TuiSmokeTerminalMode;
	final key:TuiSmokeKeyKind;
	final expectedExit:TuiSmokeExitKind;
	final allowLiveTerminal:Bool;
	final allowNetwork:Bool;
	final allowModelCall:Bool;
	final expectedSnapshot:String;
}

class TuiSmokeFrameRequest {
	public final name:String;
	public final title:String;
	public final status:String;
	public final model:String;
	public final width:Int;
	public final transcript:Array<TuiSmokeTranscriptRow>;
	public final input:String;
	public final terminalMode:TuiSmokeTerminalMode;
	public final key:TuiSmokeKeyKind;
	public final expectedExit:TuiSmokeExitKind;
	public final allowLiveTerminal:Bool;
	public final allowNetwork:Bool;
	public final allowModelCall:Bool;
	public final expectedSnapshot:String;

	public function new(fields:TuiSmokeFrameRequestFields) {
		this.name = fields.name == null ? "" : fields.name;
		this.title = fields.title == null ? "" : fields.title;
		this.status = fields.status == null ? "" : fields.status;
		this.model = fields.model == null ? "" : fields.model;
		this.width = fields.width < 20 ? 20 : fields.width;
		this.transcript = fields.transcript == null ? [] : fields.transcript;
		this.input = fields.input == null ? "" : fields.input;
		this.terminalMode = fields.terminalMode == null ? TuiSmokeTerminalMode.Unknown : fields.terminalMode;
		this.key = fields.key == null ? TuiSmokeKeyKind.Unknown : fields.key;
		this.expectedExit = fields.expectedExit == null ? TuiSmokeExitKind.Unknown : fields.expectedExit;
		this.allowLiveTerminal = fields.allowLiveTerminal;
		this.allowNetwork = fields.allowNetwork;
		this.allowModelCall = fields.allowModelCall;
		this.expectedSnapshot = fields.expectedSnapshot == null ? "" : fields.expectedSnapshot;
	}
}
