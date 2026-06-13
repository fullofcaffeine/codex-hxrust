package codexhx.runtime.model.admission;

class ProviderAdmissionRequest {
	public final requestId:String;
	public final provider:ProviderAdmissionProvider;
	public final model:ProviderAdmissionModel;
	public final credentialKind:ProviderAdmissionCredentialKind;
	public final accountKind:ProviderAdmissionAccountKind;
	public final networkKind:ProviderAdmissionNetworkKind;
	public final liveNetworkAllowed:Bool;
	public final hasCredentialMaterial:Bool;
	public final secretProbe:String;

	public function new(
		requestId:String,
		provider:ProviderAdmissionProvider,
		model:ProviderAdmissionModel,
		credentialKind:ProviderAdmissionCredentialKind,
		accountKind:ProviderAdmissionAccountKind,
		networkKind:ProviderAdmissionNetworkKind,
		liveNetworkAllowed:Bool,
		hasCredentialMaterial:Bool,
		secretProbe:String
	) {
		this.requestId = requestId;
		this.provider = provider;
		this.model = model;
		this.credentialKind = credentialKind;
		this.accountKind = accountKind;
		this.networkKind = networkKind;
		this.liveNetworkAllowed = liveNetworkAllowed;
		this.hasCredentialMaterial = hasCredentialMaterial;
		this.secretProbe = secretProbe;
	}
}
