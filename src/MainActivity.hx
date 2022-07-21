package;

import lime.system.System;
import engine.Resources;
import engine.SessionStorage;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import openfl.Lib;
import openfl.display.FPS;

using Toppings;

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
		topping: null,
		meta: {
			topping: null,
			composition: []
		}
	};
	static var freezeBackupPizza:PizzaDataStructure;
	static var oven:FlxSprite;
	static var ovenBack:FlxSprite;
	static var ovenRack:FlxSprite;

	static var cookTime:Float = 0;
	static var maxCookTime:Float = 15;
	static var pizzaInOven:Bool = false;

	static var finishTutorialButton:FlxText;

	static var cookIndicator:FlxText;

	static var order:OrderDataStructure;

	static var orderFeedback:FlxText;
	static var acceptOrderFeedbackButton:FlxText;

	static var lastIngredientAdded:PizzaIngredients = null;

	static var freezeWorkspace:Bool = false;

	// stat hud
	static var salesIndicator:FlxText;
	static var revenueIndicator:FlxText;

	public override function create()
	{
		super.create();

		background = new FlxSprite();
		background.makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
		background.screenCenter();
		add(background);

		lastIngredientAdded = null;
		freezeWorkspace = false;

		titleText = new FlxText(0, 0, 0, "Loading shop name...").setFormat(Reference.FONT, 16, FlxColor.BLACK, CENTER);
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
		orderNotifyTitle = new FlxText(0, 0, 0, "New Order!").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		orderNotifyTitle.x = FlxG.width - orderNotifyTitle.width;
		orderNotifyTitle.visible = false;
		add(orderNotifyTitle);
		orderDescLine1 = new FlxText(0, 0, 0, "Summary").setFormat(Reference.FONT, 24, FlxColor.BLACK, CENTER);
		orderDescLine1.x = FlxG.width - orderDescLine1.width;
		orderDescLine1.y = orderNotifyTitle.height;
		orderDescLine1.visible = false;
		add(orderDescLine1);
		orderDescLine2 = new FlxText(0, 0, 0, "Summary").setFormat(Reference.FONT, 24, FlxColor.BLACK, CENTER);
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
				customerName: Names.getNames()[Random.int(0, Names.getNames().length - 1)],
				topping: Toppings.PEPPERONI,
				tip: 0
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
		tutorialArrow = new FlxText(0, 0, 0, "<-").setFormat(Reference.FONT, 24, FlxColor.BLACK, CENTER);
		tutorialArrow.x = sauceIcon.width;
		tutorialArrow.y = doughIcon.y;

		if (SessionStorage.tutorialCompleted)
		{
			tutorialArrow.visible = false;
		}
		add(tutorialArrow);

		// work area
		dragHereHint = new FlxText(0, 0, 0, "Click on the dough icon").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
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

		finishTutorialButton = new FlxText(0, 0, 0, "Get started!").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		finishTutorialButton.screenCenter(XY);
		finishTutorialButton.y += FlxG.height / 4;
		finishTutorialButton.visible = false;
		add(finishTutorialButton);

		cookIndicator = new FlxText(0, 0, 0, "error").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		cookIndicator.x = oven.x + (oven.width / 2 - cookIndicator.width / 2);
		cookIndicator.y = oven.y - cookIndicator.height * 2;
		add(cookIndicator);

		currentPizza.topping = new FlxSprite(0, 0, Resources.UncookedPepperoni__png);
		currentPizza.topping.visible = false;
		add(currentPizza.topping);

		orderFeedback = new FlxText(0, 0, 0,
			"Your customer, " + order.customerName + ", did not get what they ordered.").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		orderFeedback.screenCenter(XY);
		orderFeedback.y = FlxG.height - (orderFeedback.height * 3);
		orderFeedback.visible = false;
		add(orderFeedback);
		acceptOrderFeedbackButton = new FlxText(0, 0, 0, "Next order").setFormat(Reference.FONT, 48, FlxColor.BLACK, CENTER);
		acceptOrderFeedbackButton.screenCenter(XY);
		acceptOrderFeedbackButton.y = FlxG.height - acceptOrderFeedbackButton.height;
		acceptOrderFeedbackButton.visible = false;
		add(acceptOrderFeedbackButton);

		// stat hud
		salesIndicator = new FlxText(0, 0, 0, "0").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		salesIndicator.screenCenter(X);
		salesIndicator.x -= salesIndicator.width;
		add(salesIndicator);
		revenueIndicator = new FlxText(0, 0, 0, "0").setFormat(Reference.FONT, 32, FlxColor.BLACK, CENTER);
		revenueIndicator.screenCenter(X);
		revenueIndicator.x += revenueIndicator.width;
		add(revenueIndicator);
	}

	public override function update(dt:Float)
	{
		super.update(dt);

		salesIndicator.text = SessionStorage.totalSales + " sales";
		revenueIndicator.text = SessionStorage.totalRevenue + " coins";
		salesIndicator.screenCenter(X);
		salesIndicator.x -= salesIndicator.width;
		revenueIndicator.screenCenter(X);
		revenueIndicator.x += revenueIndicator.width;

		if (FlxG.mouse.overlaps(titleText) && FlxG.mouse.justPressed)
		{
			FlxG.switchState(new NameYourShopState(true));
		}

		if (FlxG.mouse.overlaps(doughIcon) && FlxG.mouse.justPressed)
		{
			if (!pizzaInOven && !freezeWorkspace && lastIngredientAdded == null)
			{
				currentPizza.base.loadGraphic(Resources.UncookedDough__png);
				currentPizza.base.visible = true;
				dragHereHint.text = "Click on the sauce icon";
				dragHereHint.screenCenter(X);
				tutorialArrow.y = sauceIcon.y;
				currentPizza.meta.composition.push(DOUGH);
				lastIngredientAdded = DOUGH;
			}
		}

		if (FlxG.mouse.overlaps(sauceIcon) && FlxG.mouse.justPressed)
		{
			if (!pizzaInOven && !freezeWorkspace && lastIngredientAdded == DOUGH)
			{
				currentPizza.base.loadGraphic(Resources.UncookedDoughWithSauce__png);
				dragHereHint.text = "Click on the cheese icon";
				dragHereHint.screenCenter(X);
				tutorialArrow.y = cheeseIcon.y;
				currentPizza.meta.composition.push(SAUCE);
				lastIngredientAdded = SAUCE;
			}
		}

		if (FlxG.mouse.overlaps(cheeseIcon) && FlxG.mouse.justPressed)
		{
			if (!pizzaInOven && !freezeWorkspace && lastIngredientAdded == SAUCE)
			{
				currentPizza.base.loadGraphic(Resources.UncookedDoughWithSauceAndCheese__png);
				dragHereHint.text = "Click on the pepperoni icon";
				dragHereHint.screenCenter(X);
				tutorialArrow.y = pepperoniIcon.y;
				currentPizza.meta.topping = NONE;
				currentPizza.meta.composition.push(CHEESE);
				lastIngredientAdded = CHEESE;
			}
		}

		if (FlxG.mouse.overlaps(pepperoniIcon) && FlxG.mouse.justPressed)
		{
			if (!pizzaInOven && !freezeWorkspace && lastIngredientAdded == CHEESE)
			{
				// currentPizza.topping = new FlxSprite(0, 0, Resources.UncookedPepperoni__png);
				currentPizza.topping.scale.set(4, 4);
				currentPizza.topping.screenCenter(XY);
				currentPizza.topping.x += 48;
				currentPizza.topping.y += 32;
				currentPizza.topping.visible = true;
				tutorialArrow.visible = false;
				dragHereHint.text = "Now move your pizza to the oven by clicking on it";
				dragHereHint.screenCenter(X);
				currentPizza.meta.topping = PEPPERONI;
			}
		}

		if (FlxG.mouse.overlaps(currentPizza.base) && FlxG.mouse.justPressed)
		{
			if (currentPizza.meta.composition.contains(DOUGH)
				&& currentPizza.meta.composition.contains(SAUCE)
				&& currentPizza.meta.composition.contains(CHEESE))
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
				currentPizza.base.visible = false;
				currentPizza.topping.visible = false;
				freezeWorkspace = true;
			}
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
			cookTime = 0;
			if (SessionStorage.tutorialCompleted)
			{
				finishTutorialButton.text = "Deliver Order";
			}
			// currentPizza.base.visible = true;
			// currentPizza.topping.visible = true;
		}

		if (FlxG.mouse.overlaps(finishTutorialButton) && FlxG.mouse.justPressed)
		{
			finishTutorialButton.visible = false;
			if (!SessionStorage.tutorialCompleted)
			{
				SessionStorage.tutorialCompleted = true;
				SessionStorage.saveDataToJSON();
			}
			if (OrderChecker.verify(order, currentPizza))
			{
				SessionStorage.totalSales++;
				SessionStorage.totalRevenue += SessionStorage.cheesePizzaPrice;
				SessionStorage.totalRevenue += order.tip;
				if (order.topping == PEPPERONI)
				{
					SessionStorage.totalRevenue += SessionStorage.pricePerTopping;
				}
				SessionStorage.saveDataToJSON();
				FlxG.switchState(new NameYourShopState(false));
			}
			else
			{
				orderFeedback.visible = true;
				acceptOrderFeedbackButton.visible = true;
			}
		}

		if (FlxG.mouse.overlaps(acceptOrderFeedbackButton) && FlxG.mouse.justPressed)
		{
			FlxG.switchState(new NameYourShopState(false));
		}
	}
}
