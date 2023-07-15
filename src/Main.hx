package;

import flixel.system.FlxSound;
import engine.Resources;
import flixel.FlxG;
import engine.SessionStorage;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	private static var isMusicPlaying = false;
	public function new()
	{
		super();
		SessionStorage.initJSONStorage();
		Lib.current.addChild(new FlxGame(0, 0, MenuState, 60, 60, true, false));
		Lib.current.addChild(new FPS(10, 20, 0x000000));
	}
	public static function playMainMusic() {
		if (!isMusicPlaying) FlxG.sound.playMusic(Resources.BusyCity__wav, 1 * SessionStorage.volume);
		isMusicPlaying = true;
	}
}
