package;

class OrderGenerator
{
	public static function generateOrder():OrderDataStructure
	{
		var pepperoni:Bool = Random.bool();
		var toppings:Toppings;
		if (pepperoni)
			toppings = Toppings.PEPPERONI;
		var name:String = Names.getNames()[Random.int(0, Names.getNames().length)];
		return {
			customerName: name,
			topping: toppings
		};
	}
}
