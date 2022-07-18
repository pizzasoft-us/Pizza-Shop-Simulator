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

	// order hud
	static var orderNotifyTitle:FlxText;
	static var orderDescLine1:FlxText;
	static var orderDescLine2:FlxText;

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

		// order hud will be invisible until there is an order
		// for testing, we will create an order at the beginning of the game
		orderNotifyTitle = new FlxText(0, 0, 0, "New Order!").setFormat(null, 32, FlxColor.BLACK, CENTER);
		orderNotifyTitle.x = FlxG.width - orderNotifyTitle.width;
		orderNotifyTitle.visible = false;
		add(orderNotifyTitle);
		orderDescLine1 = new FlxText(0, 0, 0, "Summary").setFormat(null, 24, FlxColor.BLACK, CENTER);
		orderDescLine1.x = FlxG.width - orderDescLine1.width;
		orderDescLine1.y = orderDescLine1.y;
		orderDescLine1.visible = false;
		add(orderDescLine1);
		orderDescLine2 = new FlxText(0, 0, 0, "Summary").setFormat(null, 24, FlxColor.BLACK, CENTER);
		orderDescLine2.x = FlxG.width - orderDescLine2.width;
		orderDescLine2.y = orderDescLine2.y;
		orderDescLine2.visible = false;
		add(orderDescLine2);
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
