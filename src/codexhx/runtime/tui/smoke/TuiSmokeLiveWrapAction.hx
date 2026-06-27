package codexhx.runtime.tui.smoke;

typedef TuiSmokeLiveWrapActionFields = {
	final kind:TuiSmokeLiveWrapActionKind;
	final name:String;
	final width:Int;
	final maxKeep:Int;
	final maxCols:Int;
	final fragment:String;
	final text:String;
	final expectedRows:Array<TuiSmokeLiveWrapRow>;
	final expectedRemainingRows:Array<TuiSmokeLiveWrapRow>;
	final expectedPrefix:String;
	final expectedSuffix:String;
	final expectedWidth:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeLiveWrapAction {
	public final kind:TuiSmokeLiveWrapActionKind;
	public final name:String;
	public final width:Int;
	public final maxKeep:Int;
	public final maxCols:Int;
	public final fragment:String;
	public final text:String;
	public final expectedRows:Array<TuiSmokeLiveWrapRow>;
	public final expectedRemainingRows:Array<TuiSmokeLiveWrapRow>;
	public final expectedPrefix:String;
	public final expectedSuffix:String;
	public final expectedWidth:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
