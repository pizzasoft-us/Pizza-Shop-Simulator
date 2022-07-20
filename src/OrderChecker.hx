package;

using Toppings;

class OrderChecker
{
	public static function verify(order:OrderDataStructure, creation:PizzaDataStructure):Bool
	{
		var topping1;
		var topping2;
		switch (order.topping)
		{
			case PEPPERONI:
				topping1 = PEPPERONI;
			case NONE:
				topping1 = NONE;
		}
		topping2 = creation.meta.topping;

		if (topping1 == topping2)
		{
			return true;
		}
		else
		{
			return false;
		}
	}
}
