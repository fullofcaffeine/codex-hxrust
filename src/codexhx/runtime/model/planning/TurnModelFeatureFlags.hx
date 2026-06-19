package codexhx.runtime.model.planning;

class TurnModelFeatureFlags {
	public final codeMode:Bool;
	public final codeModeOnly:Bool;
	public final standaloneWebSearch:Bool;
	public final imageGeneration:Bool;
	public final imageGenExt:Bool;
	public final deferredToolsAvailable:Bool;

	public function new(codeMode:Bool, codeModeOnly:Bool, standaloneWebSearch:Bool, imageGeneration:Bool, imageGenExt:Bool, deferredToolsAvailable:Bool) {
		this.codeMode = codeMode;
		this.codeModeOnly = codeModeOnly;
		this.standaloneWebSearch = standaloneWebSearch;
		this.imageGeneration = imageGeneration;
		this.imageGenExt = imageGenExt;
		this.deferredToolsAvailable = deferredToolsAvailable;
	}
}
