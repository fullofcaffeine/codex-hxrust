package codexhx.runtime.tui.smoke;

typedef TuiSmokeCommandPopupActionFields = {
	final kind:TuiSmokeCommandPopupActionKind;
	final name:String;
	final composerText:String;
	final previousFilter:String;
	final selectedIndex:Int;
	final scrollTop:Int;
	final maxVisibleRows:Int;
	final width:Int;
	final moveCount:Int;
	final catalog:Array<TuiSmokeCommandPopupItem>;
	final collaborationModesEnabled:Bool;
	final connectorsEnabled:Bool;
	final pluginsCommandEnabled:Bool;
	final serviceTierCommandsEnabled:Bool;
	final goalCommandEnabled:Bool;
	final personalityCommandEnabled:Bool;
	final realtimeConversationEnabled:Bool;
	final audioDeviceSelectionEnabled:Bool;
	final windowsDegradedSandboxActive:Bool;
	final sideConversationActive:Bool;
	final expectedFilter:String;
	final expectedCommands:Array<String>;
	final expectedRows:Array<String>;
	final expectedSelectedIndex:Int;
	final expectedSelectedCommand:String;
	final expectedScrollTop:Int;
	final expectedAccepted:Bool;
	final expectedCancelled:Bool;
	final expectedAcceptedKind:String;
	final expectedAcceptedId:String;
	final expectedHeight:Int;
	final failureCode:String;
	final noTerminalMutation:Bool;
	final noRatatuiBuffer:Bool;
	final noFilesystemMutation:Bool;
	final noClipboardMutation:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCommandPopupAction {
	@:recordDefault(TuiSmokeCommandPopupActionKind.Unknown)
	public final kind:TuiSmokeCommandPopupActionKind;
	public final name:String;
	public final composerText:String;
	public final previousFilter:String;
	public final selectedIndex:Int;
	public final scrollTop:Int;
	public final maxVisibleRows:Int;
	public final width:Int;
	public final moveCount:Int;
	public final catalog:Array<TuiSmokeCommandPopupItem>;
	public final collaborationModesEnabled:Bool;
	public final connectorsEnabled:Bool;
	public final pluginsCommandEnabled:Bool;
	public final serviceTierCommandsEnabled:Bool;
	public final goalCommandEnabled:Bool;
	public final personalityCommandEnabled:Bool;
	public final realtimeConversationEnabled:Bool;
	public final audioDeviceSelectionEnabled:Bool;
	public final windowsDegradedSandboxActive:Bool;
	public final sideConversationActive:Bool;
	public final expectedFilter:String;
	public final expectedCommands:Array<String>;
	public final expectedRows:Array<String>;
	public final expectedSelectedIndex:Int;
	public final expectedSelectedCommand:String;
	public final expectedScrollTop:Int;
	public final expectedAccepted:Bool;
	public final expectedCancelled:Bool;
	public final expectedAcceptedKind:String;
	public final expectedAcceptedId:String;
	public final expectedHeight:Int;
	public final failureCode:String;
	public final noTerminalMutation:Bool;
	public final noRatatuiBuffer:Bool;
	public final noFilesystemMutation:Bool;
	public final noClipboardMutation:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
