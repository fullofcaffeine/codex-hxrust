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

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeFrameRequest {
	public final name:String;
	public final title:String;
	public final status:String;
	public final model:String;
	@:recordMin(20)
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
}
