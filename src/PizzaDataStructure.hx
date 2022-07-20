package;

import flixel.FlxSprite;

typedef PizzaDataStructure =
{
	base:FlxSprite,
	topping:FlxSprite,
	meta:
	{
		topping:Toppings, composition:Array<PizzaIngredients>
	}
}
