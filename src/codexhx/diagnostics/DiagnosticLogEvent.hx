package codexhx.diagnostics;

import codexhx.protocol.JsonScalar;

class DiagnosticLogEvent {
    public static inline final schema = "codex-hxrust.diagnostic-log.v1";

    public final level:String;
    public final event:String;
    public final fixtureId:String;
    public final fields:Array<DiagnosticField>;

    public function new(level:String, event:String, fixtureId:String, fields:Array<DiagnosticField>) {
        this.level = level;
        this.event = event;
        this.fixtureId = fixtureId;
        this.fields = fields;
    }

    public function json(redactor:DiagnosticRedactor):String {
        var out = "{";
        out += "\"schema\":" + quote(schema);
        out += ",\"level\":" + quote(level);
        out += ",\"event\":" + quote(event);
        out += ",\"fixtureId\":" + quote(fixtureId);
        out += ",\"fields\":[";
        for (i in 0...fields.length) {
            if (i > 0) out += ",";
            final field = fields[i];
            final redacted = redactor.isSecret(field.name);
            out += "{"
                + "\"name\":" + quote(field.name)
                + ",\"value\":" + quote(redactor.redact(field.name, field.value))
                + ",\"redacted\":" + bool(redacted)
                + "}";
        }
        out += "]";
        out += "}";
        return out;
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
