package
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	import mx.core.Application;
	
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		public static const cardsAmount:int = 54;
		// 玩家的牌的中心基准点
		public static const cardStandardX:int = 280;
		public static const cardStandardY:int = 440;
		public static const playedCardStdX:int = 280;
		public static const playedCardStdY:int = 180;
		// 其他玩家的牌堆的显示位置
		// 左边玩家的位置，
		private static const leftCardback_x:int = 26;
		private static const leftCardback_y:int = 238;
		private static const playedleftCardStdX:int = 100;
		private static const playedleftCardStdY:int = 238;
		// 上面玩家的位置，
		private static const upCardback_x:int = 262;
		private static const upCardback_y:int = 27;
		private static const playedupCardStdX:int = 262;
		private static const playedupCardStdY:int = 130;
		// 右边玩家的位置
		private static const rightCardback_x:int = 493;
		private static const rightCardback_y:int = 239;
		private static const playedrightCardStdX:int = 410;
		private static const playedrightCardStdY:int = 239;
		// 牌堆类型1的宽高
		private static const cardback1_w:int = 61;
		private static const cardback1_h:int = 95;
		// 牌堆类型2的宽高
		private static const cardback2_w:int = 70;
		private static const cardback2_h:int = 86;
		
		// 定义所有的牌在整图中的位置
		// 所有的牌的定义，按照花色的顺序从 黑桃-》红桃-》梅花-》方块
		// 牌值从 A开始到K结束,因为我对arraycollection不熟悉，所以是AAAA，然后2222,然后3333的顺序
		// 最后的53，54是joker--司令。
		private static var cardsRect:ArrayCollection = new ArrayCollection();
		//
		public static const cardsWidth:int = 61;
		public static const cardsHeight:int = 86;
		public static const cardsIntervalX:int = 14;
		public static const cardsIntervalY:int = 28;
		// BG
		private var BGImg:GameObject = null;
		// 记录玩家的牌的数组
		// 关于玩家的牌的顺序的定义如下：
		// 按照花色的顺序从 方块-》梅花-》红桃-》黑桃 数字从3开始，然后是4
		// 举例如： 33334444555566667777。。。KKKKAAAA2222
		private var PlayerCards:Array = new Array();
		// player id
		public var pid:int;
		// 玩家的座位号
		private var selfseat:int;
		// 当前出牌玩家的座位号
		public var curPlayer:int;
		// 记录其他玩家出的牌
		// 按照
		private var deskCards0:Array = new Array();
		private var deskCards1:Array = new Array();
		private var deskCards2:Array = new Array();
		private var deskCards3:Array = new Array();
		
		//////////////////////////////////////////////////////////////////////////////
		// card height ZOrder
		private var BG_BaseZOrder:int = 0;
		private var card_BaseZOrder:int = 10;
		private var cardback_BaseZOrder:int	 = 100;
		private var cardplayed0_BaseZOrder:int	 = 200;
		private var cardplayed1_BaseZOrder:int	 = 220;
		private var cardplayed2_BaseZOrder:int	 = 240;
		private var cardplayed3_BaseZOrder:int	 = 260;

		
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
			BGImg.startupGameObject(GraphicsResource(ResourceManager.BG00Res), new Point(0,0), new Rectangle(0,0, 800, 600),BG_BaseZOrder);
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
		}

		public function gameStart():void
		{
			// enable button
			Application.application.btnSendCards.visible = true;
			Application.application.btnSendCards.enabled = false;
			Application.application.btnDiscard.visible = true;
			Application.application.btnDiscard.enabled = false;
			Application.application.btnHint.visible = true;
			// 对得到的牌进行排序并显示
			sortCards();
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			for(var i:int=0; i<PlayerCards.length; i++)
			{
				var go:GameObject = new GameObject();
				var pt:Point = new Point(cardStandardX-(PlayerCards.length*cardsIntervalX/2)+i*cardsIntervalX,cardStandardY);
				// 传入的是左上的位置坐标
				go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(PlayerCards[i])), pt, rt,card_BaseZOrder+i);
				go.setName("Card");
				go.setId(PlayerCards[i]);
				//GameObjectManager.Instance.addBaseObject(go);
			}
			
			// 左边的玩家
			var cardbackleft:GameObject = new GameObject();
			cardbackleft.startupGameObject(GraphicsResource(ResourceManager.CardBack1Res), new Point(leftCardback_x,leftCardback_y), 
					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder);
			cardbackleft.setName("Cardback");
			// 上面的玩家
			var cardbackup:GameObject = new GameObject();
			cardbackup.startupGameObject(GraphicsResource(ResourceManager.CardBack2Res), new Point(upCardback_x,upCardback_y), 
					new Rectangle(0,0,cardback2_w, cardback2_h),cardback_BaseZOrder+1);
			cardbackup.setName("Cardback");
			// 右边的玩家
			var cardbackright:GameObject = new GameObject();
			cardbackright.startupGameObject(GraphicsResource(ResourceManager.CardBack1Res), new Point(rightCardback_x,rightCardback_y), 
					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder+2);
			cardbackright.setName("Cardback");
		}
		//
		public function sortCards():void
		{
			var i:int;
			var j:int;
			var k:int;
			// for debug
//			for(j=0;j<27;j++)
//			{
//				PlayerCards.push(j+5);
//			}
//			return;

			for(i=0;i<4;i++)
			{
				if(NetManager.Instance.json1.players[i].pid == pid)		// 28 should be the play id,the we recorded
				{
					selfseat = i;
					for(j=0;j<27;j++)
					{
						PlayerCards.push(NetManager.Instance.json1.players[i].card[j]);
					}
					// do sort
					PlayerCards.sort(Array.NUMERIC);
					PlayerCards.reverse();

					break;
				}
			}
		}
		
		// 描画玩家打出来的牌
		public function drawOtherCards(cards:Array):void
		{
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			var pt:Point;
			var go:GameObject;
			// 更新玩家self的牌
			var i:int;
			var id:int;
			if(cards[selfseat] != "null")
			{
				for(i=0;i<cards[selfseat].length;i++)
				{
					go = new GameObject();
					pt = new Point(playedCardStdX-(cards[selfseat].length*cardsIntervalX/2)+i*cardsIntervalX,playedCardStdY);
					go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(cards[selfseat][i])), pt, rt,cardplayed0_BaseZOrder);
					go.setName("PlayedCard");
					go.setId(cards[selfseat][i]);
				}
			}
			// 更新右边的玩家
			id = (selfseat+1)%4;
			if(cards[id] != "null")
			{
				for(i=0;i<cards[id].length;i++)
				{
					go = new GameObject();
					pt = new Point(playedrightCardStdX, playedrightCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
					go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(cards[id][i])), pt, rt,cardplayed1_BaseZOrder);
					go.setName("PlayedCard");
					go.setId(cards[id][i]);
				}
			}
			// 更新上边的玩家
			id = (selfseat+2)%4;
			if(cards[id] != "null")
			{
				for(i=0;i<cards[id].length;i++)
				{
					go = new GameObject();
					pt = new Point(playedupCardStdX-(cards[id].length*cardsIntervalX/2)+i*cardsIntervalX,playedrightCardStdY);
					go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(cards[id][i])), pt, rt,cardplayed2_BaseZOrder);
					go.setName("PlayedCard");
					go.setId(cards[id][i]);
				}
			}
			// 更新左边的玩家
			id = (selfseat+3)%4;
			if(cards[id] != "null")
			{
				for(i=0;i<cards[id].length;i++)
				{
					go = new GameObject();
					pt = new Point(playedleftCardStdX, playedleftCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
					go.startupGameObject(GraphicsResource(ResourceManager.CardsRes.getItemAt(cards[id][i])), pt, rt,cardplayed3_BaseZOrder);
					go.setName("PlayedCard");
					go.setId(cards[id][i]);
				}
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
						if(requestFlag)
						{
							NetManager.Instance.send(NetManager.send_updateWhileGame);
						}
						
						// 检测该次的出牌是否符合要求，能否出牌。
						if(GameObjectManager.Instance.checkCardtobePlayed())
						{
							// make chupai enable
							Application.application.btnSendCards.enabled = true;
						}
						else
						{
							Application.application.btnSendCards.enabled = false;
						}
					    GameObjectManager.Instance.enterFrame();
					break;
					case 3:
						GameObjectManager.Instance.enterFrame();
					break;
					case 4:	// 等待其他玩家准备完成
						// 在一定的频率下，发送消息，更新自己的数据。
						if(requestFlag)
						{
							NetManager.Instance.send(NetManager.send_updateWhileGame);
						}
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
		
		public function click(event:MouseEvent):void
		{
			if(gameState == 2 && curPlayer == selfseat)
			{
				GameObjectManager.Instance.click(event);
			}
		}
	}
}