package;

import engine.SessionStorage;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.FPS;

class MainActivity extends FlxState
{
	static var background:FlxSprite;

	static var titleText:FlxText;

	public override function create()
	{
		super.create();

		Lib.current.removeChild(Lib.current.removeChild(new FPS(10, 10, 0xFFFFFFFF)));

		background = new FlxSprite();
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		background.screenCenter();
		add(background);

		titleText = new FlxText(0, 0, 0, "Loading shop name...").setFormat(null, 16, FlxColor.BLACK, CENTER);
		try
		{
			titleText.text = SessionStorage.shopName + "'s kitchen";
		}
		catch (error)
		{
			titleText.text = "Failed to load shop name";
		}
		add(titleText);
	}

	public override function update(dt:Float)
	{
		super.update(dt);

		if (FlxG.mouse.overlaps(titleText) && FlxG.mouse.justPressed)
		{
			FlxG.switchState(new NameYourShopState(true));
		}
	}
}
