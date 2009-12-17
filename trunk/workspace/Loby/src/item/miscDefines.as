package item
{
	public final class miscDefines
	{
		public function miscDefines()
		{
		}
		
		include "../ServerAddress.ini"
		public static var shoplistAdd:String = ServerAddress + ServerPerfix+"/item/shop/list";
		
		public static var itembuyAdd:String = ServerAddress + ServerPerfix+"/item/shop/buy";
		
		public static var playeritemListAdd:String = ServerAddress + ServerPerfix+"/item/player/list";
		
		public static var playeritemUseAdd:String = ServerAddress + ServerPerfix+"/item/player/active";
		
		public static const itemName00:String = "算牌器包周";
		public static const itemName01:String = "积分双倍卡包周";
		public static const itemName02:String = "积分双倍卡包月";
		public static const itemName03:String = "积分双倍卡包季";
		public static const itemName04:String = "积分三倍卡包周";
		public static const itemName05:String = "积分三倍卡包月";
		public static const itemName06:String = "积分三倍卡包季";
		public static const itemName07:String = "积分四倍卡包周";	
		public static const itemName08:String = "积分四倍卡包月";	
		public static const itemName09:String = "积分四倍卡包季";	
		public static const itemName10:String = "防踢卡包周";	
		public static const itemName11:String = "防踢卡包月";	
		public static const itemName12:String = "防踢卡包季";	
		public static const itemName13:String = "打折卡包周";	
		public static const itemName14:String = "打折卡包月";	
		public static const itemName15:String = "打折卡包季";	
		public static const itemName16:String = "尊贵身份卡包周";	
		public static const itemName17:String = "尊贵身份卡包月";	
		public static const itemName18:String = "尊贵身份卡包季";	
		public static const itemName19:String = "VIP卡包月";	
			
		public static function getItemName(id:String):String
		{
			if(id == "1020301"){
				return itemName00;
			}
			else if(id == "1020102"){
				return itemName01;
			}
			else if(id == "1030102"){
				return itemName02;
			}
			else if(id == "1040102"){
				return itemName03;
			}
			else if(id == "1020103"){
				return itemName04;
			}
			else if(id == "1030103"){
				return itemName05;
			}
			else if(id == "1040103"){
				return itemName06;
			}
			else if(id == "1020104"){
				return itemName07;
			}
			else if(id == "1030104"){
				return itemName08;
			}
			else if(id == "1040104"){
				return itemName09;
			}
			else if(id == "1020308"){
				return itemName10;
			}
			else if(id == "1030308"){
				return itemName11;
			}	
			else if(id == "1040308"){
				return itemName12;
			}
			else if(id == "1020209"){
				return itemName13;
			}
			else if(id == "1030209"){
				return itemName14;
			}	
			else if(id == "1040209"){
				return itemName15;
			}	
			else if(id == "1020410"){
				return itemName16;
			}	
			else if(id == "1030410"){
				return itemName17;
			}	
			else if(id == "1040410"){
				return itemName18;
			}
			else if(id == "1030412"){
				return itemName19;
			}	
			return "";
		}
	}
}