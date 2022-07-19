package;

class OrderChecker
{
	public static function verify(order:OrderDataStructure, creation:PizzaDataStructure):Bool
	{
		var topping1;
		var topping2;
		switch (order.topping)
		{
			case PEPPERONI:
				topping1 = Toppings.PEPPERONI;
		}
		switch (creation.topping.health)
		{
			case 1:
				topping2 = Toppings.PEPPERONI;
		}

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
