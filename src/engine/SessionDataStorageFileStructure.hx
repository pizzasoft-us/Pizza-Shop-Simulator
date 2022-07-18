package engine;

typedef SessionDataStorageFileStructure =
{
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
