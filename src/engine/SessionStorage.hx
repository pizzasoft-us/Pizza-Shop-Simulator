package engine;

import haxe.Json;
import haxe.exceptions.NotImplementedException;
import haxe.io.Path;
import lime.system.System;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class SessionStorage
{
	public static var shopName:String = "";
	public static var netWorth:Float = 0.0;
	public static var totalRevenue:Float = 0.0;
	public static var totalSales:Int = 0;
	public static var tutorialCompleted:Bool = false;
	public static var cheesePizzaPrice:Float = 0.0;
	public static var pricePerTopping:Float = 0.0;

	public static function initJSONStorage()
	{
		var jsonData = Json.stringify({
			tutorialFinished: tutorialCompleted,
			shop: {
				name: shopName,
				basePrice: cheesePizzaPrice,
				toppingPrice: pricePerTopping
			},
			economy: {
				self: {
					nw: netWorth
				},
				shop: {
					revenue: totalRevenue,
					sales: totalSales
				}
			}
		});
		var fp = Path.join([System.applicationStorageDirectory, "data.json"]);
		#if sys
		if (!FileSystem.exists(fp))
		{
			File.saveContent(fp, jsonData);
			trace("JSON file initialised");
			trace(fp);
		}
		#else
		throw new NotImplementedException("Not implemented for JS");
		#end
	}

	public static function loadDataFromJSON()
	{
		var fp = Path.join([System.applicationStorageDirectory, "data.json"]);
		#if sys
		var rawData = File.getContent(fp);
		var json:SessionDataStorageFileStructure = Json.parse(rawData);
		shopName = json.shop.name;
		netWorth = json.economy.self.nw;
		totalRevenue = json.economy.shop.revenue;
		totalSales = json.economy.shop.sales;
		tutorialCompleted = json.tutorialFinished;
		cheesePizzaPrice = json.shop.basePrice;
		pricePerTopping = json.shop.toppingPrice;
		if (shopName == "")
		{
			trace("Data loaded however it is empty");
		}
		else
		{
			trace("Data loaded");
		}
		#else
		throw new NotImplementedException("Not implemented for JS");
		#end
	}

	public static function saveDataToJSON()
	{
		var fp = Path.join([System.applicationStorageDirectory, "data.json"]);
		#if sys
		var json = Json.stringify({
			tutorialFinished: tutorialCompleted,
			shop: {
				name: shopName,
				basePrice: cheesePizzaPrice,
				toppingPrice: pricePerTopping
			},
			economy: {
				self: {
					nw: netWorth
				},
				shop: {
					revenue: totalRevenue,
					sales: totalSales
				}
			}
		});
		File.saveContent(fp, json);
		trace("Saved data");
		#else
		throw new NotImplementedException("Not implemented for JS");
		#end
	}
}
