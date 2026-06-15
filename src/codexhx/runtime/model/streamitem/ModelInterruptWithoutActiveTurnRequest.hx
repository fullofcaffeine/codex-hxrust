package codexhx.runtime.model.streamitem;

typedef ModelInterruptWithoutActiveTurnRequestFields = {
	final requestId:String;
	final threadId:String;
	final appCommandInterrupt:Bool;
	final primaryThreadRegistered:Bool;
	final appServerSessionAvailable:Bool;
	final activeTurnId:String;
	final startupInterruptSucceeded:Bool;
	final previousEventCount:Int;
	final eventOrderIndex:Int;
	final secretProbe:String;
}

class ModelInterruptWithoutActiveTurnRequest {
	public final requestId:String;
	public final threadId:String;
	public final appCommandInterrupt:Bool;
	public final primaryThreadRegistered:Bool;
	public final appServerSessionAvailable:Bool;
	public final activeTurnId:String;
	public final startupInterruptSucceeded:Bool;
	public final previousEventCount:Int;
	public final eventOrderIndex:Int;
	public final secretProbe:String;

	public function new(fields:ModelInterruptWithoutActiveTurnRequestFields) {
		this.requestId = fields.requestId == null ? "" : fields.requestId;
		this.threadId = fields.threadId == null ? "" : fields.threadId;
		this.appCommandInterrupt = fields.appCommandInterrupt;
		this.primaryThreadRegistered = fields.primaryThreadRegistered;
		this.appServerSessionAvailable = fields.appServerSessionAvailable;
		this.activeTurnId = fields.activeTurnId == null ? "" : fields.activeTurnId;
		this.startupInterruptSucceeded = fields.startupInterruptSucceeded;
		this.previousEventCount = fields.previousEventCount;
		this.eventOrderIndex = fields.eventOrderIndex;
		this.secretProbe = fields.secretProbe == null ? "" : fields.secretProbe;
	}
}
