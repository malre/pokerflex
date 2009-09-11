package poker
{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	import poker.gamestate.StateUpdateWhileGame;
	
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		public static const cardsAmount:int = 54;
		// 玩家的牌的中心基准点
		public static const cardStandardX:int = 280;
		public static const cardStandardY:int = 440;
		public static const playedCardStdX:int = 280;
		public static const playedCardStdY:int = 340;
		// 其他玩家的牌堆的显示位置
		// 左边玩家的位置，
		private static const leftCardback_x:int = 26;
		private static const leftCardback_y:int = 220;
		private static const playedleftCardStdX:int = 120;
		private static const playedleftCardStdY:int = 238;
		// 上面玩家的位置，
		private static const upCardback_x:int = 240;
		private static const upCardback_y:int = 27;
		private static const playedupCardStdX:int = 262;
		private static const playedupCardStdY:int = 150;
		// 右边玩家的位置
		private static const rightCardback_x:int = 495;
		private static const rightCardback_y:int = 220;
		private static const playedrightCardStdX:int = 410;
		private static const playedrightCardStdY:int = 239;
		// 牌堆类型1的宽高
		private static const cardback1_w:int = 56;//61;
		private static const cardback1_h:int = 76;//95;
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
		public static const cardsIntervalY:int = 18;
		// BG
		private var BGImg:GameObject = null;
		// 记录玩家的牌的数组
		// 关于玩家的牌的顺序的定义如下：
		// 按照花色的顺序从 方块-》梅花-》红桃-》黑桃 数字从3开始，然后是4
		// 举例如： 33334444555566667777。。。KKKKAAAA2222
		private var PlayerCards:Array = new Array();
		private var PlayerCardsLeft:Array = new Array();
		private var PlayerCardsUp:Array = new Array();
		private var PlayerCardsRight:Array = new Array();
		// player id
		public var pid:int;
		// 玩家的座位号
		public var selfseat:int;
		// 当前出牌玩家的座位号
		public var curPlayer:int;
		public var lastPlayer:int;
		// 记录其他玩家出的牌
		// 按照
		private var deskCards0:Array = new Array();
		private var deskCards1:Array = new Array();
		private var deskCards2:Array = new Array();
		private var deskCards3:Array = new Array();
		// 用来保存从服务器得到的出牌记录，供看牌器使用
		private var cardview0:Array = new Array();
		private var cardview1:Array = new Array();
		private var cardview2:Array = new Array();
		private var cardview3:Array = new Array();
		
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
		// 5 游戏结果发布画面
		public var gameState:int	= 0;
		// 0 没有状态，等待   1 发送了参加房间的消息以后，成功，  2 发送了参加房间的消息以后，失败 
		// 3 发送了准备完整的消息以后，成功， 4 发送了准备完成的消息以后，失败
		public var menuState:int	= 0;
		// 计时器
		private var lastFrameTime:Date = new Date();
		private static var requestInterval:Number = 3;
		private var requestFlag:Boolean = false;
		// 用来记录一个收到消息的时间基数，如果这个数比原来的小就表示收到的是旧消息，不进行更新，否则的话进行正常的更新。
		private var recordTimeSec:int;
		//private var recordTimeMSec:number;
		// 保留最近一次的update值
		private var recordTimeStrLast:String;
		private var recordTimeStrCur:String;
		
		// 按键对应的判断变量,用来控制按键不会被多次按下
		public var btnState:int = 0;
		// 记录游戏的轮次
		public var gameCurRound:int	= 0;
		public var gameLastRound:int = 0;
		// 游戏中玩家的倒计时时间值
		public var gamePlayerLeftTimeDef:int = 30;
		private var gamePlayerLeftTimeCounter:int = -1;
		private var gpltStartTime:Date = new Date();
		private var gpltPlusTime:int = 0;

		public function Game()
		{
			//TODO: implement function
			init();
		}
		static public function get Instance():Game
		{
			if ( instance == null )
				instance = new Game();
			return instance;
		}
		
		// 完全的把所有用的纸牌的数据都预先生成
		// 
		public function init():void
		{
			GameObjectManager.Instance.startup();
			//创建所有的图像对象，并放到集合中去
			BGImg = new GameObject();
			BGImg.startupGameObject(GraphicsResource(ResourceManagerPoker.BG00Res), new Point(0,0), new Rectangle(0,0, 780, 560),BG_BaseZOrder);
			BGImg.setVisible(true);
			BGImg.setName("BG");
			// 104 cards
			var i:int,j:int;
			for(i=0;i<2;i++)
			{
				for(j=0;j<cardsAmount;j++)
				{
					var go:GameObject = new GameObject();
					go.setName("Card");
					go.setId(j);
					var pt:Point = new Point();
					var rt:Rectangle = new Rectangle(0, 0, cardsHeight, cardsWidth);
					// 传入的是左上的位置坐标
					go.startupGameObject(GraphicsResource(ResourceManagerPoker.CardsRes.getItemAt(j)), pt, rt,0);
				}
			}
			// 左边的玩家
			var cardbackleft:GameObject = new GameObject();
			cardbackleft.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack1Res), new Point(leftCardback_x,leftCardback_y), 
					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder);
			cardbackleft.setName("CardbackLeft");
			// 上面的玩家
			var cardbackup:GameObject = new GameObject();
			cardbackup.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack2Res), new Point(upCardback_x,upCardback_y), 
					new Rectangle(0,0,cardback2_w, cardback2_h),cardback_BaseZOrder+1);
			cardbackup.setName("CardbackUp");
			// 右边的玩家
			var cardbackright:GameObject = new GameObject();
			cardbackright.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack1Res), new Point(rightCardback_x,rightCardback_y), 
					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder+2);
			cardbackright.setName("CardbackRight");
		}
		
		// 各种按钮和图的初始化
		// 准备界面的所有的按钮的初始化
		public function readyStateInit():void
		{
			LobyManager.Instance.gamePoker.imgPlayerLeftPrepare.visible = false;
			LobyManager.Instance.gamePoker.imgPlayerLeftReady.visible = false;
			LobyManager.Instance.gamePoker.imgPlayerUpPrepare.visible = false;
			LobyManager.Instance.gamePoker.imgPlayerUpReady.visible = false;
			LobyManager.Instance.gamePoker.imgPlayerRightPrepare.visible = false;
			LobyManager.Instance.gamePoker.imgPlayerRightReady.visible = false;
		}
	
		//
		public function sortCards(obj:Object):void
		{
			var j:int;

			for(j=0;j<obj.cards[selfseat].number;j++)
			{
				PlayerCards.push(obj.cards[selfseat].card[j]);
			}
			// do sort
			PlayerCards.sort(Array.NUMERIC);
			PlayerCards.reverse();
		}
		
		public function clearPlayerCards():void
		{
			PlayerCards.length = 0;
			PlayerCardsLeft.length = 0;
			PlayerCardsUp.length = 0;
			PlayerCardsRight.length = 0;
		}
		// 描画玩家手上的牌
		public function drawPlayerCards(obj:Object):void
		{
			var i:int;
			// 是否需要显示
			if(obj.cards[selfseat].number != PlayerCards.length)
			{
				//清空原来的牌的记录
				GameObjectManager.Instance.setVisibleByName("Card", false);
				PlayerCards.length = 0;
				// 对得到的牌进行排序并显示
				sortCards(obj);
				var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
				for(i=0; i<PlayerCards.length; i++)
				{
					var pt:Point = new Point(cardStandardX-(PlayerCards.length*cardsIntervalX/2)+i*cardsIntervalX,cardStandardY);
					// 传入的是左上的位置坐标
					GameObjectManager.Instance.setSpecCardVisible(PlayerCards[i], "Card", pt, card_BaseZOrder+i, true);
				}
			}
			
		}
			
		// 描画玩家打出来的牌
		public function drawOtherCards(cards:Array, gamestate:int):void
		{
			// reset
			LobyManager.Instance.gamePoker.imgDiscardDown.visible = false;
			LobyManager.Instance.gamePoker.imgDiscardRight.visible = false;
			LobyManager.Instance.gamePoker.imgDiscardUp.visible = false;
			LobyManager.Instance.gamePoker.imgDiscardLeft.visible = false;
			
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			var pt:Point;
			var go:GameObject;
			// 更新玩家self的牌
			var i:int;
			var id:int;
			// 如果该回合是自己出牌，将先清除桌面上所有的牌
			if(curPlayer == selfseat && gamestate == 0)
			{
				GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
				LobyManager.Instance.gamePoker.imgDiscardDown.visible = false;
			}
			else
			{
				if(cards[selfseat] == "null")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
				}
				else if(cards[selfseat] == "pass")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
					LobyManager.Instance.gamePoker.imgDiscardDown.visible = true;
				}
				else
				{
					// 查看本次得到的数据是否和上次的一样
					var flag:Boolean = false;
					if(cards[selfseat].length != deskCards0.length)
					{
						flag = true;
					}
					else
					{
						// 判断每一个元素是否相同
						for(i=0;i<cards[selfseat].length;i++)
						{
							if(cards[selfseat][i] != deskCards0[i])
							{
								flag = true;
								break;
							}
						}
						
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards0.length = 0;
						GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
						// 重新描画
						for(i=0;i<cards[selfseat].length;i++)
						{
							pt = new Point(playedCardStdX-(cards[selfseat].length*cardsIntervalX/2)+i*cardsIntervalX,playedCardStdY);
							GameObjectManager.Instance.setSpecCardVisible(cards[selfseat][i], "PlayedCardSelf", pt, cardplayed0_BaseZOrder+i, true);
						}
						deskCards0 = deskCards0.concat(cards[selfseat]);
					}
					else
					{
						// 如果该回合是自己出牌，将先清除桌面上所有的牌
						if(curPlayer == selfseat)
						{
							GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
						}
					}
				}
			}
			// 更新右边的玩家
			id = (selfseat+1)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.setVisibleByName("PlayedCardRight", false);
				LobyManager.Instance.gamePoker.imgDiscardRight.visible = false;
			}
			else
			{
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardRight", false);
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardRight", false);
					LobyManager.Instance.gamePoker.imgDiscardRight.visible = true;
				}
				else
				{
					flag = false;
					if(cards[id].length != deskCards1.length)
					{
						flag = true;
					}
					else
					{
						// 判断每一个元素是否相同
						for(i=0;i<cards[id].length;i++)
						{
							if(cards[id][i] != deskCards1[i])
							{
								flag = true;
								break;
							}
						}
						
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards1.length = 0;
						GameObjectManager.Instance.setVisibleByName("PlayedCardRight", false);
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
							
							pt = new Point(playedrightCardStdX, playedrightCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardRight", pt, cardplayed1_BaseZOrder+i, true);
						}
						deskCards1 = deskCards1.concat(cards[id]);
					}
				}
			}
			// 更新上边的玩家
			id = (selfseat+2)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.setVisibleByName("PlayedCardUp", false);
				LobyManager.Instance.gamePoker.imgDiscardUp.visible = false;
			}
			else
			{
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardUp", false);
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardUp", false);
					LobyManager.Instance.gamePoker.imgDiscardUp.visible = true;
				}
				else
				{
					flag = false;
					if(cards[id].length != deskCards2.length)
					{
						flag = true;
					}
					else
					{
						// 判断每一个元素是否相同
						for(i=0;i<cards[id].length;i++)
						{
							if(cards[id][i] != deskCards2[i])
							{
								flag = true;
								break;
							}
						}
						
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards2.length = 0;
						GameObjectManager.Instance.setVisibleByName("PlayedCardUp", false);
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
							pt = new Point(playedupCardStdX-(cards[id].length*cardsIntervalX/2)+i*cardsIntervalX,playedupCardStdY);
							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardUp", pt, cardplayed2_BaseZOrder+i, true);
						}
						deskCards2 = deskCards2.concat(cards[id]);
					}
				}
			}
			// 更新左边的玩家
			id = (selfseat+3)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.setVisibleByName("PlayedCardLeft", false);
				LobyManager.Instance.gamePoker.imgDiscardLeft.visible = false;
			}
			else
			{
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardLeft", false);
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.setVisibleByName("PlayedCardLeft", false);
					LobyManager.Instance.gamePoker.imgDiscardLeft.visible = true;
				}
				else
				{
					flag = false;
					if(cards[id].length != deskCards3.length)
					{
						flag = true;
					}
					else
					{
						// 判断每一个元素是否相同
						for(i=0;i<cards[id].length;i++)
						{
							if(cards[id][i] != deskCards3[i])
							{
								flag = true;
								break;
							}
						}
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards3.length = 0;
						GameObjectManager.Instance.setVisibleByName("PlayedCardLeft", false);
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
	
							pt = new Point(playedleftCardStdX, playedleftCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardLeft", pt, cardplayed3_BaseZOrder+i, true);
						}
						deskCards3 = deskCards3.concat(cards[id]);
					}
				}
			}
		}
		
		/**
		 * 描画除自己以外的玩家的手牌
		 * @param obj
		 * 	 传入的数据对象
		 * @param pos
		 * 	需要描画的玩家的座位位置编号
		 */
		public function drawPlayerHandCards(obj:Object, pos:int):void
		{
			// 根据位置不同，牌的排布会有所不同
			var i:int,j:int,k:int;
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight);
			var pt:Point;
			if(pos == (selfseat+1)%4)	// 右手边
			{
				GameObjectManager.Instance.setVisibleByName("CardbackRight", false);
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsRight.length)
				{
					//清空原来的牌的记录
					GameObjectManager.Instance.setVisibleByName("HandCardRight", false);
					PlayerCardsRight.length = 0;
					// 对得到的牌进行排序并显示
					for(j=0;j<obj.cards[pos].number;j++)
					{
						PlayerCardsRight.push(obj.cards[pos].card[j]);
					}
					// do sort
					PlayerCardsRight.sort(Array.NUMERIC);
					PlayerCardsRight.reverse();
					for(k=0; k<PlayerCardsRight.length; k++)
					{
						pt = new Point(rightCardback_x,rightCardback_y-(PlayerCardsRight.length*cardsIntervalY/2)+k*cardsIntervalY);
						// 传入的是左上的位置坐标
						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsRight[i], "HandCardRight", pt, cardback_BaseZOrder+k, true);
						pt = null;
					}
				}
			}
			else if(pos == (selfseat+2)%4)	// 对家
			{
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsUp.length)
				{
					GameObjectManager.Instance.setVisibleByName("CardbackUp", false);
					//清空原来的牌的记录
					GameObjectManager.Instance.setVisibleByName("HandCardUp", false);
					PlayerCardsUp.length = 0;
					// 对得到的牌进行排序并显示
					for(j=0;j<obj.cards[pos].number;j++)
					{
						PlayerCardsUp.push(obj.cards[pos].card[j]);
					}
					// do sort
					PlayerCardsUp.sort(Array.NUMERIC);
					PlayerCardsUp.reverse();
					for(k=0; k<PlayerCardsUp.length; k++)
					{
						pt = new Point(upCardback_x-(PlayerCardsUp.length*cardsIntervalX/2)+i*cardsIntervalX,upCardback_y);
						// 传入的是左上的位置坐标
						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsUp[i], "HandCardUp", pt, cardback_BaseZOrder+k, true);
						pt = null;
					}
				}
			}
			else if(pos == (selfseat+3)%4)	// 左手边
			{
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsLeft.length)
				{
					GameObjectManager.Instance.setVisibleByName("CardbackLeft", false);
					//清空原来的牌的记录
					GameObjectManager.Instance.setVisibleByName("HandCardLeft", false);
					PlayerCardsLeft.length = 0;
					// 对得到的牌进行排序并显示
					for(j=0;j<obj.cards[pos].number;j++)
					{
						PlayerCardsLeft.push(obj.cards[pos].card[j]);
					}
					// do sort
					PlayerCardsLeft.sort(Array.NUMERIC);
					PlayerCardsLeft.reverse();
					for(k=0; k<PlayerCardsLeft.length; k++)
					{
						pt = new Point(leftCardback_x,leftCardback_y-(PlayerCardsLeft.length*cardsIntervalY/2)+k*cardsIntervalY);
						// 传入的是左上的位置坐标
						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsLeft[i], "HandCardLeft", pt, cardback_BaseZOrder+k, true);
						pt = null;
					}
				}
			}
			rt = null;
		}
		
		// function for find player pos
		private function getPlayerIndexByPos(obj:Object, pos:int):int
		{
			var index:int = -1;
			
			for(var i:int=0;i<4;i++)
			{
				if(obj.players.hasOwnProperty(i))
				{
					if(obj.players[i].pos == pos)
						return i;
				}
			}
			
			return index; 
		}
		// 更新玩家的信息
		public function updatePlayerName(obj:Object):void
		{
			// 玩家的姓名，显示在右上
			if(obj.hasOwnProperty("players"))
			{
				LobyManager.Instance.gamePoker.textPlayerSelf.text = obj.players[getPlayerIndexByPos(obj, selfseat)].name;

				// partner
				if(getPlayerIndexByPos(obj, (selfseat+2)%4) != -1)
				{
					LobyManager.Instance.gamePoker.textPlayerPartner.text = obj.players[getPlayerIndexByPos(obj, (selfseat+2)%4)].name;
					LobyManager.Instance.gamePoker.Lable_playernameUp.text = LobyManager.Instance.gamePoker.textPlayerPartner.text;
				}
				else
				{
					LobyManager.Instance.gamePoker.textPlayerPartner.text = "";
					LobyManager.Instance.gamePoker.Lable_playernameUp.text = "";
				}
				if(getPlayerIndexByPos(obj,(selfseat+1)%4) != -1)
				{
					LobyManager.Instance.gamePoker.textPlayerEmy1.text = obj.players[getPlayerIndexByPos(obj, (selfseat+1)%4)].name;
					LobyManager.Instance.gamePoker.Lable_playernameRight.text = LobyManager.Instance.gamePoker.textPlayerEmy1.text; 
				}
				else
				{
					LobyManager.Instance.gamePoker.textPlayerEmy1.text = "";
					LobyManager.Instance.gamePoker.Lable_playernameRight.text = ""; 
				}
				if(getPlayerIndexByPos(obj, (selfseat+3)%4) != -1)
				{
					LobyManager.Instance.gamePoker.textPlayerEmy2.text = obj.players[getPlayerIndexByPos(obj, (selfseat+3)%4)].name;
					LobyManager.Instance.gamePoker.Lable_playernameLeft.text = LobyManager.Instance.gamePoker.textPlayerEmy2.text;
				}
				else
				{
					LobyManager.Instance.gamePoker.textPlayerEmy2.text = "";
					LobyManager.Instance.gamePoker.Lable_playernameLeft.text = "";
				}
			}
		}
		public function updateCurPlayerIcon(obj:Object):void
		{
			// 当前出牌玩家，显示在主画面上
/*			if(obj.hasOwnProperty("play"))
			{
				if(obj.play.hasOwnProperty("next"))
				{
					// 将显示的图打开 
					LobyManager.Instance.gamePoker.label_thinking.visible = true;
					if(obj.play.next == (selfseat+1)%4)
					{
						LobyManager.Instance.gamePoker.label_thinking.x =485;
						LobyManager.Instance.gamePoker.label_thinking.y =250;
					}
					else if(obj.play.next == (selfseat+2)%4)
					{
						LobyManager.Instance.gamePoker.label_thinking.x =250;
						LobyManager.Instance.gamePoker.label_thinking.y =40;
					}
					else if(obj.play.next == (selfseat+3)%4)
					{
						LobyManager.Instance.gamePoker.label_thinking.x =30;
						LobyManager.Instance.gamePoker.label_thinking.y =250;
					}
					else
					{
						// 将显示的图打开 
						LobyManager.Instance.gamePoker.label_thinking.visible = false;
					}
				}
			}*/
			// 更新玩家出牌的剩余时间
			if(obj.hasOwnProperty("time"))
			{
				if(obj.time != -1)
				{
					LobyManager.Instance.gamePoker.label_leftTimeCounter.visible = true;
					LobyManager.Instance.gamePoker.label_leftTimeCounter.text = obj.time.toString();
					if(obj.play.next == (selfseat+1)%4)
					{
						LobyManager.Instance.gamePoker.label_leftTimeCounter.x =485;
						LobyManager.Instance.gamePoker.label_leftTimeCounter.y =270;
					}
					else if(obj.play.next == (selfseat+2)%4)
					{
						LobyManager.Instance.gamePoker.label_leftTimeCounter.x =250;
						LobyManager.Instance.gamePoker.label_leftTimeCounter.y =60;
					}
					else if(obj.play.next == (selfseat+3)%4)
					{
						LobyManager.Instance.gamePoker.label_leftTimeCounter.x =30;
						LobyManager.Instance.gamePoker.label_leftTimeCounter.y =270;
					}
					else
					{
						LobyManager.Instance.gamePoker.label_leftTimeCounter.x =250;
						LobyManager.Instance.gamePoker.label_leftTimeCounter.y =400;
					}
				}
				else{
					LobyManager.Instance.gamePoker.label_leftTimeCounter.visible = false;
				}
			}

		}
		public function updatePlayerReadyState(obj:Object):void
		{
			// 玩家的状态
			if(obj.hasOwnProperty("players"))
			{
				// partner
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+2)%4) ))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+2)%4)].ready)
					{
						LobyManager.Instance.gamePoker.imgPlayerUpPrepare.visible = false;
						LobyManager.Instance.gamePoker.imgPlayerUpReady.visible = true;
					}
					else
					{
						LobyManager.Instance.gamePoker.imgPlayerUpPrepare.visible = true;
						LobyManager.Instance.gamePoker.imgPlayerUpReady.visible = false;
					}
				}
				else{
					LobyManager.Instance.gamePoker.imgPlayerUpPrepare.visible = false;
					LobyManager.Instance.gamePoker.imgPlayerUpReady.visible = false;
				}
				
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+1)%4)))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+1)%4)].ready)
					{
						LobyManager.Instance.gamePoker.imgPlayerRightPrepare.visible = false;
						LobyManager.Instance.gamePoker.imgPlayerRightReady.visible = true;
					}
					else
					{
						LobyManager.Instance.gamePoker.imgPlayerRightPrepare.visible = true;
						LobyManager.Instance.gamePoker.imgPlayerRightReady.visible = false;
					}
				}
				else{
					LobyManager.Instance.gamePoker.imgPlayerRightPrepare.visible = false;
					LobyManager.Instance.gamePoker.imgPlayerRightReady.visible = false;
				}
				
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+3)%4) ))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+3)%4)].ready)
					{
						LobyManager.Instance.gamePoker.imgPlayerLeftPrepare.visible = false;
						LobyManager.Instance.gamePoker.imgPlayerLeftReady.visible = true;
					}
					else
					{
						LobyManager.Instance.gamePoker.imgPlayerLeftPrepare.visible = true;
						LobyManager.Instance.gamePoker.imgPlayerLeftReady.visible = false;
					}
				}
				else{
					LobyManager.Instance.gamePoker.imgPlayerLeftPrepare.visible = false;
					LobyManager.Instance.gamePoker.imgPlayerLeftReady.visible = false;
				}
			}
		}
		// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
		public function updatePlayerCardsInfo(obj:Object):void
		{
			// partner
			if(obj.cards.hasOwnProperty( ((selfseat+2)%4).toString() ))
			{
				LobyManager.Instance.gamePoker.Label_leftcardsnumUp.text = "("+obj.cards[(selfseat+2)%4].number+")";
				LobyManager.Instance.gamePoker.Label_leftcardsnumUp.visible = true;
				if(obj.cards[(selfseat+2)%4].number == 0)
				{
					GameObjectManager.Instance.setVisibleByName("CardbackUp", false);
				}
			}
			if(obj.cards.hasOwnProperty( ((selfseat+1)%4).toString() ))
			{
				LobyManager.Instance.gamePoker.Label_leftcardsnumRight.text = "("+obj.cards[(selfseat+1)%4].number+")";
				LobyManager.Instance.gamePoker.Label_leftcardsnumRight.visible = true;
				if(obj.cards[(selfseat+1)%4].number == 0)
				{
					GameObjectManager.Instance.setVisibleByName("CardbackRight", false);
				}
			}
			if(obj.cards.hasOwnProperty( ((selfseat+3)%4).toString() ))
			{
				LobyManager.Instance.gamePoker.Label_leftcardsnumLeft.text = "("+obj.cards[(selfseat+3)%4].number+")";
				LobyManager.Instance.gamePoker.Label_leftcardsnumLeft.visible = true;
				if(obj.cards[(selfseat+3)%4].number == 0)
				{
					GameObjectManager.Instance.setVisibleByName("CardbackLeft", false);
				}
			}
			
			// 当前出牌玩家，显示在主画面上
			if(obj.play.hasOwnProperty("next"))
			{
				// 将显示的图打开 
				LobyManager.Instance.gamePoker.label_thinking.visible = true;
				if(obj.play.next == (selfseat+1)%4)
				{
					LobyManager.Instance.gamePoker.label_thinking.x =485;
					LobyManager.Instance.gamePoker.label_thinking.y =250;
				}
				else if(obj.play.next == (selfseat+2)%4)
				{
					LobyManager.Instance.gamePoker.label_thinking.x =250;
					LobyManager.Instance.gamePoker.label_thinking.y =40;
				}
				else if(obj.play.next == (selfseat+3)%4)
				{
					LobyManager.Instance.gamePoker.label_thinking.x =30;
					LobyManager.Instance.gamePoker.label_thinking.y =250;
				}
				else
				{
					// 将显示的图打开 
					LobyManager.Instance.gamePoker.label_thinking.visible = false;
				}
			}
		}
		// 对得到的时间进行修正
		public function modifyPlayerLefttime(obj:Object):void
		{
			var diff:int = obj.time - gamePlayerLeftTimeCounter;
			gpltPlusTime = diff;
		}
		public function updatePlayerLeftTime():void
		{
			// 每帧都进行时间的计算，并自动的进行计时
			var thisFrame:Date = new Date();
			var difference:Number = (thisFrame.getTime() - gpltStartTime.getTime())/1000.0;
			gamePlayerLeftTimeCounter = gamePlayerLeftTimeDef - difference + gpltPlusTime;
			// 计时时间到了，进行一次连接请求
			if(gamePlayerLeftTimeCounter <= 0)
			{
				gamePlayerLeftTimeCounter = 0;
				// 这个立即更新，可能会因为前一次的更新没有完成而产生等待，并不是真正意义上的立即更新
				updateImmediately();
			}
			LobyManager.Instance.gamePoker.label_leftTimeCounter.text = gamePlayerLeftTimeCounter.toString();
		}
		public function initPlayerLeftStartTime():void
		{
			gpltStartTime = new Date();
			gamePlayerLeftTimeCounter = gamePlayerLeftTimeDef;
		}
		public function updateImmediately():void
		{
			requestFlag = true;
    		lastFrameTime = new Date();
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

			switch(gameState)
			{
				case 0:
				break;
				case 1:
				break;
				case 2:
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileGame);
						requestFlag = false;
						if(curPlayer != selfseat)
						{
							LobyManager.Instance.gamePoker.btnSendCards.visible = false;
							LobyManager.Instance.gamePoker.btnDiscard.visible = false;
							LobyManager.Instance.gamePoker.btnHint.visible = false;
						}
					}
					// 轮到自己出牌,并且按钮没有被按下
					if(curPlayer == selfseat)
					{
						// 检测该次的出牌是否符合要求，能否出牌。
						var checkarr:Array = new Array();
						if(curPlayer == lastPlayer)
						{
							// 这意味着玩家自己出的牌最大，他可以没有限制的继续出
							// 这个时候不能够放弃
							LobyManager.Instance.gamePoker.btnDiscard.enabled = false;
						}
						else
						{
							checkarr = checkarr.concat(StateUpdateWhileGame.Instance.lastSuccData.play.last_card);
						}
						if(GameObjectManager.Instance.checkCardtobePlayed(checkarr.sort(Array.NUMERIC)))
						{
							// make chupai enable
							LobyManager.Instance.gamePoker.btnSendCards.enabled = true;
						}
						else
						{
							LobyManager.Instance.gamePoker.btnSendCards.enabled = false;
						}
					    checkarr = null;
					}
					updatePlayerLeftTime();
				    GameObjectManager.Instance.enterFrame();
				break;
				case 3:
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileWait);
						requestFlag = false;
					}
					GameObjectManager.Instance.enterFrame();
				break;
				case 4:	// 等待其他玩家准备完成
					// 在一定的频率下，发送消息，更新自己的数据。
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileGame);
						requestFlag = false;
					}
					GameObjectManager.Instance.enterFrame();
				break;
				case 5:
					GameObjectManager.Instance.enterFrame();
				break;
			}
		}
		
		public function getSelfseat(obj:Object):void
		{
			for(var i:int=0;i<4;i++)
			{
				if(obj.players.hasOwnProperty(i.toString()))
				{
					if(obj.players[i].pid == pid)		// 28 should be the play id,the we recorded
					{
						// 获得玩家的座位号
						selfseat = obj.players[i].pos;
						break;
					}
				}
			}
		}
		
		////////////////////////////////////////////////////////////////////////////////
		// 描画特殊应用 
		// 算牌器
		// 数据从服务器得到，本地不进行计算, 所有的数据进行分析处理
		////////////////////////////////////////////////////////////////////////////////
		public function ViewCards():void
		{
			// 首先验证数据的有效性
			//if(NetManager.Instance.json1.history
			{
				
			}
			//for(
			//cardview0.
		}
		
		public function sendcards():void
		{
			NetManager.Instance.send(NetManager.send_sendcardsWhileGame);
		}
		public function pass():void
		{
			NetManager.Instance.send(NetManager.send_passWhileGame);
		}

		public function click(event:MouseEvent):void
		{
			if(gameState == 2)
			{
				//if(curPlayer == selfseat)
				{
					GameObjectManager.Instance.click(event);
				}
			}
		}
		// 用来判断帧的大小，处理先后顺序
		public function frametimeJudge(str:String):Boolean
		{
			// 先比较是否和前一次的相同，相同，不更新
			if(recordTimeStrLast == str)
				return false;
			// 比较和当前的是否相同，相同不更新
			if(recordTimeStrCur == str)
				return false;
				
			recordTimeStrLast = recordTimeStrCur;
			recordTimeStrCur = str;
			
/*			var blankindex:int = str.indexOf(" ");
			var msec:number = int(str.substr(0, blankindex));
			var sec:int = int(str.substr(blankindex+1, str.length- (blankindex+1)));
			
			if(sec > recordTimeSec)
			{
				recordTimeSec = sec;
				recordTimeMSec = msec;
				return true;
			}
			else if(sec == recordTimeSec)	{
				if(msec > recordTimeMSec)
				{
					recordTimeSec = sec;
					recordTimeMSec = msec;
					return true;
				}
			}*/
			return true;
		}
	}
}