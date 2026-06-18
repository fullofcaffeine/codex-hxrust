package codexhx.macros;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;
#end

class FieldRecordConstructor {
#if macro
	public static function build():Array<Field> {
		final fields = Context.getBuildFields();
		for (field in fields) {
			if (field.name == "new") {
				return fields;
			}
		}

		final localClass = Context.getLocalClass().get();
		final pos = Context.currentPos();
		final assignments:Array<Expr> = [];

		for (field in fields) {
			switch field.kind {
				case FVar(type, _):
					if (hasAccess(field, AStatic)) {
						continue;
					}
					assignments.push(assignField(field, type, pos));
				case _:
			}
		}

		fields.push({
			name: "new",
			access: [APublic],
			kind: FFun({
				args: [
					{
						name: "fields",
						type: TPath({
							pack: localClass.pack,
							name: localClass.name + "Fields"
						})
					}
				],
				ret: null,
				expr: {expr: EBlock(assignments), pos: pos}
			}),
			pos: pos
		});

		return fields;
	}

	static function assignField(field:Field, type:Null<ComplexType>, pos:Position):Expr {
		final name = field.name;
		final target = fieldAccess(macro this, name, pos);
		final source = fieldAccess(macro fields, name, pos);
		final value = normalizedSource(defaultedSource(source, type, explicitDefault(field), pos), field, pos);
		return {expr: EBinop(OpAssign, target, value), pos: pos};
	}

	static function explicitDefault(field:Field):Null<Expr> {
		if (field.meta == null) {
			return null;
		}
		for (meta in field.meta) {
			if ((meta.name == ":recordDefault" || meta.name == "recordDefault") && meta.params.length == 1) {
				return meta.params[0];
			}
		}
		return null;
	}

	static function defaultedSource(source:Expr, type:Null<ComplexType>, explicit:Null<Expr>, pos:Position):Expr {
		if (explicit != null) {
			return nullCoalesce(source, explicit, pos);
		}

		return switch type {
			case TPath({pack: [], name: "String"}):
				nullCoalesce(source, macro "", pos);
			case TPath({pack: [], name: "Array"}):
				nullCoalesce(source, macro [], pos);
			case TPath({pack: [], name: "Bool" | "Int" | "Float"}):
				source;
			case TPath({pack: [], name: "Null"}):
				source;
			case TPath(path):
				nullCoalesce(source, unknownValue(path, pos), pos);
			case _:
				source;
		}
	}

	static function normalizedSource(source:Expr, field:Field, pos:Position):Expr {
		final min = recordMin(field);
		if (min != null) {
			return {
				expr: EIf({
					expr: EBinop(OpLt, source, min),
					pos: pos
				}, min, source),
				pos: pos
			};
		}
		return source;
	}

	static function recordMin(field:Field):Null<Expr> {
		if (field.meta == null) {
			return null;
		}
		for (meta in field.meta) {
			if ((meta.name == ":recordMin" || meta.name == "recordMin") && meta.params.length == 1) {
				return meta.params[0];
			}
		}
		return null;
	}

	static function unknownValue(path:TypePath, pos:Position):Expr {
		return {
			expr: EField({
				expr: path.pack.length == 0
					? EConst(CIdent(path.name))
					: EField(drill(path.pack, pos), path.name),
				pos: pos
			}, "Unknown"),
			pos: pos
		};
	}

	static function drill(parts:Array<String>, pos:Position):Expr {
		var out:Expr = {expr: EConst(CIdent(parts[0])), pos: pos};
		for (i in 1...parts.length) {
			out = {expr: EField(out, parts[i]), pos: pos};
		}
		return out;
	}

	static function nullCoalesce(value:Expr, fallback:Expr, pos:Position):Expr {
		return {
			expr: EIf({
				expr: EBinop(OpEq, value, macro null),
				pos: pos
			}, fallback, value),
			pos: pos
		};
	}

	static function fieldAccess(base:Expr, name:String, pos:Position):Expr {
		return {
			expr: EField(base, name),
			pos: pos
		};
	}

	static function hasAccess(field:Field, access:Access):Bool {
		if (field.access == null) {
			return false;
		}
		for (item in field.access) {
			if (item == access) {
				return true;
			}
		}
		return false;
	}
#end
}
