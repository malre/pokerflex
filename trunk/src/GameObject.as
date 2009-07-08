package
{
	import flash.display.*;
	import flash.geom.*;
	
	/*
		The base class for all objects in the game.
	*/
	public class GameObject extends BaseObject
	{
		// object position,left up point
		public var position:Point = new Point(0, 0);
		// the bitmap data to display	
		public var graphics:GraphicsResource = null;
		public var drawRect:Rectangle;
//		public var collisionName:String = CollisionIdentifiers.NONE;	
		
		public function GameObject()
		{
			super();
		}
		
		public function startupGameObject(graphics:GraphicsResource, position:Point, drawrect:Rectangle, zOrder:int = 0):void
		{
			if (!inuse)
			{
				super.startupBaseObject(zOrder);			
				this.graphics = graphics;
				this.position = position.clone();
				drawRect = drawrect;
			}
		}
		
		override public function shutdown():void
		{
			if (inuse)
			{				
				super.shutdown();
				graphics = null;							
			}
		}
		
		override public function copyToBackBuffer(db:BitmapData):void
		{
			db.copyPixels(graphics.bitmap, graphics.bitmap.rect, position, graphics.bitmapAlpha, new Point(0, 0), true);
		}				
	}
}