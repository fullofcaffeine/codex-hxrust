package codexhx.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * Converts selected compiler defines into typed constants in generated code.
 *
 * The build runner uses this boundary to record the compiler checkout that
 * produced an artifact. Macro-only compiler APIs do not enter runtime code.
 */
class BuildDefine {
	public static macro function stringValue(name:String, fallback:String):ExprOf<String> {
		final value = Context.definedValue(name);
		if (value == null) {
			return macro $v{fallback};
		}
		return macro $v{value};
	}
}
