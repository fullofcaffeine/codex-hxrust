package codexhx.protocol;

class IdValidation {
    public static function parseUuid(value:String):Null<String> {
        if (!isUuid(value)) {
            return null;
        }
        return value.toLowerCase();
    }

    public static function parseNonEmptyScalar(value:String):Null<String> {
        if (!isNonEmptyScalar(value)) {
            return null;
        }
        return value;
    }

    public static function isUuid(value:String):Bool {
        if (value == null || value.length == 0) {
            return false;
        }
        if (value.length != 36) {
            return false;
        }

        for (i in 0...value.length) {
            final char = value.charAt(i);
            if (i == 8 || i == 13 || i == 18 || i == 23) {
                if (char != "-") {
                    return false;
                }
            } else if (!isHex(char)) {
                return false;
            }
        }

        return true;
    }

    public static function isNonEmptyScalar(value:String):Bool {
        if (value == null || value.length == 0) {
            return false;
        }

        for (i in 0...value.length) {
            final char = value.charAt(i);
            if (char == "\n" || char == "\r" || char == "\t") {
                return false;
            }
        }

        return true;
    }

    static function isHex(char:String):Bool {
        return (char >= "0" && char <= "9")
            || (char >= "a" && char <= "f")
            || (char >= "A" && char <= "F");
    }
}
