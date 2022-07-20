package engine;

typedef SessionDataStorageFileStructure =
{
	tutorialFinished:Bool,
	shop:
	{
		name:String, basePrice:Float, toppingPrice:Float
	},
	economy:
	{
		self:
		{
			nw:Float
		}, shop:
		{
			revenue:Float, sales:Int
		}
	}
}
