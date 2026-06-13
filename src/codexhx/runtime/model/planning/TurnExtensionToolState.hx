package codexhx.runtime.model.planning;

class TurnExtensionToolState {
	public final standaloneWebRunAvailable:Bool;
	public final standaloneImageGenerationAvailable:Bool;

	public function new(standaloneWebRunAvailable:Bool, standaloneImageGenerationAvailable:Bool) {
		this.standaloneWebRunAvailable = standaloneWebRunAvailable;
		this.standaloneImageGenerationAvailable = standaloneImageGenerationAvailable;
	}
}
