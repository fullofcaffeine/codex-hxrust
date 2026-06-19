package codexhx.runtime.tui.smoke;

typedef TuiSmokeClipboardPasteActionFields = {
	final kind:TuiSmokeClipboardPasteActionKind;
	final source:String;
	final errorKind:String;
	final wslSession:Bool;
	final nativeClipboardAvailable:Bool;
	final nativeImageAvailable:Bool;
	final nativeFileAvailable:Bool;
	final wslFallbackAttempted:Bool;
	final wslFallbackSucceeded:Bool;
	final windowsPath:String;
	final wslPath:String;
	final tempPath:String;
	final width:Int;
	final height:Int;
	final format:String;
	final imageBytes:Int;
	final maxImageBytes:Int;
	final placeholder:String;
	final remoteImageCount:Int;
	final localImageCountBefore:Int;
	final localImageCountAfter:Int;
	final insertedPlaceholder:Bool;
	final expectedDecision:String;
	final liveClipboardAllowed:Bool;
	final processSpawnAllowed:Bool;
	final filesystemMutationAllowed:Bool;
	final failureCode:String;
}

@:build(codexhx.macros.FieldRecordConstructor.build())
class TuiSmokeClipboardPasteAction {
	public final kind:TuiSmokeClipboardPasteActionKind;
	public final source:String;
	public final errorKind:String;
	public final wslSession:Bool;
	public final nativeClipboardAvailable:Bool;
	public final nativeImageAvailable:Bool;
	public final nativeFileAvailable:Bool;
	public final wslFallbackAttempted:Bool;
	public final wslFallbackSucceeded:Bool;
	public final windowsPath:String;
	public final wslPath:String;
	public final tempPath:String;
	@:recordMin(0)
	public final width:Int;
	@:recordMin(0)
	public final height:Int;
	public final format:String;
	@:recordMin(0)
	public final imageBytes:Int;
	@:recordMin(1)
	public final maxImageBytes:Int;
	public final placeholder:String;
	@:recordMin(0)
	public final remoteImageCount:Int;
	@:recordMin(0)
	public final localImageCountBefore:Int;
	@:recordMin(0)
	public final localImageCountAfter:Int;
	public final insertedPlaceholder:Bool;
	public final expectedDecision:String;
	public final liveClipboardAllowed:Bool;
	public final processSpawnAllowed:Bool;
	public final filesystemMutationAllowed:Bool;
	public final failureCode:String;

	public function computedDecision():String {
		return switch kind {
			case TuiSmokeClipboardPasteActionKind.Probe:
				if (nativeFileAvailable || nativeImageAvailable) "native"; else if (wslSession && wslFallbackSucceeded) "wsl_fallback"; else
					if (errorKind.length > 0) "error_"
					+ errorKind; else "no_image";
			case TuiSmokeClipboardPasteActionKind.ImageAccept:
				if (imageBytes > maxImageBytes) "refuse_oversized"; else if (source.length == 0 || source == "none") "refuse_no_image"; else "accept_" + source;
			case TuiSmokeClipboardPasteActionKind.Refusal:
				"refuse_" + normalizedErrorKind();
			case TuiSmokeClipboardPasteActionKind.WslPath:
				wslPathMatches() ? "wsl_path" : "wsl_path_mismatch";
			case TuiSmokeClipboardPasteActionKind.Failure:
				failureCode;
			case _:
				"unknown";
		}
	}

	public function decisionMatches():Bool {
		return expectedDecision == "" || computedDecision() == expectedDecision;
	}

	public function computedPlaceholder():String {
		return "[Image #" + Std.string(remoteImageCount + localImageCountBefore + 1) + "]";
	}

	public function placeholderMatches():Bool {
		return placeholder == "" || placeholder == computedPlaceholder();
	}

	public function localImageCountMatches():Bool {
		final expected = insertedPlaceholder ? localImageCountBefore + 1 : localImageCountBefore;
		return localImageCountAfter == expected;
	}

	public function formatLabel():String {
		final normalized = format.toLowerCase();
		if (normalized == "png")
			return "PNG";
		if (normalized == "jpeg" || normalized == "jpg")
			return "JPEG";
		return "IMG";
	}

	public function computedWslPath():String {
		if (windowsPath.length < 3)
			return "";
		if (windowsPath.charAt(1) != ":" || windowsPath.charAt(2) != "\\")
			return "";
		final drive = windowsPath.charAt(0).toLowerCase();
		final rest = StringTools.replace(windowsPath.substr(3), "\\", "/");
		return "/mnt/" + drive + "/" + rest;
	}

	public function wslPathMatches():Bool {
		return wslPath == "" || computedWslPath() == wslPath;
	}

	function normalizedErrorKind():String {
		return errorKind.length == 0 ? "unknown" : errorKind;
	}
}
