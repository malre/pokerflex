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
	}
}