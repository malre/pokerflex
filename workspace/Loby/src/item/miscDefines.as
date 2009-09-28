package item
{
	public final class miscDefines
	{
		public function miscDefines()
		{
		}
		
		include "../ServerAddress.ini"
		public static var shoplistAdd:String = ServerAddress + "/web/"+ServerPerfix+"/item/shop/list";
		
		public static var itembuyAdd:String = ServerAddress + "/web/"+ServerPerfix+"/item/shop/buy";
		
		public static var playeritemListAdd:String = ServerAddress + "/web/"+ServerPerfix+"/item/player/list";
		
		public static var playeritemUseAdd:String = ServerAddress + "/web/"+ServerPerfix+"/item/player/active";
	}
}