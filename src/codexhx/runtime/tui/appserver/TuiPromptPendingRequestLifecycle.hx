package codexhx.runtime.tui.appserver;

import codexhx.protocol.RequestId;

/**
	Typed prompt pending-request lifecycle observed by the fake app-server
	facade.
**/
class TuiPromptPendingRequestLifecycle {
	public final status:TuiPromptPendingRequestStatus;
	public final requestId:Null<RequestId>;
	public final method:TuiAppServerRequestMethod;
	public final pendingBefore:Int;
	public final pendingAfter:Int;

	public function new(status:TuiPromptPendingRequestStatus, requestId:Null<RequestId>, method:TuiAppServerRequestMethod, pendingBefore:Int,
			pendingAfter:Int) {
		this.status = status;
		this.requestId = requestId;
		this.method = method;
		this.pendingBefore = pendingBefore < 0 ? 0 : pendingBefore;
		this.pendingAfter = pendingAfter < 0 ? 0 : pendingAfter;
	}

	public static function none():TuiPromptPendingRequestLifecycle {
		return new TuiPromptPendingRequestLifecycle(TuiPromptPendingRequestStatus.None, null, TuiAppServerRequestMethod.PromptSubmit, 0, 0);
	}

	public static function registered(requestId:RequestId, pendingBefore:Int, pendingAfter:Int):TuiPromptPendingRequestLifecycle {
		return new TuiPromptPendingRequestLifecycle(TuiPromptPendingRequestStatus.Registered, requestId, TuiAppServerRequestMethod.PromptSubmit,
			pendingBefore, pendingAfter);
	}

	public static function resolved(requestId:RequestId, pendingBefore:Int, pendingAfter:Int):TuiPromptPendingRequestLifecycle {
		return new TuiPromptPendingRequestLifecycle(TuiPromptPendingRequestStatus.Resolved, requestId, TuiAppServerRequestMethod.PromptSubmit, pendingBefore,
			pendingAfter);
	}

	public static function rejected(requestId:RequestId, pendingBefore:Int, pendingAfter:Int):TuiPromptPendingRequestLifecycle {
		return new TuiPromptPendingRequestLifecycle(TuiPromptPendingRequestStatus.Rejected, requestId, TuiAppServerRequestMethod.PromptSubmit, pendingBefore,
			pendingAfter);
	}

	public function statusText():String {
		return status.text();
	}

	public function requestIdText():String {
		return requestId == null ? "" : requestId.toString();
	}

	public function methodText():String {
		return switch method {
			case AttachSession:
				"attach_session";
			case PromptSubmit:
				"prompt_submit";
		}
	}
}
