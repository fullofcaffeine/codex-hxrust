package codexhx.runtime.model.catalog;

class ModelCatalogEntry {
	public final modelId:String;
	public final providerId:String;
	public final displayName:String;
	public final priority:Int;
	public final visibility:ModelCatalogVisibility;
	public final supportedInApi:Bool;
	public final contextWindow:Int;
	public final maxContextWindow:Int;
	public final supportsSearchTool:Bool;
	public final webSearchToolType:ModelCatalogWebSearchToolType;
	public final toolMode:ModelCatalogToolMode;
	public final inputModalities:Array<String>;
	public final serviceTiers:Array<String>;
	public final defaultServiceTier:String;
	public final additionalSpeedTiers:Array<String>;
	public final experimentalSupportedTools:Array<String>;

	public function new(
		modelId:String,
		providerId:String,
		displayName:String,
		priority:Int,
		visibility:ModelCatalogVisibility,
		supportedInApi:Bool,
		contextWindow:Int,
		maxContextWindow:Int,
		supportsSearchTool:Bool,
		webSearchToolType:ModelCatalogWebSearchToolType,
		toolMode:ModelCatalogToolMode,
		inputModalities:Array<String>,
		serviceTiers:Array<String>,
		defaultServiceTier:String,
		additionalSpeedTiers:Array<String>,
		experimentalSupportedTools:Array<String>
	) {
		this.modelId = modelId;
		this.providerId = providerId;
		this.displayName = displayName;
		this.priority = priority;
		this.visibility = visibility;
		this.supportedInApi = supportedInApi;
		this.contextWindow = contextWindow;
		this.maxContextWindow = maxContextWindow;
		this.supportsSearchTool = supportsSearchTool;
		this.webSearchToolType = webSearchToolType;
		this.toolMode = toolMode;
		this.inputModalities = inputModalities == null ? [] : inputModalities;
		this.serviceTiers = serviceTiers == null ? [] : serviceTiers;
		this.defaultServiceTier = defaultServiceTier;
		this.additionalSpeedTiers = additionalSpeedTiers == null ? [] : additionalSpeedTiers;
		this.experimentalSupportedTools = experimentalSupportedTools == null ? [] : experimentalSupportedTools;
	}

	public function valid():Bool {
		return StringTools.trim(modelId).length > 0
			&& StringTools.trim(providerId).length > 0
			&& priority >= 0
			&& contextWindow >= 0
			&& maxContextWindow >= 0;
	}

	public function showInPicker():Bool {
		return visibility == ModelCatalogVisibility.List;
	}

	public function hidden():Bool {
		return !showInPicker();
	}

	public function supportsHostedWebSearch(capabilities:ModelProviderCapabilities):Bool {
		return capabilities.webSearch && webSearchToolType == ModelCatalogWebSearchToolType.TextAndImage;
	}

	public function supportsHostedImageGeneration(capabilities:ModelProviderCapabilities):Bool {
		return capabilities.imageGeneration && experimentalSupportedTools.indexOf("image_generation") >= 0;
	}

	public function supportsNamespaceTools(capabilities:ModelProviderCapabilities):Bool {
		return capabilities.namespaceTools;
	}

	public function summary(capabilities:ModelProviderCapabilities):String {
		return "model=" + modelId
			+ ";provider=" + providerId
			+ ";priority=" + Std.string(priority)
			+ ";visibility=" + visibility
			+ ";showInPicker=" + boolText(showInPicker())
			+ ";supportedInApi=" + boolText(supportedInApi)
			+ ";contextWindow=" + Std.string(contextWindow)
			+ ";maxContextWindow=" + Std.string(maxContextWindow)
			+ ";webSearchToolType=" + webSearchToolType
			+ ";toolMode=" + toolMode
			+ ";hostedWebSearch=" + boolText(supportsHostedWebSearch(capabilities))
			+ ";hostedImageGeneration=" + boolText(supportsHostedImageGeneration(capabilities))
			+ ";namespaceTools=" + boolText(supportsNamespaceTools(capabilities))
			+ ";inputModalities=" + inputModalities.join(",")
			+ ";serviceTiers=" + serviceTiers.join(",")
			+ ";defaultServiceTier=" + (defaultServiceTier == null || defaultServiceTier.length == 0 ? "none" : defaultServiceTier);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
