package codexhx.runtime.tui.smoke;

typedef TuiSmokeStatusSurfacePreviewActionFields = {
	final kind:TuiSmokeStatusSurfacePreviewActionKind;
	final name:String;
	final item:String;
	final value:String;
	final items:Array<String>;
	final expected:String;
	final expectedPresent:Bool;
	final expectedCount:Int;
	final fallbackName:String;
	final fallbackDescription:String;
	final expectedName:String;
	final expectedDescription:String;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeStatusSurfacePreviewAction {
	public final kind:TuiSmokeStatusSurfacePreviewActionKind;
	public final name:String;
	public final item:String;
	public final value:String;
	public final items:Array<String>;
	public final expected:String;
	public final expectedPresent:Bool;
	public final expectedCount:Int;
	public final fallbackName:String;
	public final fallbackDescription:String;
	public final expectedName:String;
	public final expectedDescription:String;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
