package;

import flixel.addons.ui.FlxSlider;
import engine.SessionStorage;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.ui.FlxInputText;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class NameYourShopState extends FlxState
{
	static var titleText:FlxText;
	static var textInputField:FlxInputText;
	static var nextButton:FlxText;

	static var basePriceText:FlxText;
	static var basePriceField:FlxInputText;

	static var toppingPriceText:FlxText;
	static var toppingPriceField:FlxInputText;

	static var bypass:Bool = false;

	static var volumeField:FlxInputText;
	static var volumeLabel:FlxText;

	public function new(bp:Bool)
	{
		super();
		bypass = bp;
	}

	public override function create()
	{
		super.create();

		SessionStorage.loadDataFromJSON();
		if (SessionStorage.shopName != "" && bypass)
		{
			FlxG.switchState(new MainActivity());
		}

		titleText = new FlxText(0, 0, 0, "Name your shop:").setFormat(Reference.FONT, 72, FlxColor.fromInt(0xFFFFFFFF), FlxTextAlign.CENTER);
		titleText.screenCenter(X);
		add(titleText);

		textInputField = new FlxInputText(0, 0, FlxG.width, "Click here to type", 48);
		textInputField.screenCenter(XY);
		add(textInputField);

		nextButton = new FlxText(0, 0, 0, "Confirm").setFormat(Reference.FONT, 36, FlxColor.WHITE, CENTER);
		nextButton.screenCenter(X);
		nextButton.y = FlxG.height - (titleText.y + titleText.height);
		add(nextButton);

		basePriceText = new FlxText(0, 0, 0, "Pizza Price").setFormat(Reference.FONT, 36);
		basePriceText.screenCenter(XY);
		basePriceText.y += FlxG.height / 4;
		basePriceText.x -= FlxG.width / 4;
		add(basePriceText);
		basePriceField = new FlxInputText(0, 0, Std.int(FlxG.width / 10), "16", 48);
		basePriceField.y = basePriceText.y + basePriceField.height;
		basePriceField.x = basePriceText.x;
		add(basePriceField);

		toppingPriceText = new FlxText(0, 0, 0, "Topping Price").setFormat(Reference.FONT, 36);
		toppingPriceText.screenCenter(XY);
		toppingPriceText.y += FlxG.height / 4;
		toppingPriceText.x += FlxG.width / 4;
		add(toppingPriceText);
		toppingPriceField = new FlxInputText(0, 0, Std.int(FlxG.width / 10), "4", 48);
		toppingPriceField.y = toppingPriceText.y + toppingPriceField.height;
		toppingPriceField.x = toppingPriceText.x;
		add(toppingPriceField);

		volumeField = new FlxInputText(0, 0, 150, "100", 32);
		volumeField.y = FlxG.height - volumeField.height;
		add(volumeField);
		volumeLabel = new FlxText(0, 0, 0, "Volume %").setFormat(Reference.FONT, 16, 0xFFFFFFFF, CENTER);
		volumeLabel.y = volumeField.y - volumeLabel.height;
		add(volumeLabel);

		// Main.kitchenMusic.pause();
		// Main.menuMusic.resume();
	}

	public override function update(dt:Float)
	{
		super.update(dt);

		SessionStorage.volume = Std.parseInt(volumeField.textField.text) / 100;

		if (FlxG.mouse.overlaps(nextButton))
		{
			nextButton.color = FlxColor.fromInt(0xFFFF0000);
			if (FlxG.mouse.justPressed)
			{
				SessionStorage.shopName = textInputField.textField.text;
				SessionStorage.cheesePizzaPrice = Std.parseInt(basePriceField.textField.text);
				SessionStorage.pricePerTopping = Std.parseInt(toppingPriceField.textField.text);
				SessionStorage.saveDataToJSON();
				FlxG.switchState(new MainActivity());
			}
		}
		else
		{
			nextButton.color = FlxColor.fromInt(0xFFFFFFFF);
		}
	}
}
