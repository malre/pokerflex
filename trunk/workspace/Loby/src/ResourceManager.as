package
{
	public final class ResourceManager
	{
		public function ResourceManager()
		{
		}
	
		[Embed(source="assets/lobbyTable.swf")]
		public static var imgTable:Class;
		
		[Embed(source="assets/lobbyChair.swf")]
		public static var imgChair:Class;

//		[Embed(source="../res/chair_04.png")]
//		public static var imgChair1:Class;
//
//		[Embed(source="../res/chair_03.png")]
//		public static var imgChair2:Class;
//
//		[Embed(source="../res/chair_02.png")]
//		public static var imgChair3:Class;
	}
}