package;

import engine.SessionStorage;
import engine.Resources;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MenuState extends FlxState
{
	static var background:FlxSprite;

	static var titleText:FlxSprite;
	static var playButton:FlxText;
	private static var playButtonColorTick:Float = 0.0;
	private static var playButtonColorCycle:Int = 0;
	private static var playButtonColorLoopSpeed:Float = 2; // speed 1 is 0.25 seconds, linear
	private static var playButtonColors:Array<Int> = [0xFFFF0000, 0xFF00FF00, 0xFF0000FF];

	override public function create()
	{
		super.create();

		FlxG.mouse.useSystemCursor = true;

		background = new FlxSprite();
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.fromInt(0xFFFFFFFF));
		background.screenCenter(XY);
		add(background);

		titleText = new FlxSprite(0, 0, Resources.TitleText__png);
		titleText.scale.set(4, 4);
		titleText.screenCenter(XY);
		titleText.y -= FlxG.height / 3.5;
		add(titleText);

		playButton = new FlxText(0, 0, 0, "Play!").setFormat(Reference.FONT, 96, FlxColor.fromInt(0xFFFFFFFF), FlxTextAlign.CENTER);
		playButton.screenCenter(XY);
		add(playButton);

		FlxG.sound.playMusic(Resources.newmenutheme__wav, 1 * SessionStorage.volume);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		playButtonColorTick += elapsed;

		if (FlxG.mouse.overlaps(playButton))
		{
			playButton.color = FlxColor.fromInt(0xFF000000);
			if (FlxG.mouse.justPressed)
			{
				FlxG.sound.play(Resources.Plop__wav, 0.5 * SessionStorage.volume);
				playButton.color = FlxColor.fromInt(0xFF7F7F7F);
				if (SessionStorage.shopName == null || SessionStorage.shopName == "Click here to type") {
					FlxG.switchState(new NameYourShopState(false));
				} else {
					FlxG.switchState(new MainActivity());
				}
			}
		}
		else
		{
			if (playButtonColorTick >= playButtonColorLoopSpeed / 4)
			{
				playButtonColorTick = 0;
				playButton.color = FlxColor.fromInt(playButtonColors[playButtonColorCycle]);
				if (playButtonColorCycle == playButtonColors.length)
				{
					playButtonColorCycle = 0;
				}
				else
				{
					playButtonColorCycle++;
				}
			}
		}
	}
}
