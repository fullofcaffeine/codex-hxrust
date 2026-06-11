import codexhx.protocol.ModelId;
import codexhx.protocol.PathLikeId;
import codexhx.protocol.RequestId;
import codexhx.protocol.RequestIds;
import codexhx.protocol.SessionId;
import codexhx.protocol.ThreadId;
import codexhx.protocol.ToolCallId;
import codexhx.protocol.TurnId;

class ProtocolIdsHarness {
    static function main():Void {
        sessionAndThreadIdsRoundTrip();
        uuidIdsRejectInvalidValues();
        scalarIdsSerializeDeterministically();
        scalarIdsRejectEmptyAndControlCharacters();
        requestIdsMatchJsonRpcScalarShape();
    }

    static function sessionAndThreadIdsRoundTrip():Void {
        final uuidUpper = "67E55044-10B1-426F-9247-BB680E5FE0C8";
        final uuidLower = "67e55044-10b1-426f-9247-bb680e5fe0c8";
        final session = expectSession(SessionId.fromString(uuidUpper));
        assertEquals(uuidLower, session.toString());
        assertEquals("\"" + uuidLower + "\"", session.toJsonString());

        final thread = ThreadId.fromSessionId(session);
        assertEquals(uuidLower, thread.toString());
        assertTrue(thread.toSessionId().equals(session), "thread/session conversion should preserve UUID");
    }

    static function uuidIdsRejectInvalidValues():Void {
        assertNullSession(SessionId.fromString(""));
        assertNullThread(ThreadId.fromString("not-a-uuid"));
        assertNullThread(ThreadId.fromString("67e55044-10b1-426f-9247-bb680e5fe0cz"));
    }

    static function scalarIdsSerializeDeterministically():Void {
        assertEquals("\"turn-1\"", expectTurn(TurnId.fromString("turn-1")).toJsonString());
        assertEquals("\"call21\"", expectToolCall(ToolCallId.fromString("call21")).toJsonString());
        assertEquals("\"gpt-5.2-codex\"", expectModel(ModelId.fromString("gpt-5.2-codex")).toJsonString());
        assertEquals("\"/tmp/ig-1.png\"", expectPath(PathLikeId.fromString("/tmp/ig-1.png")).toJsonString());
        assertEquals("\"quote\\\"slash\\\\\"", expectToolCall(ToolCallId.fromString("quote\"slash\\")).toJsonString());
    }

    static function scalarIdsRejectEmptyAndControlCharacters():Void {
        assertNullTurn(TurnId.fromString(""));
        assertNullToolCall(ToolCallId.fromString("call\n1"));
        assertNullModel(ModelId.fromString("model\t1"));
        assertNullPath(PathLikeId.fromString("path\r1"));
    }

    static function requestIdsMatchJsonRpcScalarShape():Void {
        final stringId = expectRequest(RequestIds.fromString("req-1"));
        final intId = RequestIds.fromInteger(42);

        assertEquals("req-1", RequestIds.toString(stringId));
        assertEquals("\"req-1\"", RequestIds.toJsonScalar(stringId));
        assertEquals("42", RequestIds.toString(intId));
        assertEquals("42", RequestIds.toJsonScalar(intId));
    }

    static function expectSession(value:Null<SessionId>):SessionId return value == null ? throw "expected SessionId" : value;
    static function expectThread(value:Null<ThreadId>):ThreadId return value == null ? throw "expected ThreadId" : value;
    static function expectTurn(value:Null<TurnId>):TurnId return value == null ? throw "expected TurnId" : value;
    static function expectToolCall(value:Null<ToolCallId>):ToolCallId return value == null ? throw "expected ToolCallId" : value;
    static function expectModel(value:Null<ModelId>):ModelId return value == null ? throw "expected ModelId" : value;
    static function expectPath(value:Null<PathLikeId>):PathLikeId return value == null ? throw "expected PathLikeId" : value;
    static function expectRequest(value:Null<RequestId>):RequestId return value == null ? throw "expected RequestId" : value;

    static function assertNullSession(value:Null<SessionId>):Void if (value != null) throw "expected null SessionId";
    static function assertNullThread(value:Null<ThreadId>):Void if (value != null) throw "expected null ThreadId";
    static function assertNullTurn(value:Null<TurnId>):Void if (value != null) throw "expected null TurnId";
    static function assertNullToolCall(value:Null<ToolCallId>):Void if (value != null) throw "expected null ToolCallId";
    static function assertNullModel(value:Null<ModelId>):Void if (value != null) throw "expected null ModelId";
    static function assertNullPath(value:Null<PathLikeId>):Void if (value != null) throw "expected null PathLikeId";

    static function assertEquals(expected:String, actual:String):Void {
        if (expected != actual) {
            throw "expected `" + expected + "`, got `" + actual + "`";
        }
    }

    static function assertTrue(value:Bool, message:String):Void {
        if (!value) {
            throw message;
        }
    }
}
