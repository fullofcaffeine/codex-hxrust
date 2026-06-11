package codexhx.tools.patch;

class ApplyPatchDryRun {
    public static function run(patch:String, mutationRequested:Bool):ApplyPatchDryRunOutcome {
        if (mutationRequested) {
            return ApplyPatchDryRunOutcome.failure("mutation_disabled", "$.mutationRequested", "apply-patch mutation is disabled by default; run dry-run first");
        }

        final text = trimTrailingNewline(normalizeNewlines(patch));
        final lines = text.split("\n");
        if (lines.length < 2 || lines[0] != "*** Begin Patch") {
            return ApplyPatchDryRunOutcome.failure("invalid_patch_header", "$.patch.line[1]", "patch must start with *** Begin Patch");
        }
        if (lines[lines.length - 1] != "*** End Patch") {
            return ApplyPatchDryRunOutcome.failure("invalid_patch_footer", "$.patch.line[" + Std.string(lines.length) + "]", "patch must end with *** End Patch");
        }

        final operations:Array<ApplyPatchOperation> = [];
        var i = 1;
        final end = lines.length - 1;
        while (i < end) {
            final line = lines[i];
            if (starts(line, "*** Add File: ")) {
                final path = line.substr("*** Add File: ".length);
                final pathError = validatePath(path, linePath(i));
                if (pathError != null) return pathError;
                i = i + 1;
                var additions = 0;
                while (i < end && !starts(lines[i], "*** ")) {
                    if (!starts(lines[i], "+")) {
                        return ApplyPatchDryRunOutcome.failure("invalid_add_line", linePath(i), "add file hunks may only contain + lines");
                    }
                    additions = additions + 1;
                    i = i + 1;
                }
                if (additions == 0) {
                    return ApplyPatchDryRunOutcome.failure("empty_add_hunk", linePath(i - 1), "add file hunk must contain at least one + line");
                }
                operations.push(new ApplyPatchOperation("add", path, "", additions, 0, 0));
            } else if (starts(line, "*** Delete File: ")) {
                final path = line.substr("*** Delete File: ".length);
                final pathError = validatePath(path, linePath(i));
                if (pathError != null) return pathError;
                i = i + 1;
                if (i < end && !starts(lines[i], "*** ")) {
                    return ApplyPatchDryRunOutcome.failure("unexpected_delete_body", linePath(i), "delete file hunks must not contain body lines");
                }
                operations.push(new ApplyPatchOperation("delete", path, "", 0, 0, 0));
            } else if (starts(line, "*** Update File: ")) {
                final path = line.substr("*** Update File: ".length);
                final pathError = validatePath(path, linePath(i));
                if (pathError != null) return pathError;
                i = i + 1;

                var moveTo = "";
                if (i < end && starts(lines[i], "*** Move to: ")) {
                    moveTo = lines[i].substr("*** Move to: ".length);
                    final moveError = validatePath(moveTo, linePath(i));
                    if (moveError != null) return moveError;
                    i = i + 1;
                }

                var additions = 0;
                var deletions = 0;
                var context = 0;
                var sawBody = false;
                while (i < end) {
                    final bodyLine = lines[i];
                    if (bodyLine == "*** End of File") {
                        i = i + 1;
                    } else if (starts(bodyLine, "*** ")) {
                        break;
                    } else if (starts(bodyLine, "@@")) {
                        i = i + 1;
                    } else if (starts(bodyLine, "+")) {
                        additions = additions + 1;
                        sawBody = true;
                        i = i + 1;
                    } else if (starts(bodyLine, "-")) {
                        deletions = deletions + 1;
                        sawBody = true;
                        i = i + 1;
                    } else if (starts(bodyLine, " ")) {
                        context = context + 1;
                        sawBody = true;
                        i = i + 1;
                    } else {
                        return ApplyPatchDryRunOutcome.failure("invalid_update_line", linePath(i), "update hunks may only contain @@, +, -, context, or EOF marker lines");
                    }
                }

                if (!sawBody && moveTo == "") {
                    return ApplyPatchDryRunOutcome.failure("empty_update_hunk", linePath(i - 1), "update file hunk must contain changes or a move target");
                }
                final kind = moveTo == "" ? "update" : "move";
                operations.push(new ApplyPatchOperation(kind, path, moveTo, additions, deletions, context));
            } else if (StringTools.trim(line) == "") {
                return ApplyPatchDryRunOutcome.failure("unexpected_blank_line", linePath(i), "blank lines are only allowed inside hunk bodies");
            } else {
                return ApplyPatchDryRunOutcome.failure("unsupported_hunk_header", linePath(i), "unsupported apply-patch hunk header");
            }
        }

        return ApplyPatchDryRunOutcome.success(operations);
    }

    static function validatePath(path:String, errorPath:String):ApplyPatchDryRunOutcome {
        if (StringTools.trim(path) == "") {
            return ApplyPatchDryRunOutcome.failure("invalid_patch_path", errorPath, "patch path must not be empty");
        }
        if (starts(path, "/")) {
            return ApplyPatchDryRunOutcome.failure("unsafe_patch_path", errorPath, "absolute patch paths are not allowed in dry-run wrapper");
        }
        if (path.indexOf("\\") >= 0) {
            return ApplyPatchDryRunOutcome.failure("unsafe_patch_path", errorPath, "backslash patch paths are not allowed in dry-run wrapper");
        }
        final parts = path.split("/");
        for (part in parts) {
            if (part == "" || part == "." || part == "..") {
                return ApplyPatchDryRunOutcome.failure("unsafe_patch_path", errorPath, "patch paths must be relative normalized paths");
            }
        }
        return null;
    }

    static function linePath(index:Int):String {
        return "$.patch.line[" + Std.string(index + 1) + "]";
    }

    static function normalizeNewlines(text:String):String {
        return StringTools.replace(StringTools.replace(text, "\r\n", "\n"), "\r", "\n");
    }

    static function trimTrailingNewline(text:String):String {
        if (StringTools.endsWith(text, "\n")) {
            return text.substr(0, text.length - 1);
        }
        return text;
    }

    static function starts(value:String, prefix:String):Bool {
        return StringTools.startsWith(value, prefix);
    }
}
