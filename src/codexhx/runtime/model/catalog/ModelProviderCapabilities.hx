package codexhx.runtime.model.catalog;

import codexhx.runtime.model.admission.ProviderAdmissionProvider;

class ModelProviderCapabilities {
	public final namespaceTools:Bool;
	public final imageGeneration:Bool;
	public final webSearch:Bool;

	public function new(namespaceTools:Bool, imageGeneration:Bool, webSearch:Bool) {
		this.namespaceTools = namespaceTools;
		this.imageGeneration = imageGeneration;
		this.webSearch = webSearch;
	}

	public static function defaultConfigured():ModelProviderCapabilities {
		return new ModelProviderCapabilities(true, true, true);
	}

	public static function forProvider(provider:ProviderAdmissionProvider):ModelProviderCapabilities {
		if (provider != null && provider.hasAwsAuth)
			return new ModelProviderCapabilities(true, false, false);
		return defaultConfigured();
	}

	public function summary():String {
		return "namespaceTools="
			+ boolText(namespaceTools)
			+ ";imageGeneration="
			+ boolText(imageGeneration)
			+ ";webSearch="
			+ boolText(webSearch);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
