package codexhx.runtime.tui.smoke;

typedef TuiSmokeAppServerElicitationActionFields = {
	final kind:TuiSmokeAppServerElicitationActionKind;
	final visibleThreadId:String;
	final requestThreadId:String;
	final turnId:String;
	final serverName:String;
	final requestId:Int;
	final url:String;
	final elicitationId:String;
	final message:String;
	final title:String;
	final description:String;
	final interactiveRequestKind:String;
	final appEventKind:String;
	final opKind:String;
	final decision:String;
	final failureCode:String;
	final invalidUrlRejected:Bool;
	final targetedRequestThread:Bool;
	final requestReturned:Bool;
	final appLinkTargetPresent:Bool;
	final visibleThreadMutated:Bool;
	final contentEmpty:Bool;
	final metaEmpty:Bool;
	final noAppLinkView:Bool;
	final noBrowserLaunch:Bool;
	final noAppServerDelivery:Bool;
	final noNetwork:Bool;
	final noModelCall:Bool;
	final unsupportedRejected:Bool;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
/** Typed headless evidence for one upstream ChatWidget app-server elicitation routing behavior. */
class TuiSmokeAppServerElicitationAction {
	public final kind:TuiSmokeAppServerElicitationActionKind;
	public final visibleThreadId:String;
	public final requestThreadId:String;
	public final turnId:String;
	public final serverName:String;
	public final requestId:Int;
	public final url:String;
	public final elicitationId:String;
	public final message:String;
	public final title:String;
	public final description:String;
	public final interactiveRequestKind:String;
	public final appEventKind:String;
	public final opKind:String;
	public final decision:String;
	public final failureCode:String;
	public final invalidUrlRejected:Bool;
	public final targetedRequestThread:Bool;
	public final requestReturned:Bool;
	public final appLinkTargetPresent:Bool;
	public final visibleThreadMutated:Bool;
	public final contentEmpty:Bool;
	public final metaEmpty:Bool;
	public final noAppLinkView:Bool;
	public final noBrowserLaunch:Bool;
	public final noAppServerDelivery:Bool;
	public final noNetwork:Bool;
	public final noModelCall:Bool;
	public final unsupportedRejected:Bool;
}
