package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import mx.collections.*;
	import mx.core.*;
	
	public class GameObjectManager
	{
		// double buffer
		public var backBuffer:BitmapData;
		// colour to use to clear backbuffer with 
		public var clearColor:uint = 0xFF849AA5;
		// static instance 
		protected static var instance:GameObjectManager = null;
		// the last frame time 
		protected var lastFrame:Date;
		// a collection of the BaseObjects 
		protected var baseObjects:ArrayCollection = new ArrayCollection();
		// a collection where new BaseObjects are placed, to avoid adding items 
		// to baseObjects while in the baseObjects collection while it is in a loop
		protected var newBaseObjects:ArrayCollection = new ArrayCollection();
		// a collection where removed BaseObjects are placed, to avoid removing items 
		// to baseObjects while in the baseObjects collection while it is in a loop
		protected var removedBaseObjects:ArrayCollection = new ArrayCollection();
		
		static public function get Instance():GameObjectManager
		{
			if ( instance == null )
			instance = new GameObjectManager();
			return instance;
		}
		
		public function GameObjectManager()
		{
			if ( instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" ); 
				
			backBuffer = new BitmapData(Application.application.width, Application.application.height, false);
		}
		
		public function startup():void
		{
			lastFrame = new Date();			
		}
		
		public function shutdown():void
		{
			shutdownAll();
		}
		
		public function enterFrame():void
		{
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrame.getTime())/1000.0;
	    	lastFrame = thisFrame;
	    	
	    	removeDeletedBaseObjects();
	    	insertNewBaseObjects();
	    	
	    	// now allow objects to update themselves
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.enterFrame(seconds);
	    	
	    	drawObjects();
		}
		
		public function click(event:MouseEvent):void
		{
			// 检测 ZOrder，然后然找优先级来进行点击传递，一旦一个点击被处理了，就直接返回。
			for(var i:int=0;i<baseObjects.length;i++)
			{
				var gameObject:BaseObject = BaseObject(baseObjects.getItemAt(baseObjects.length-1-i)); 
				if (gameObject.inuse)
				{ 
					if(gameObject.click(event))
					{
						return;
					}
				}
			}
		}
		
		public function removeSendCards():void
		{
			for each(var gameObject:GameObject in baseObjects)
			{
				if (gameObject.selected)
				{ 
					gameObject.shutdown();
				}
			}
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseDown(event);
		}
		
		public function mouseUp(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseUp(event);
		}
		
		public function mouseMove(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseMove(event);
		}
		
		protected function drawObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, clearColor);
			
			// draw the objects
			for each (var baseObject:BaseObject in baseObjects)
				if (baseObject.inuse)
					baseObject.copyToBackBuffer(backBuffer);
		}
				
		public function addBaseObject(baseObject:BaseObject):void
		{
			newBaseObjects.addItem(baseObject);
		}
		
		public function removeBaseObject(baseObject:BaseObject):void
		{
			removedBaseObjects.addItem(baseObject);
		}
		
		protected function shutdownAll():void
		{
			// don't dispose objects twice
			for each (var baseObject:BaseObject in baseObjects)
			{
				var found:Boolean = false;
				for each (var removedObject:BaseObject in removedBaseObjects)
				{
					if (removedObject == baseObject)
					{
						found = true;
						break;
					}
				}
				
				if (!found)
					baseObject.shutdown();
			}
		}
		
		protected function insertNewBaseObjects():void
		{
			for each (var baseObject:BaseObject in newBaseObjects)
			{
				for (var i:int = 0; i < baseObjects.length; ++i)
				{
					var otherBaseObject:BaseObject = baseObjects.getItemAt(i) as BaseObject;
					
					if (otherBaseObject.zOrder > baseObject.zOrder ||
						otherBaseObject.zOrder == -1)
						break;
				}

				baseObjects.addItemAt(baseObject, i);
			}
			
			newBaseObjects.removeAll();
		}
		
		// 检测所有的卡片，确定该次是否满足出牌条件
		public function checkCardtobePlayed(arr:Array):Boolean
		{
			var array:Array = new Array();
			for each(var go:GameObject in baseObjects)
			{
				if(go.getName() == "Card")
				{
					// 检测出牌条件
					if(go.selected)
					{
						array.push(go.getId());
					}
				}
			}
			if(arr.length == 0)
			{
				// 第一个出牌，只有基本限制
				if(CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) != -1)
				{
					return true;
				}
			}
			else
			{
				// 首先比较模式是否相同
				if(CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) == CardPattern.Instance.patternCheck(arr))
				{
					//然后比较大小
					if(CardPattern.Instance.patternCompare(array.sort(Array.NUMERIC), arr))
					{
						return true;
					}
					return false;
				}
			}
			return false;
		}

		// 生成并返回当前被选中的纸牌的序列
		public function getSelectedCards():Array
		{
			var cards:Array = new Array();
			for each(var go:GameObject in baseObjects)
			{
				if(go.getName() == "Card")
				{
					if(go.selected)
					{
						cards.push(go.getId());
					}
				}
			}
			
			return cards;
		}

		protected function removeDeletedBaseObjects():void
		{
			// insert the object acording to it's z position
			for each (var removedObject:BaseObject in removedBaseObjects)
			{
				var i:int = 0;
				for (i = 0; i < baseObjects.length; ++i)
				{
					if (baseObjects.getItemAt(i) == removedObject)
					{
						baseObjects.removeItemAt(i);
						break;
					}
				}
				
			}
			
			removedBaseObjects.removeAll();
		}
	}
}