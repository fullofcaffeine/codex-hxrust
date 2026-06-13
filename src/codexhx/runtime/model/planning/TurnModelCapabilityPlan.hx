package codexhx.runtime.model.planning;

class TurnModelCapabilityPlan {
	public final hostedWebSearch:Bool;
	public final hostedWebSearchExternalAccess:String;
	public final hostedWebSearchContentTypes:String;
	public final standaloneWebRun:Bool;
	public final hostedImageGeneration:Bool;
	public final standaloneImageGeneration:Bool;
	public final namespaceTools:Bool;
	public final codeModeNestedTools:Bool;
	public final toolSearch:Bool;

	public function new(
		hostedWebSearch:Bool,
		hostedWebSearchExternalAccess:String,
		hostedWebSearchContentTypes:String,
		standaloneWebRun:Bool,
		hostedImageGeneration:Bool,
		standaloneImageGeneration:Bool,
		namespaceTools:Bool,
		codeModeNestedTools:Bool,
		toolSearch:Bool
	) {
		this.hostedWebSearch = hostedWebSearch;
		this.hostedWebSearchExternalAccess = hostedWebSearchExternalAccess;
		this.hostedWebSearchContentTypes = hostedWebSearchContentTypes;
		this.standaloneWebRun = standaloneWebRun;
		this.hostedImageGeneration = hostedImageGeneration;
		this.standaloneImageGeneration = standaloneImageGeneration;
		this.namespaceTools = namespaceTools;
		this.codeModeNestedTools = codeModeNestedTools;
		this.toolSearch = toolSearch;
	}

	public function enabled(kind:TurnModelToolCapabilityKind):Bool {
		return switch kind {
			case TurnModelToolCapabilityKind.HostedWebSearch: hostedWebSearch;
			case TurnModelToolCapabilityKind.StandaloneWebRun: standaloneWebRun;
			case TurnModelToolCapabilityKind.HostedImageGeneration: hostedImageGeneration;
			case TurnModelToolCapabilityKind.StandaloneImageGeneration: standaloneImageGeneration;
			case TurnModelToolCapabilityKind.NamespaceTools: namespaceTools;
			case TurnModelToolCapabilityKind.CodeModeNestedTools: codeModeNestedTools;
			case TurnModelToolCapabilityKind.ToolSearch: toolSearch;
		}
	}

	public function summary():String {
		return "hostedWebSearch=" + boolText(hostedWebSearch)
			+ ";hostedWebSearchExternalAccess=" + hostedWebSearchExternalAccess
			+ ";hostedWebSearchContentTypes=" + hostedWebSearchContentTypes
			+ ";standaloneWebRun=" + boolText(standaloneWebRun)
			+ ";hostedImageGeneration=" + boolText(hostedImageGeneration)
			+ ";standaloneImageGeneration=" + boolText(standaloneImageGeneration)
			+ ";namespaceTools=" + boolText(namespaceTools)
			+ ";codeModeNestedTools=" + boolText(codeModeNestedTools)
			+ ";toolSearch=" + boolText(toolSearch);
	}

	static function boolText(value:Bool):String {
		return value ? "true" : "false";
	}
}
