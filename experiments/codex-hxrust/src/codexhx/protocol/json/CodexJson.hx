package codexhx.protocol.json;

import haxe.Json;
import haxe.json.Value;

class CodexJson {
    public static function parse(text:String):JsonParseOutcome {
        #if reflaxe_rust_profile
        return JsonParseOutcome.success(Json.parseValue(text));
        #else
        return JsonParseOutcome.success(dynamicToValue(Json.parse(text)));
        #end
    }

    public static function field(object:Value, name:String, path:String):JsonFieldOutcome {
        return switch object {
            case JObject(keys, values):
                var i = 0;
                while (i < keys.length) {
                    if (keys[i] == name) {
                        return JsonFieldOutcome.found(values[i]);
                    }
                    i = i + 1;
                }
                JsonFieldOutcome.failure("missing_field", path + "." + name, "required field is missing");
            case _:
                JsonFieldOutcome.failure("expected_object", path, "expected JSON object");
        }
    }

    public static function stringField(object:Value, name:String, path:String):StringOutcome {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) {
                    StringOutcome.failure("missing_field", path + "." + name, "required field is missing");
                } else switch values[i] {
            case JString(value): StringOutcome.success(value);
                    case _: StringOutcome.failure("expected_string", path + "." + name, "expected JSON string");
                }
            case _:
                StringOutcome.failure("expected_object", path, "expected JSON object");
        }
    }

    public static function boolField(object:Value, name:String, path:String):BoolOutcome {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) {
                    BoolOutcome.failure("missing_field", path + "." + name, "required field is missing");
                } else switch values[i] {
            case JBool(value): BoolOutcome.success(value);
                    case _: BoolOutcome.failure("expected_bool", path + "." + name, "expected JSON boolean");
                }
            case _:
                BoolOutcome.failure("expected_object", path, "expected JSON object");
        }
    }

    public static function numberField(object:Value, name:String, path:String):NumberOutcome {
        return switch object {
            case JObject(keys, values):
                final i = fieldIndex(keys, name);
                if (i < 0) {
                    NumberOutcome.failure("missing_field", path + "." + name, "required field is missing");
                } else switch values[i] {
            case JNumber(value): NumberOutcome.success(value);
                    case _: NumberOutcome.failure("expected_number", path + "." + name, "expected JSON number");
                }
            case _:
                NumberOutcome.failure("expected_object", path, "expected JSON object");
        }
    }

    public static function unknownFields(object:Value, allowed:Array<String>):Array<String> {
        return switch object {
            case JObject(keys, _):
                final unknown:Array<String> = [];
                for (key in keys) {
                    if (!contains(allowed, key)) {
                        unknown.push(key);
                    }
                }
                unknown;
            case _:
                [];
        }
    }

    public static function encodeStringObject(keys:Array<String>, values:Array<String>):String {
        final parts:Array<String> = [];
        var i = 0;
        while (i < keys.length && i < values.length) {
            parts.push(quote(keys[i]) + ":" + quote(values[i]));
            i = i + 1;
        }
        return "{" + parts.join(",") + "}";
    }

    public static function quote(value:String):String {
        return codexhx.protocol.JsonScalar.quote(value);
    }

    static function contains(values:Array<String>, needle:String):Bool {
        for (value in values) {
            if (value == needle) {
                return true;
            }
        }
        return false;
    }

    static function fieldIndex(keys:Array<String>, name:String):Int {
        var i = 0;
        while (i < keys.length) {
            if (keys[i] == name) {
                return i;
            }
            i = i + 1;
        }
        return -1;
    }

    #if !reflaxe_rust_profile
    static function dynamicToValue(value:Dynamic):Value {
        if (value == null) {
            return JNull;
        }
        if (Std.isOfType(value, Bool)) {
            return JBool(cast value);
        }
        if (Std.isOfType(value, Int) || Std.isOfType(value, Float)) {
            return JNumber(cast value);
        }
        if (Std.isOfType(value, String)) {
            return JString(cast value);
        }
        if (Std.isOfType(value, Array)) {
            final input:Array<Dynamic> = cast value;
            final out:Array<Value> = [];
            for (entry in input) {
                out.push(dynamicToValue(entry));
            }
            return JArray(out);
        }

        final keys = Reflect.fields(value);
        final values:Array<Value> = [];
        for (key in keys) {
            values.push(dynamicToValue(Reflect.field(value, key)));
        }
        return JObject(keys, values);
    }
    #end
}
