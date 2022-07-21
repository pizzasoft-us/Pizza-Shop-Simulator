package;

import engine.SessionStorage;

class OrderGenerator
{
	public static function generateOrder():OrderDataStructure
	{
		var pepperoni:Bool = Random.bool();
		var toppings:Toppings = Toppings.NONE;
		if (pepperoni)
			toppings = Toppings.PEPPERONI;
		var name:String = Names.getNames()[Random.int(0, Names.getNames().length - 1)];
		var tip = Random.int(0, Math.ceil(0.1 * (SessionStorage.cheesePizzaPrice + SessionStorage.pricePerTopping)));
		return {
			customerName: name,
			topping: toppings,
			tip: tip
		};
	}
}
