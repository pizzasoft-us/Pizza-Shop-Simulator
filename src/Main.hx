package;

import engine.Resources;
import flixel.FlxG;
import engine.SessionStorage;
import flixel.FlxGame;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		SessionStorage.initJSONStorage();
		Lib.current.addChild(new FlxGame(0, 0, MenuState, 1, 60, 60, true, false));
		Lib.current.addChild(new FPS(10, 20, 0x000000));
		#if html5
		FlxG.sound.playMusic(Resources.BusyCity__mp3);
		#else
		FlxG.sound.playMusic(Resources.BusyCity__wav);
		#end
	}
}
