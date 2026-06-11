package codexhx.protocol.json;

import haxe.json.Value;

class JsonValueCodec {
    public static function encode(value:Value):String {
        return switch value {
            case JNull:
                "null";
            case JBool(v):
                if (v) "true" else "false";
            case JNumber(v):
                Std.string(v);
            case JString(v):
                CodexJson.quote(v);
            case JArray(entries):
                final parts:Array<String> = [];
                for (entry in entries) {
                    parts.push(encode(entry));
                }
                "[" + parts.join(",") + "]";
            case JObject(keys, values):
                final fields:Array<JsonObjectField> = [];
                var i = 0;
                while (i < keys.length && i < values.length) {
                    fields.push(new JsonObjectField(keys[i], values[i]));
                    i = i + 1;
                }
                fields.sort(compareFields);
                final parts:Array<String> = [];
                for (field in fields) {
                    parts.push(CodexJson.quote(field.key) + ":" + encode(field.value));
                }
                "{" + parts.join(",") + "}";
        }
    }

    static function compareFields(a:JsonObjectField, b:JsonObjectField):Int {
        if (a.key < b.key) return -1;
        if (a.key > b.key) return 1;
        return 0;
    }
}

class JsonObjectField {
    public final key:String;
    public final value:Value;

    public function new(key:String, value:Value) {
        this.key = key;
        this.value = value;
    }
}
