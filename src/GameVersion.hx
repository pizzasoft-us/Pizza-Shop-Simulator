package;

class GameVersion {
    public static final CURRENT:GameVersion = new GameVersion();

    private final name:String;
    private final saveVersion:Int;
    private final uid:Int;
    private final stable:Bool;

    public function new() {
        name = "1.1.0";
        saveVersion = 1;
        uid = 2;
        stable = true;
    }

    public function getName():String {
        return name;
    }

    public function getSaveVersion():Int {
        return saveVersion;
    }

    public function getUid():Int {
        return uid;
    }

    public function isStable():Bool {
        return stable;
    }
}