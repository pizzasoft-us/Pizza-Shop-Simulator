package;

import engine.Resources;
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

	// ingridients hud
	static var doughIcon:FlxSprite;
	static var sauceIcon:FlxSprite;
	static var cheeseIcon:FlxSprite;
	static var pepperoniIcon:FlxSprite;

	static var draggable:FlxSprite; // currently with a single cursor you can only drag one at a time so there is no point in having a draggable sprite for each ingredient

	public override function create()
	{
		super.create();

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

		// ingridients hud
		sauceIcon = new FlxSprite(0, 0, Resources.Sauce__png);
		sauceIcon.y = ((FlxG.height / 2) - (sauceIcon.height / 2));
		sauceIcon.y -= sauceIcon.height / 1.5;
		add(sauceIcon);
		doughIcon = new FlxSprite(0, 0, Resources.UncookedDough__png);
		doughIcon.y = ((FlxG.height / 2) - (doughIcon.height / 2));
		doughIcon.y -= doughIcon.height * 2;
		add(doughIcon);
		cheeseIcon = new FlxSprite(0, 0, Resources.Cheese__png);
		cheeseIcon.y = ((FlxG.height / 2) - (cheeseIcon.height / 2));
		cheeseIcon.y += cheeseIcon.height / 1.5;
		add(cheeseIcon);
		pepperoniIcon = new FlxSprite(0, 0, Resources.UncookedPepperoni__png);
		pepperoniIcon.y = ((FlxG.height / 2) - (pepperoniIcon.height / 2));
		pepperoniIcon.y += pepperoniIcon.height * 2;
		add(pepperoniIcon);
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
