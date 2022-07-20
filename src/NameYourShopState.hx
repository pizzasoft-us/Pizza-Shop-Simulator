package;

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

	static var bypass:Bool = false;

	public function new(bp:Bool)
	{
		super();
		bypass = bp;
	}

	public override function create()
	{
		super.create();

		SessionStorage.loadDataFromJSON();
		if (SessionStorage.shopName != "" && !bypass)
		{
			FlxG.switchState(new MainActivity());
		}

		titleText = new FlxText(0, 0, 0, "Name your shop:").setFormat(null, 72, FlxColor.fromInt(0xFFFFFFFF), FlxTextAlign.CENTER);
		titleText.screenCenter(X);
		add(titleText);

		textInputField = new FlxInputText(0, 0, FlxG.width, "Click here to type", 48);
		textInputField.screenCenter(XY);
		add(textInputField);

		nextButton = new FlxText(0, 0, 0, "Confirm").setFormat(null, 36, FlxColor.WHITE, CENTER);
		nextButton.screenCenter(X);
		nextButton.y = FlxG.height - (titleText.y + titleText.height);
		add(nextButton);
	}

	public override function update(dt:Float)
	{
		super.update(dt);

		if (FlxG.mouse.overlaps(nextButton))
		{
			nextButton.color = FlxColor.fromInt(0xFFFF0000);
			if (FlxG.mouse.justPressed)
			{
				SessionStorage.shopName = textInputField.textField.text;
				trace(SessionStorage.shopName);
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
