package
{
	import flash.display.*;
	import flash.events.*;
	
	public class BaseObject
	{
		public var inuse:Boolean = false;
		public var zOrder:int = 0;
		protected var name:String = null;
		
		public function BaseObject()
		{
		}
		
		public function setName(name:String):void
		{
			this.name = name; 
		}
		
		public function startupBaseObject(zOrder:int):void
		{
			if (!this.inuse)
			{
				this.inuse = true;
				this.zOrder = zOrder;
				GameObjectManager.Instance.addBaseObject(this);
			}
		}
		
		public function shutdown():void
		{
			if (this.inuse)
			{
				this.inuse = false;
				GameObjectManager.Instance.removeBaseObject(this);
			}
		}
		
		public function enterFrame(dt:Number):void
		{
		
		}
		
		public function click(event:MouseEvent):Boolean
		{
			return true;
		}
		
		public function mouseDown(event:MouseEvent):void
		{
		
		}
		
		public function mouseUp(event:MouseEvent):void
		{
		
		}
		
		public function mouseMove(event:MouseEvent):void
		{
		
		}
		
		public function collision(other:GameObject):void
		{
		
		}
		
		public function copyToBackBuffer(db:BitmapData):void
		{
		
		}

	}
}