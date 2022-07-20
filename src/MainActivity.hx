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
	static var tutorialArrow:FlxText;

	static var draggable:FlxSprite; // currently with a single cursor you can only drag one at a time so there is no point in having a draggable sprite for each ingredient

	// work area
	static var dragHereHint:FlxText;
	static var currentPizza:PizzaDataStructure = {
		base: new FlxSprite(),
		topping: null
	};
	static var oven:FlxSprite;
	static var ovenBack:FlxSprite;
	static var ovenRack:FlxSprite;

	static var cookTime:Float = 0;
	static var maxCookTime:Float = 15;
	static var pizzaInOven:Bool = false;

	static var finishTutorialButton:FlxText;

	static var cookIndicator:FlxText;

	static var order:OrderDataStructure;

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
		orderDescLine1.y = orderNotifyTitle.height;
		orderDescLine1.visible = false;
		add(orderDescLine1);
		orderDescLine2 = new FlxText(0, 0, 0, "Summary").setFormat(null, 24, FlxColor.BLACK, CENTER);
		orderDescLine2.x = FlxG.width - orderDescLine2.width;
		orderDescLine2.y = orderDescLine1.y + orderDescLine1.height;
		orderDescLine2.visible = false;
		add(orderDescLine2);

		if (SessionStorage.tutorialCompleted)
		{
			order = OrderGenerator.generateOrder();
		}
		else
		{
			order = {
				customerName: Names.getNames()[Random.int(0, Names.getNames().length)],
				topping: Toppings.PEPPERONI
			}
		}

		orderDescLine1.text = "Order from " + order.customerName;
		switch (order.topping)
		{
			case NONE:
				orderDescLine2.text = "Cheese pizza";
			case PEPPERONI:
				orderDescLine2.text = "Pepperoni pizza";
		}
		orderNotifyTitle.x = FlxG.width - orderNotifyTitle.width;
		orderDescLine1.x = FlxG.width - orderDescLine1.width;
		orderDescLine2.x = FlxG.width - orderDescLine2.width;
		orderNotifyTitle.visible = true;
		orderDescLine1.visible = true;
		orderDescLine2.visible = true;

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
		tutorialArrow = new FlxText(0, 0, 0, "<-").setFormat(null, 24, FlxColor.BLACK, CENTER);
		tutorialArrow.x = sauceIcon.width;
		tutorialArrow.y = doughIcon.y;

		if (SessionStorage.tutorialCompleted)
		{
			tutorialArrow.visible = false;
		}
		add(tutorialArrow);

		// work area
		dragHereHint = new FlxText(0, 0, 0, "Click on the dough icon").setFormat(null, 32, FlxColor.BLACK, CENTER);
		dragHereHint.screenCenter(XY);
		dragHereHint.y -= dragHereHint.height * 4;
		if (SessionStorage.tutorialCompleted)
		{
			dragHereHint.visible = false;
		}
		add(dragHereHint);

		currentPizza.base = new FlxSprite();
		currentPizza.base.screenCenter(XY);
		currentPizza.base.scale.set(4, 4);
		currentPizza.base.visible = false;
		add(currentPizza.base);
		oven = new FlxSprite(0, 0, Resources.ovenresized_0__png);
		oven.screenCenter(XY);
		oven.x += oven.width * 2;
		add(oven);
		ovenBack = new FlxSprite(0, 0, Resources.ovenresized_1__png);
		ovenBack.x = oven.x;
		ovenBack.y = oven.y;
		add(ovenBack);
		ovenRack = new FlxSprite(0, 0, Resources.panewithoutoverlayresized__png);
		ovenRack.x = oven.x;
		ovenRack.y = oven.y;
		add(ovenRack);

		finishTutorialButton = new FlxText(0, 0, 0, "Get started!").setFormat(null, 32, FlxColor.BLACK, CENTER);
		finishTutorialButton.screenCenter(XY);
		finishTutorialButton.y += FlxG.height / 4;
		finishTutorialButton.visible = false;
		add(finishTutorialButton);

		cookIndicator = new FlxText(0, 0, 0, "error").setFormat(null, 32, FlxColor.BLACK, CENTER);
		cookIndicator.x = oven.x + (oven.width / 2 - cookIndicator.width / 2);
		cookIndicator.y = oven.y - cookIndicator.height * 2;
		add(cookIndicator);

		currentPizza.topping = new FlxSprite(0, 0, Resources.UncookedPepperoni__png);
		currentPizza.topping.visible = false;
		add(currentPizza.topping);
	}

	public override function update(dt:Float)
	{
		super.update(dt);

		if (FlxG.mouse.overlaps(titleText) && FlxG.mouse.justPressed)
		{
			FlxG.switchState(new NameYourShopState(true));
		}

		if (FlxG.mouse.overlaps(doughIcon) && FlxG.mouse.justPressed)
		{
			currentPizza.base.loadGraphic(Resources.UncookedDough__png);
			currentPizza.base.visible = true;
			dragHereHint.text = "Click on the sauce icon";
			dragHereHint.screenCenter(X);
			tutorialArrow.y = sauceIcon.y;
		}

		if (FlxG.mouse.overlaps(sauceIcon) && FlxG.mouse.justPressed)
		{
			currentPizza.base.loadGraphic(Resources.UncookedDoughWithSauce__png);
			dragHereHint.text = "Click on the cheese icon";
			dragHereHint.screenCenter(X);
			tutorialArrow.y = cheeseIcon.y;
		}

		if (FlxG.mouse.overlaps(cheeseIcon) && FlxG.mouse.justPressed)
		{
			currentPizza.base.loadGraphic(Resources.UncookedDoughWithSauceAndCheese__png);
			dragHereHint.text = "Click on the pepperoni icon";
			dragHereHint.screenCenter(X);
			tutorialArrow.y = pepperoniIcon.y;
		}

		if (FlxG.mouse.overlaps(pepperoniIcon) && FlxG.mouse.justPressed)
		{
			// currentPizza.topping = new FlxSprite(0, 0, Resources.UncookedPepperoni__png);
			currentPizza.topping.scale.set(4, 4);
			currentPizza.topping.screenCenter(XY);
			currentPizza.topping.x += 12;
			currentPizza.topping.y += 8;
			currentPizza.topping.visible = true;
			tutorialArrow.visible = false;
			dragHereHint.text = "Now move your pizza to the oven by clicking on it";
			dragHereHint.screenCenter(X);
			currentPizza.topping.health = 1;
		}

		if (FlxG.mouse.overlaps(currentPizza.base) && FlxG.mouse.justPressed)
		{
			// currentPizza.base.visible = false;
			// currentPizza.topping.visible = false;
			dragHereHint.text = "Wait for your pizza to cook";
			dragHereHint.screenCenter(X);
			ovenRack.loadGraphic(Resources.ovenresized_5__png);
			currentPizza.base.x = ovenRack.x + ovenRack.width / 4;
			currentPizza.base.y = ovenRack.y + ovenRack.height / 1.5;
			currentPizza.topping.x = ovenRack.x + ovenRack.width / 4;
			currentPizza.topping.y = ovenRack.y + ovenRack.height / 1.5;
			currentPizza.topping.visible = false;
			pizzaInOven = true;
		}

		if (pizzaInOven)
		{
			cookTime += dt;
			dragHereHint.text = "Your pizza is cooking (" + Math.round(maxCookTime - cookTime) + ")";
			dragHereHint.screenCenter(X);
			cookIndicator.visible = true;
			cookIndicator.text = "" + Math.round(maxCookTime - cookTime);
		}
		else
		{
			cookIndicator.visible = false;
		}

		if (cookTime >= maxCookTime)
		{
			pizzaInOven = false;
			ovenRack.loadGraphic(Resources.ovenresized_1__png);
			dragHereHint.text = "Your pizza is done! Now try it without any hints.";
			dragHereHint.screenCenter(X);
			finishTutorialButton.visible = true;
			if (SessionStorage.tutorialCompleted)
			{
				finishTutorialButton.text = "Next Order";
			}
		}

		if (FlxG.mouse.overlaps(finishTutorialButton) && FlxG.mouse.justPressed)
		{
			if (!SessionStorage.tutorialCompleted)
			{
				SessionStorage.tutorialCompleted = true;
				SessionStorage.saveDataToJSON();
			}
			FlxG.switchState(new NameYourShopState(false));
		}
	}
}
