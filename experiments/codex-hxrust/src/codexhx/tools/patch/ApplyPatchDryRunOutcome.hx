package codexhx.tools.patch;

import codexhx.protocol.JsonScalar;

class ApplyPatchDryRunOutcome {
    public static inline final schema = "codex-hxrust.apply-patch-dry-run.v1";

    public final ok:Bool;
    public final mutationEnabled:Bool;
    public final wouldMutate:Bool;
    public final errorCode:String;
    public final errorPath:String;
    public final errorMessage:String;
    public final operations:Array<ApplyPatchOperation>;

    public function new(ok:Bool, mutationEnabled:Bool, wouldMutate:Bool, errorCode:String, errorPath:String, errorMessage:String, operations:Array<ApplyPatchOperation>) {
        this.ok = ok;
        this.mutationEnabled = mutationEnabled;
        this.wouldMutate = wouldMutate;
        this.errorCode = errorCode;
        this.errorPath = errorPath;
        this.errorMessage = errorMessage;
        this.operations = operations;
    }

    public static function success(operations:Array<ApplyPatchOperation>):ApplyPatchDryRunOutcome {
        return new ApplyPatchDryRunOutcome(true, false, operations.length > 0, "", "", "", operations);
    }

    public static function failure(errorCode:String, errorPath:String, errorMessage:String):ApplyPatchDryRunOutcome {
        return new ApplyPatchDryRunOutcome(false, false, false, errorCode, errorPath, errorMessage, []);
    }

    public function json():String {
        var out = "{";
        out += "\"schema\":" + quote(schema);
        out += ",\"ok\":" + bool(ok);
        out += ",\"mutationEnabled\":" + bool(mutationEnabled);
        out += ",\"wouldMutate\":" + bool(wouldMutate);
        out += ",\"errorCode\":" + quote(errorCode);
        out += ",\"errorPath\":" + quote(errorPath);
        out += ",\"errorMessage\":" + quote(errorMessage);
        out += ",\"operationCount\":" + Std.string(operations.length);
        out += ",\"operations\":[";
        for (i in 0...operations.length) {
            if (i > 0) out += ",";
            out += operationJson(operations[i]);
        }
        out += "]";
        out += "}";
        return out;
    }

    static function operationJson(operation:ApplyPatchOperation):String {
        var out = "{";
        out += "\"kind\":" + quote(operation.kind);
        out += ",\"path\":" + quote(operation.path);
        out += ",\"moveTo\":" + nullableString(operation.moveTo);
        out += ",\"additions\":" + Std.string(operation.additions);
        out += ",\"deletions\":" + Std.string(operation.deletions);
        out += ",\"context\":" + Std.string(operation.context);
        out += "}";
        return out;
    }

    static function nullableString(value:String):String {
        if (value == "") return "null";
        return quote(value);
    }

    static function quote(value:String):String {
        return JsonScalar.quote(value);
    }

    static function bool(value:Bool):String {
        if (value) return "true";
        return "false";
    }
}
