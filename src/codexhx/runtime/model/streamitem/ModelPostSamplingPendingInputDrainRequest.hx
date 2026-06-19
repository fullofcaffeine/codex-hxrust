package codexhx.runtime.model.streamitem;

class ModelPostSamplingPendingInputDrainRequest {
	public final requestId:String;
	public final integrationOutcome:ModelSamplingResultIntegrationOutcome;
	public final activeTurnItems:Array<ModelPostSamplingPendingInputDrainItem>;
	public final mailboxItems:Array<ModelPostSamplingPendingInputDrainItem>;
	public final acceptsMailboxDelivery:Bool;
	public final secretProbe:String;

	public function new(requestId:String, integrationOutcome:ModelSamplingResultIntegrationOutcome,
			activeTurnItems:Array<ModelPostSamplingPendingInputDrainItem>, mailboxItems:Array<ModelPostSamplingPendingInputDrainItem>,
			acceptsMailboxDelivery:Bool, secretProbe:String) {
		this.requestId = requestId == null ? "" : requestId;
		this.integrationOutcome = integrationOutcome;
		this.activeTurnItems = activeTurnItems == null ? [] : activeTurnItems;
		this.mailboxItems = mailboxItems == null ? [] : mailboxItems;
		this.acceptsMailboxDelivery = acceptsMailboxDelivery;
		this.secretProbe = secretProbe == null ? "" : secretProbe;
	}
}
