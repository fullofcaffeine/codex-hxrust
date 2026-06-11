package codexhx.tools.patch;

class ApplyPatchOperation {
    public final kind:String;
    public final path:String;
    public final moveTo:String;
    public final additions:Int;
    public final deletions:Int;
    public final context:Int;

    public function new(kind:String, path:String, moveTo:String, additions:Int, deletions:Int, context:Int) {
        this.kind = kind;
        this.path = path;
        this.moveTo = moveTo;
        this.additions = additions;
        this.deletions = deletions;
        this.context = context;
    }
}
