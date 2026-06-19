package codexhx.tools.registry;

class ToolKind {
	public static inline final LocalFunction = "local_function";
	public static inline final Mcp = "mcp";
	public static inline final Dynamic = "dynamic";

	public static function isValid(value:String):Bool {
		return value == LocalFunction || value == Mcp || value == Dynamic;
	}
}
