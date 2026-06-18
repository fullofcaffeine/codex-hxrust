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
		return {expr: EBinop(OpAssign, target, defaultedSource(source, type, explicitDefault(field), pos)), pos: pos};
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
			case _:
				source;
		}
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
