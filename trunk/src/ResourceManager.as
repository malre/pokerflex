package 
{
	import flash.display.*;
	import flash.geom.*;
	import mx.core.*;
	
	public final class ResourceManager
	{
		[Embed(source="../res/Card.png")]
		public static var Cards:Class;
		public static var CardsRes:GraphicsResource = new GraphicsResource(new Cards());
		
		[Embed(source="../res/bmp1.png")]
		public static var Club1:Class;
//		public static var GreenGraphicsID1:GraphicsResource = new GraphicsResource(new GreenID1());
//		[Embed(source="../media/gun1.mp3")]
//		public static var Gun1Sound:Class;
//		public static var Gun1FX:SoundAsset = new Gun1Sound() as SoundAsset;	
	}
}