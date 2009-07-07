package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		public static var cardsAmount:int = 54;
		// 定义所有的牌在整图中的位置
		// 所有的牌的定义，按照花色的顺序从 黑桃-》红桃-》梅花-》方块
		// 牌值从 A开始到K结束,因为我对arraycollection不熟悉，所以是AAAA，然后2222,然后3333的顺序
		// 最后的53，54是joker--司令。
		private static var cardsRect:ArrayCollection = new ArrayCollection();
		//
		public static var cardsWidth:int = 77;
		public static var cardsHeight:int = 108;
		public static var cardsIntervalX:int = 31;
		public static var cardsIntervalY:int = 28;
		
		// 游戏中的各个阶段的状态定义
		// 0 没有状态  1 自己的牌的发牌的过程，也就是初始化的过程， 2 游戏过程 3...
		public var gameState:int	= 0;
		// 0 没有状态，等待   1 发送了参加房间的消息以后，成功，  2 发送了参加房间的消息以后，失败 
		// 3 发送了准备完整的消息以后，成功， 4 发送了准备完成的消息以后，失败
		public var menuState:int	= 0;
		// 计时器
		private var lastFrameTime:Date = new Date();
		private static var requestInterval:Number = 1.0;
		private var requestFlag:Boolean = false;


		public function Game()
		{
			//TODO: implement function
		}
		static public function get Instance():Game
		{
			if ( instance == null )
				instance = new Game();
			return instance;
		}
		
		// 初始化所有的54张牌，如果是双扣，就是108张
		public function init():void
		{
			GameObjectManager.Instance.startup();

			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			for(var i:int=0; i<36; i++)
			{
				var go:GameObject = new GameObject();
				var pt:Point = new Point(i*17,460);
				// 传入的是左上的位置坐标
				go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(i+10)), pt, rt);
				GameObjectManager.Instance.addBaseObject(go);
			}
		}
		
		public function taskLoop(state:String):void
		{
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrameTime.getTime())/1000.0;
			if(seconds > requestInterval)
			{
				requestFlag = true;
	    		lastFrameTime = thisFrame;
			}

			if(state == "Game")
			{
				switch(gameState)
				{
					case 0:
					break;
					case 1:
					break;
					case 2:
					    GameObjectManager.Instance.enterFrame();
					break;
				}
			}
			else if(state == "MainMenu")
			{
				if(menuState == 0)	// nothing
				{
				}
				else if(menuState == 1)
				{
				}
			}

		} 
	}
}