package codexhx.runtime.model.planning;

enum abstract TurnModelToolCapabilityKind(String) to String {
	public var HostedWebSearch = "hosted_web_search";
	public var StandaloneWebRun = "standalone_web_run";
	public var HostedImageGeneration = "hosted_image_generation";
	public var StandaloneImageGeneration = "standalone_image_generation";
	public var NamespaceTools = "namespace_tools";
	public var CodeModeNestedTools = "code_mode_nested_tools";
	public var ToolSearch = "tool_search";
}
