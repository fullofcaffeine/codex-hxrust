package codexhx.runtime.tui.smoke;

typedef TuiSmokeScrollStateActionFields = {
	final kind:TuiSmokeScrollStateActionKind;
	final name:String;
	final len:Int;
	final visibleRows:Int;
	final selected:Int;
	final scrollTop:Int;
	final expectedSelected:Int;
	final expectedScrollTop:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeScrollStateAction {
	public final kind:TuiSmokeScrollStateActionKind;
	public final name:String;
	public final len:Int;
	public final visibleRows:Int;
	public final selected:Int;
	public final scrollTop:Int;
	public final expectedSelected:Int;
	public final expectedScrollTop:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
