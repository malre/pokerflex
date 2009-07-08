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
		// 玩家的牌的中心基准点
		public static var cardStandardX:int = 290;
		public static var cardStandardY:int = 485;
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
		// BG
		private var BGImg:GameObject = null;
		// 记录玩家的牌的数组
		private var PlayerCards:Array = new Array();
		
		
		// 游戏中的各个阶段的状态定义
		// 0 没有状态  1 自己的牌的发牌的过程，也就是初始化的过程， 2 游戏过程 3 发送举手消息以前 4 发送举手消息以后
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
			BGImg = new GameObject();
			BGImg.startupGameObject(GraphicsResource(ResourceManager.BG00Res), new Point(0,0), new Rectangle(0,0, 800, 600),0);
		}
		static public function get Instance():Game
		{
			if ( instance == null )
				instance = new Game();
			return instance;
		}
		
		// 根据得到的数据来
		// 初始化玩家手上的27张牌
		public function init():void
		{
			GameObjectManager.Instance.startup();

			// 对得到的牌进行排序
			sortCards();
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			for(var i:int=0; i<PlayerCards.length; i++)
			{
				var go:GameObject = new GameObject();
				var pt:Point = new Point(cardStandardX-(PlayerCards.length*17/2)+i*17,cardStandardY);
				// 传入的是左上的位置坐标
				go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(i+10)), pt, rt,10);
				//GameObjectManager.Instance.addBaseObject(go);
			}
		}
		//
		public function sortCards():void
		{
			var i:int;
			var j:int;
			var k:int;
			for(i=0;i<4;i++)
			{
				if(NetManager.Instance.json1.players[i].pid == 28)		// 28 should be the play id,the we recorded
				{
					for(j=0;j<27;j++)
					{
						PlayerCards.push(NetManager.Instance.json1.players[i].card[j]);
						//for debug
						//PlayerCards.push();
					}
					// do sort
					PlayerCards.sort();
					var jokerarray:Array = new Array();
					for(k=0;k<4;k++)
					{
						if(PlayerCards[26-k] >= 52)
						{
							jokerarray.push(PlayerCards.pop());
						}
					}
					var tmp:Array = new Array();
					for(k=0;k<8;k++)
					{
						if(PlayerCards[k] ==0 || PlayerCards[k]==1)
						{
							tmp.push(PlayerCards.shift());
						}
					}
					for(k=0;k<tmp.length;k++)
					{
						PlayerCards.push(tmp.shift());
					}
					for(k=0;k<jokerarray.length;k++)
					{
						PlayerCards.push(jokerarray.pop());
					}
					break;
				}
			}
		}
		
		public function drawBG():void
		{
			
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
					case 3:
					break;
					case 4:
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