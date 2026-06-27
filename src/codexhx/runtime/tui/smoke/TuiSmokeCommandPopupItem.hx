package codexhx.runtime.tui.smoke;

typedef TuiSmokeCommandPopupItemFields = {
	final kind:TuiSmokeCommandPopupItemKind;
	final command:String;
	final description:String;
	final id:String;
	final isAlias:Bool;
	final isDebug:Bool;
	final isApps:Bool;
	final requiresFlag:String;
	final availableInSideConversation:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeCommandPopupItem {
	@:recordDefault(TuiSmokeCommandPopupItemKind.Builtin)
	public final kind:TuiSmokeCommandPopupItemKind;
	public final command:String;
	public final description:String;
	public final id:String;
	public final isAlias:Bool;
	public final isDebug:Bool;
	public final isApps:Bool;
	public final requiresFlag:String;
	public final availableInSideConversation:Bool;
}
