package;

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
		Lib.current.addChild(new FlxGame(0, 0, MenuState, 1, 60, 60, false, false));
		Lib.current.addChild(new FPS(10, 10, 0xffffff));
	}
}
