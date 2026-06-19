package codexhx.runtime.model.streamitem;

class ModelStreamOutputItem {
	public final kind:ModelStreamOutputItemKind;
	public final itemId:String;
	public final role:String;
	public final text:String;
	public final phase:String;
	public final summary:Array<String>;
	public final rawContent:Array<String>;
	public final callId:String;
	public final toolName:String;
	public final namespace:String;
	public final arguments:String;
	public final customInput:String;
	public final status:String;

	public function new(kind:ModelStreamOutputItemKind, itemId:String, role:String, text:String, phase:String, summary:Array<String>,
			rawContent:Array<String>, callId:String, toolName:String, namespace:String, arguments:String, customInput:String, status:String) {
		this.kind = kind;
		this.itemId = itemId;
		this.role = role;
		this.text = text;
		this.phase = phase;
		this.summary = summary == null ? [] : summary;
		this.rawContent = rawContent == null ? [] : rawContent;
		this.callId = callId;
		this.toolName = toolName;
		this.namespace = namespace;
		this.arguments = arguments;
		this.customInput = customInput;
		this.status = status;
	}
}
