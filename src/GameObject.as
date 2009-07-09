package
{
	import flash.display.*;
	import flash.events.MouseEvent;
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
		// 这张牌是否被选中
		public var selected:Boolean = false;	
		
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
		
		override public function click(event:MouseEvent):Boolean
		{
			// 如果是纸牌的话，对纸牌进行处理
			if(name == "Card")
			{
				// 这张纸牌被点中了
				if(event.localX >= position.x && event.localX <= (position.x+Game.cardsWidth)
				&& event.localY >= position.y && event.localY <= (position.y+Game.cardsHeight))
				{
					if(selected)
					{
						position.y += 20;
						selected = false;
					}
					else
					{
						position.y -= 20;
						selected = true;
					}
					return true;
				}
			}
			
			return false;
		}		
		
		override public function copyToBackBuffer(db:BitmapData):void
		{
			db.copyPixels(graphics.bitmap, graphics.bitmap.rect, position, graphics.bitmapAlpha, new Point(0, 0), true);
		}				
	}
}