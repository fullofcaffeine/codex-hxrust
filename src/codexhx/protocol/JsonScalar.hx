package codexhx.protocol;

class JsonScalar {
    public static function quote(value:String):String {
        var out = "\"";
        for (i in 0...value.length) {
            final code = value.charCodeAt(i);
            if (code == "\"".code) {
                out += "\\\"";
            } else if (code == "\\".code) {
                out += "\\\\";
            } else if (code == "\n".code) {
                out += "\\n";
            } else if (code == "\r".code) {
                out += "\\r";
            } else if (code == "\t".code) {
                out += "\\t";
            } else {
                out += value.charAt(i);
            }
        }
        return out + "\"";
    }
}
