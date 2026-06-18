package codexhx.runtime.tui.smoke;

enum abstract TuiSmokeComposerAttachmentActionKind(String) to String {
	final HandlePaste = "handle_paste";
	final PasteBurstChar = "paste_burst_char";
	final PasteBurstFlush = "paste_burst_flush";
	final LargePastePlaceholder = "large_paste_placeholder";
	final ExpandPendingPastes = "expand_pending_pastes";
	final AttachLocalImage = "attach_local_image";
	final SetRemoteImages = "set_remote_images";
	final SelectRemoteImage = "select_remote_image";
	final DeleteRemoteImage = "delete_remote_image";
	final SnapshotDraft = "snapshot_draft";
	final RestoreDraft = "restore_draft";
	final ApplyHistoryEntry = "apply_history_entry";
	final PrepareSubmission = "prepare_submission";
	final DrainSubmission = "drain_submission";
	final InsertSelectedFile = "insert_selected_file";
	final FrameSchedule = "frame_schedule";
	final Failure = "failure";
	final Unknown = "unknown";

	public static function fromString(value:String):TuiSmokeComposerAttachmentActionKind {
		return switch value {
			case "handle_paste": HandlePaste;
			case "paste_burst_char": PasteBurstChar;
			case "paste_burst_flush": PasteBurstFlush;
			case "large_paste_placeholder": LargePastePlaceholder;
			case "expand_pending_pastes": ExpandPendingPastes;
			case "attach_local_image": AttachLocalImage;
			case "set_remote_images": SetRemoteImages;
			case "select_remote_image": SelectRemoteImage;
			case "delete_remote_image": DeleteRemoteImage;
			case "snapshot_draft": SnapshotDraft;
			case "restore_draft": RestoreDraft;
			case "apply_history_entry": ApplyHistoryEntry;
			case "prepare_submission": PrepareSubmission;
			case "drain_submission": DrainSubmission;
			case "insert_selected_file": InsertSelectedFile;
			case "frame_schedule": FrameSchedule;
			case "failure": Failure;
			case _: Unknown;
		}
	}
}
