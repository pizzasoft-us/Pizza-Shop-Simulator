package engine;

typedef SessionDataStorageFileStructure =
{
	tutorialFinished:Bool,
	shop:
	{
		name:String
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
