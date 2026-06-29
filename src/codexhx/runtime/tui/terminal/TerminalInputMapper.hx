package codexhx.runtime.tui.terminal;

/**
	Maps backend key facts into strict Haxe input events.
**/
class TerminalInputMapper {
	public static inline final PollNone:Int = 0;
	public static inline final PollCharacter:Int = 1;
	public static inline final PollEnter:Int = 2;
	public static inline final PollEscape:Int = 3;
	public static inline final PollCtrlC:Int = 4;
	public static inline final PollBackspace:Int = 5;
	public static inline final PollArrowUp:Int = 6;
	public static inline final PollArrowDown:Int = 7;
	public static inline final PollArrowLeft:Int = 8;
	public static inline final PollArrowRight:Int = 9;
	public static inline final PollAgentPrevious:Int = 10;
	public static inline final PollAgentNext:Int = 11;

	public static function terminalEventFromNativePoll(code:Int, text:String):TerminalEvent {
		return switch code {
			case PollCharacter:
				TerminalEvent.Key(TerminalKey.Character(text));
			case PollEnter:
				TerminalEvent.Key(TerminalKey.Enter);
			case PollEscape:
				TerminalEvent.Key(TerminalKey.Escape);
			case PollCtrlC:
				TerminalEvent.Key(TerminalKey.CtrlC);
			case PollBackspace:
				TerminalEvent.Key(TerminalKey.Backspace);
			case PollArrowUp:
				TerminalEvent.Key(TerminalKey.ArrowUp);
			case PollArrowDown:
				TerminalEvent.Key(TerminalKey.ArrowDown);
			case PollArrowLeft:
				TerminalEvent.Key(TerminalKey.ArrowLeft);
			case PollArrowRight:
				TerminalEvent.Key(TerminalKey.ArrowRight);
			case PollAgentPrevious:
				TerminalEvent.Key(TerminalKey.AgentPrevious);
			case PollAgentNext:
				TerminalEvent.Key(TerminalKey.AgentNext);
			case _:
				TerminalEvent.NoEvent;
		}
	}

	public static function inputFromTerminalKey(key:TerminalKey):TerminalInputEvent {
		return switch key {
			case Character(value):
				TerminalInputEvent.Text(value);
			case Enter:
				TerminalInputEvent.Submit;
			case Escape:
				TerminalInputEvent.Cancel;
			case CtrlC:
				TerminalInputEvent.Interrupt;
			case Backspace:
				TerminalInputEvent.DeleteBackward;
			case ArrowUp:
				TerminalInputEvent.HistoryPrevious;
			case ArrowDown:
				TerminalInputEvent.HistoryNext;
			case ArrowLeft:
				TerminalInputEvent.MoveLeft;
			case ArrowRight:
				TerminalInputEvent.MoveRight;
			case AgentPrevious:
				TerminalInputEvent.AgentPrevious;
			case AgentNext:
				TerminalInputEvent.AgentNext;
		}
	}
}
