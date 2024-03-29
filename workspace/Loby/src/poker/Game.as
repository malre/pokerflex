package poker
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import json.*;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.flash.UIMovieClip;
	
	import poker.gamestate.StateUpdateForFirstFrame;
	import poker.gamestate.StateUpdateWhileGame;
	
	import soundcontrol.SoundManager;
	
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		public static const cardsAmount:int = 54;
		// 玩家的牌的中心基准点
		public static const cardStandardX:int = 258;
		public static const cardStandardY:int = 390;
		public static const playedCardStdX:int = 258;
		public static const playedCardStdY:int = 308;
		// 其他玩家的牌堆的显示位置
		// 左边玩家的位置，
		private static const leftCardback_x:int = 15;
		private static const leftCardback_y:int = 332;
		private static const playedleftCardStdX:int = 120;
		private static const playedleftCardStdY:int = 236;
		// 上面玩家的位置，
		private static const upCardback_x:int = 338;
		private static const upCardback_y:int = 19;
		private static const playedupCardStdX:int = 262;
		private static const playedupCardStdY:int = 108;
		// 右边玩家的位置
		private static const rightCardback_x:int = 474;
		private static const rightCardback_y:int = 332;
		private static const playedrightCardStdX:int = 385;
		private static const playedrightCardStdY:int = 210;
		// 牌堆类型1的宽高
		private static const cardback1_w:int = 56;//61;
		private static const cardback1_h:int = 76;//95;
		// 牌堆类型2的宽高
		private static const cardback2_w:int = 70;
		private static const cardback2_h:int = 86;
		
		// 定义所有的牌在整图中的位置
		// 所有的牌的定义，按照花色的顺序从 方块-》梅花-》红桃-》黑桃
		// 牌值从3开始到2结束,所以是3333，4444，kkkk，AAAA，然后2222的顺序
		// 最后的52，53是joker--司令。
		private static var cardsRect:ArrayCollection = new ArrayCollection();
		// 牌的排列间隔
		public static const cardsWidth:int = 61;
		public static const cardsHeight:int = 86;
		public static const cardsIntervalX:int = 12;
		public static const cardsIntervalY:int = 16;
		// BG
		private var BGImg:GameObject = null;
		// 记录玩家的牌的数组
		// 关于玩家的牌的顺序的定义如下：
		// 按照花色的顺序从 方块-》梅花-》红桃-》黑桃 数字从3开始，然后是4
		// 举例如： 33334444555566667777。。。KKKKAAAA2222
		public var PlayerCards:Array = new Array();
		public var PlayerCardsObject:Array = new Array();
		public var PlayerLastPlayedCards:Array = new Array();
		private var PlayerCardsLeft:Array = new Array();
		private var PlayerCardsUp:Array = new Array();
		private var PlayerCardsRight:Array = new Array();
		// player id
		public var pid:int;
		// 玩家的座位号
		public var selfseat:int;
		// 当前出牌玩家的座位号
		public var curPlayer:int;
		public var curPlayerLast:int;
			// 这个指最后出牌的玩家编号
		public var lastPlayer:int;
		
		// 记录其他玩家出的牌
		// 按照
		private var deskCards0:Array = new Array();
		private var deskCards1:Array = new Array();
		private var deskCards2:Array = new Array();
		private var deskCards3:Array = new Array();
		private var deskCards0LastAmount:int;
		private var deskCards1LastAmount:int;
		private var deskCards2LastAmount:int;
		private var deskCards3LastAmount:int;
		
		//////////////////////////////////////////////////////////////////////////////
		// card height ZOrder
		private const cardback_BaseZOrder:int	 = 100;
		private const BG_BaseZOrder:int = 0;
		private const cardplayed0_BaseZOrder:int	 = 200;
		private const cardplayed1_BaseZOrder:int	 = 220;
		private const cardplayed2_BaseZOrder:int	 = 240;
		private const cardplayed3_BaseZOrder:int	 = 260;
		private const card_BaseZOrder:int = 500;

		
		// 游戏中的各个阶段的状态定义
		// 0,没有状态  1, 游戏场景的初始化过程，fadein flash部分 10,播放一个flash 
		// 2, 游戏过程 3 发送举手消息以前 4 发送举手消息以后
		// 5, 游戏结果发布画面
		// 20,最开始游戏的时候的发牌演示
		public var gameState:int	= 0;
			//
			public var cardAnimateCounter:int = 0;
			public var cardAnimateArray:Array = new Array();
			// 用来标识玩家是否使用了托管
		public var isCpuAI:Boolean = false;
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
		
		// 游戏中玩家的倒计时时间值
		public var gamePlayerLeftTimeDef:int = 30;
		private var gamePlayerLeftTimeCounter:int = -1;
		private var gpltStartTime:Date = new Date();
		private var gpltPlusTime:int = 0;
		// 增加四个用来控制pass动画的变量，
		// 当显示过一次pass的动画以后就不会重复的显示了
//		private var bPassAnimatePlayedUp:Boolean = false;
//		private var bPassAnimatePlayedLeft:Boolean = false;
//		private var bPassAnimatePlayedDown:Boolean = false;
//		private var bPassAnimatePlayedRight:Boolean = false;
		
		// 用来记录游戏中提示用的数据
		private var lastCard:Array = new Array();
		private var hintCards:Array = new Array();
		private var hintTimes:int = 0;
		// 记录游戏中玩家的数据，右边的datagrid显示用的数据集
//		[Bindable]
//		public var tablelist:ArrayCollection = new ArrayCollection();


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
//					go.startupGameObject(GraphicsResource(ResourceManagerPoker.CardsRes.getItemAt(j)), pt, rt,0);
				}
			}
//			// 左边的玩家
//			var cardbackleft:GameObject = new GameObject();
//			cardbackleft.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack1Res), new Point(leftCardback_x,leftCardback_y), 
//					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder);
//			cardbackleft.setName("CardbackLeft");
//			// 上面的玩家
//			var cardbackup:GameObject = new GameObject();
//			cardbackup.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack1Res), new Point(upCardback_x,upCardback_y), 
//					new Rectangle(0,0,cardback2_w, cardback2_h),cardback_BaseZOrder+1);
//			cardbackup.setName("CardbackUp");
//			// 右边的玩家
//			var cardbackright:GameObject = new GameObject();
//			cardbackright.startupGameObject(GraphicsResource(ResourceManagerPoker.CardBack1Res), new Point(rightCardback_x,rightCardback_y), 
//					new Rectangle(0,0,cardback1_w, cardback1_h),cardback_BaseZOrder+2);
//			cardbackright.setName("CardbackRight");
		}
		
		// 各种按钮和图的初始化
		// 准备界面的所有的按钮的初始化
		public function readyStateInit():void
		{
			FlexGlobals.topLevelApplication.gamePoker.imgPlayerLeftReady.visible = false;
			FlexGlobals.topLevelApplication.gamePoker.imgPlayerUpReady.visible = false;
			FlexGlobals.topLevelApplication.gamePoker.imgPlayerRightReady.visible = false;
			FlexGlobals.topLevelApplication.gamePoker.imgPlayerDownReady.visible = false;
		}
	
		//
		public function sortCards(obj:Object):Array
		{
			var j:int;
			var arr:Array = new Array();
			for(j=0;j<obj.cards[selfseat].number;j++)
			{
				arr.push(obj.cards[selfseat].card[j]);
			}
			// do sort
			arr.sort(Array.NUMERIC);
			arr.reverse();
			return arr;
		}
		
		public function clearPlayerCards():void
		{
			PlayerCards.length = 0;
			PlayerCardsObject.length = 0;
			PlayerCardsLeft.length = 0;
			PlayerCardsUp.length = 0;
			PlayerCardsRight.length = 0;
		}
		
		// 描画玩家手上的牌
		public function drawPlayerCards(obj:Object):void
		{
			var i:int,j:int;
			// 是否需要显示
			if(obj.cards[selfseat].number != PlayerCards.length)
			{
				var rt:Rectangle;
				var arr:Array = sortCards(obj);
				if(PlayerCards.length == 0)	// first time
				{
//					PlayerCards.push(arr);
					PlayerCards = arr;
					rt = new Rectangle(0,0,cardsWidth,cardsHeight);
					for(i=0; i<PlayerCards.length; i++)
					{
						var pt:Point = new Point(cardStandardX-(PlayerCards.length*cardsIntervalX/2)+i*cardsIntervalX,cardStandardY);
						// 传入的是左上的位置坐标
						//					GameObjectManager.Instance.setSpecCardVisible(PlayerCards[i], "Card", pt, card_BaseZOrder+i, true);
						
						PlayerCardsObject.push(GameObjectManager.Instance.addCardtoScreen(PlayerCards[i], "Card", pt));
						
					}
				}
				else
				{
					// 删除被打出的牌
					var temp1:Array = new Array();
					var temp2:Array = new Array();
//					var delcards:Array = new Array();
					for(i=0; i<PlayerCardsObject.length; i++){
						if( !Card(PlayerCardsObject[i]).isSelectedtoPost){
							temp1.push(PlayerCards[i]);
							temp2.push(PlayerCardsObject[i]);
						}
						else
						{
//							delcards.push(PlayerCardsObject[i]);
							GameObjectManager.Instance.removeSingleCardfromScreen(PlayerCardsObject[i], "Card");
						}
					}
					PlayerCards = temp1;
					PlayerCardsObject = temp2;
					

					// 修改剩下的牌的位置
					for(i=0; i<PlayerCards.length; i++)
					{
						Card(PlayerCardsObject[i]).x = cardStandardX-(PlayerCards.length*cardsIntervalX/2)+i*cardsIntervalX;
					}
				}
			}
			
		}
			
		// 描画玩家打出来的牌
		public function drawOtherCards(obj:Object, gamestate:int):void
		{
			var pok:poker = FlexGlobals.topLevelApplication.gamePoker as poker;
			// reset
			pok.imgDiscardDown.visible = false;
			pok.imgDiscardRight.visible = false;
			pok.imgDiscardUp.visible = false;
			pok.imgDiscardLeft.visible = false;
			
			var rt:Rectangle = new Rectangle(0,0,cardsWidth,cardsHeight)
			var pt:Point;
			var go:GameObject;
			var cards:Array = obj.play.history;
			// 更新玩家self的牌
			var i:int;
			var id:int;
			var SEid:int;
			// 如果该回合是自己出牌，将先清除桌面上所有的牌
			if(curPlayer == selfseat && gamestate == 0)
			{
//				GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
				GameObjectManager.Instance.removeCardfromScreen("PlayedCardSelf");
				pok.imgDiscardDown.visible = false;
			}
			else
			{
				if(cards[selfseat] == "null")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardSelf");
					deskCards0.length = 0;
				}
				else if(cards[selfseat] == "pass")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardSelf");
					pok.imgDiscardDown.visible = true;
					deskCards0.length = 0;
					// SE 这个步骤，如果是最后一步是不会到的，所以把pass，放到按钮上去
					//if(curPlayerLast == selfseat)
						//SoundManager.Instance().playSE("pass");
//					// 进行pass的动画演出，但是动画在进入pass状态以后只重复一次
//					if(!bPassAnimatePlayedDown)
//					{
//						LobyManager.Instance.gamePoker.imgDiscardDown.visible = true;
//						MovieClip(LobyManager.Instance.gamePoker.imgDiscardDown.content).gotoAndPlay(0);
//						bPassAnimatePlayedDown = true;
//					}
				}
				else
				{
//					// 当状态发生了切换以后， pass的动画被重置，可以再次播放
//					if(bPassAnimatePlayedDown)
//						bPassAnimatePlayedDown = false;
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
						// 再追加一个上一个出牌人和本次的出牌人是否相同的判断
						if(deskCards0LastAmount != PlayerCards.length)
						{
							flag = true;
						}
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards0.length = 0;
						// 记录上个出牌玩家
						deskCards0LastAmount = PlayerCards.length;
//						GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
						GameObjectManager.Instance.removeCardfromScreen("PlayedCardSelf");
						// 重新描画
						for(i=0;i<cards[selfseat].length;i++)
						{
							pt = new Point(playedCardStdX-(cards[selfseat].length*cardsIntervalX/2)+i*cardsIntervalX,playedCardStdY);
//							GameObjectManager.Instance.setSpecCardVisible(cards[selfseat][i], "PlayedCardSelf", pt, cardplayed0_BaseZOrder+i, true);
							GameObjectManager.Instance.addCardtoScreen(cards[selfseat][i], "PlayedCardSelf", pt);
						}
						deskCards0 = deskCards0.concat(cards[selfseat]);
						// 判断该次出牌是不是最近的一次出牌
						if(lastPlayer == selfseat)
						{
							// 对打出的牌进行判断，然后发出音效
							SEid = CardPattern.Instance.patternCheck(deskCards0.sort(Array.NUMERIC));
							if(SEid == 7 && deskCards0.length == 4)	// 王炸
								SEid = 36;
							SoundManager.Instance().playSEByCardtype(SEid, deskCards0[0]);
							// 同时播放动画
							var animation2:UIMovieClip;
							if(SEid >=8 && SEid <=15){	// 顺子
								animation2 = new donghuashunzi();
								animation2.x = 191;
								animation2.y = 300;
							}
							else if(SEid == 36){
								animation2 = new donghuatianwangzha();
								animation2.x = 456;
								animation2.y = 372;
							}
							else if(SEid >= 3 && SEid <= 7){
								animation2 = new donghuazhadan();
								animation2.x = 268;
								animation2.y = 358;
							}
							if(animation2 != null)
							{
								animation2.name = "anime";
								if(pok.animationGroup2.numElements >= 0)
								{
									pok.animationGroup2.removeAllElements();
								}
								pok.animationGroup2.addElement(animation2);
								animation2.play();
							}
						}
					}
					else
					{
						// 如果该回合是自己出牌，将先清除桌面上所有的牌
						if(curPlayer == selfseat)
						{
//							GameObjectManager.Instance.setVisibleByName("PlayedCardSelf", false);
							GameObjectManager.Instance.removeCardfromScreen("PlayedCardSelf");
						}
					}
				}
			}
			// 更新右边的玩家
			id = (selfseat+1)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.removeCardfromScreen("PlayedCardRight");
				deskCards1.length = 0;
				pok.imgDiscardRight.visible = false;
			}
			else
			{
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardRight");
					deskCards1.length = 0;
					// 当4个玩家的出牌都是null，并且玩家有值的情况下，需要喊pass,自己不用判断
					if(obj.cards[0].number==27&&obj.cards[1].number==27
						&&obj.cards[2].number==27&&obj.cards[3].number==27){
						
					}else if(cards[0]=="null" && cards[1]=="null" && cards[2]=="null" && cards[3]=="null"){
						if(curPlayerLast == id)
							SoundManager.Instance().playSE("pass");
					}
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardRight");
					deskCards1.length = 0;
					pok.imgDiscardRight.visible = true;
					// SE
					if(curPlayerLast == id)
						SoundManager.Instance().playSE("pass");
//					// 进行pass的动画演出，但是动画在进入pass状态以后只重复一次
//					if(!bPassAnimatePlayedRight)
//					{
//						LobyManager.Instance.gamePoker.imgDiscardRight.visible = true;
//						MovieClip(LobyManager.Instance.gamePoker.imgDiscardRight.content).gotoAndPlay(0);
//						bPassAnimatePlayedRight = true;
//					}
				}
				else
				{
//					// 当状态发生了切换以后， pass的动画被重置，可以再次播放
//					if(bPassAnimatePlayedRight)
//						bPassAnimatePlayedRight = false;
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
						// 再追加一个上一个出牌人和本次的出牌人是否相同的判断
						if(deskCards1LastAmount != PlayerCardsRight.length)
						{
							flag = true;
						}
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards1.length = 0;
						// 记录上个出牌玩家
						deskCards1LastAmount = PlayerCardsRight.length;
//						GameObjectManager.Instance.setVisibleByName("PlayedCardRight", false);
						GameObjectManager.Instance.removeCardfromScreen("PlayedCardRight");
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
							
							pt = new Point(playedrightCardStdX, playedrightCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
//							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardRight", pt, cardplayed1_BaseZOrder+i, true);
							GameObjectManager.Instance.addCardtoScreen(cards[id][i], "PlayedCardRight", pt);
						}
						deskCards1 = deskCards1.concat(cards[id]);
						if(lastPlayer == id)
						{
							// 对打出的牌进行判断，然后发出音效
							SEid = CardPattern.Instance.patternCheck(deskCards1.sort(Array.NUMERIC));
							if(SEid == 7 && deskCards1.length == 4)	// 王炸
								SEid = 36;
							SoundManager.Instance().playSEByCardtype(SEid, deskCards1[0]);
							// 同时播放动画
							var animation3:UIMovieClip;
							if(SEid >=8 && SEid <=15){	// 顺子
								animation3 = new donghuashunzi();
								animation3.x = 302;
								animation3.y = 180;
							}
							else if(SEid == 36){
								animation3 = new donghuatianwangzha();
								animation3.x = 456;
								animation3.y = 372;
							}
							else if(SEid >= 3 && SEid <= 7){
								animation3 = new donghuazhadan();
								animation3.x = 392;
								animation3.y = 234;
							}
							if(animation3 != null)
							{
								animation3.name = "anime";
								if(pok.animationGroup3.numElements >= 0)
								{
									pok.animationGroup3.removeAllElements();
								}
								pok.animationGroup3.addElement(animation3);
								animation3.play();
							}
						}
					}
				}
			}
			// 更新上边的玩家
			id = (selfseat+2)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.removeCardfromScreen("PlayedCardUp");
				deskCards2.length = 0;
				pok.imgDiscardUp.visible = false;
			}
			else
			{
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardUp");
					deskCards2.length = 0;
					// 当4个玩家的出牌都是null，并且玩家有值的情况下，需要喊pass,自己不用判断
					if(obj.cards[0].number==27&&obj.cards[1].number==27
						&&obj.cards[2].number==27&&obj.cards[3].number==27){
						
					}else if(cards[0]=="null" && cards[1]=="null" && cards[2]=="null" && cards[3]=="null"){
						if(curPlayerLast == id)
							SoundManager.Instance().playSE("pass");
					}
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardUp");
					deskCards2.length = 0;
					pok.imgDiscardUp.visible = true;
					// SE
					if(curPlayerLast == id)
						SoundManager.Instance().playSE("pass");
//					// 进行pass的动画演出，但是动画在进入pass状态以后只重复一次
//					if(!bPassAnimatePlayedUp)
//					{
//						LobyManager.Instance.gamePoker.imgDiscardUp.visible = true;
//						MovieClip(LobyManager.Instance.gamePoker.imgDiscardUp.content).gotoAndPlay(0);
//						bPassAnimatePlayedUp = true;
//					}
				}
				else
				{
//					// 当状态发生了切换以后， pass的动画被重置，可以再次播放
//					if(bPassAnimatePlayedUp)
//						bPassAnimatePlayedUp = false;
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
						// 再追加一个上一个出牌人和本次的出牌人是否相同的判断
						if(deskCards2LastAmount != PlayerCardsUp.length)
						{
							flag = true;
						}
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards2.length = 0;
						// 记录上个出牌玩家
						deskCards2LastAmount = PlayerCardsUp.length;
//						GameObjectManager.Instance.setVisibleByName("PlayedCardUp", false);
						GameObjectManager.Instance.removeCardfromScreen("PlayedCardUp");
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
							pt = new Point(playedupCardStdX-(cards[id].length*cardsIntervalX/2)+i*cardsIntervalX,playedupCardStdY);
//							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardUp", pt, cardplayed2_BaseZOrder+i, true);
							GameObjectManager.Instance.addCardtoScreen(cards[id][i], "PlayedCardUp", pt);
						}
						deskCards2 = deskCards2.concat(cards[id]);
						if(lastPlayer == id)
						{
							SEid = CardPattern.Instance.patternCheck(deskCards2.sort(Array.NUMERIC));
							if(SEid == 7 && deskCards2.length == 4)	// 王炸
								SEid = 36;
							SoundManager.Instance().playSEByCardtype(SEid, deskCards2[0]);
							// 同时播放动画
							var animation0:UIMovieClip;
							if(SEid >=8 && SEid <=15){	// 顺子
								animation0 = new donghuashunzi();
								animation0.x = 189;
								animation0.y = 83;
							}
							else if(SEid == 36){
								animation0 = new donghuatianwangzha();
								animation0.x = 456;
								animation0.y = 372;
							}
							else if(SEid >= 3 && SEid <= 7){
								animation0 = new donghuazhadan();
								animation0.x = 264;
								animation0.y = 148;
							}
							if(animation0 != null)
							{
								animation0.name = "anime";
								if(pok.animationGroup0.numElements >= 0)
								{
									pok.animationGroup0.removeAllElements();
								}
								pok.animationGroup0.addElement(animation0);
								animation0.play();
							}
						}
					}
				}
			}
			// 更新左边的玩家
			id = (selfseat+3)%4;
			// 如果该回合是出牌轮，将先清除桌面上所有的牌
			if(curPlayer == id && gamestate == 0)
			{
				GameObjectManager.Instance.removeCardfromScreen("PlayedCardLeft");
				deskCards3.length = 0;
				pok.imgDiscardLeft.visible = false;
//				// 进行pass的动画演出，但是动画在进入pass状态以后只重复一次
//				if(!bPassAnimatePlayedLeft)
//				{
//					LobyManager.Instance.gamePoker.imgDiscardLeft.visible = true;
//					MovieClip(LobyManager.Instance.gamePoker.imgDiscardLeft.content).gotoAndPlay(0);
//					bPassAnimatePlayedLeft = true;
//				}
			}
			else
			{
//				// 当状态发生了切换以后， pass的动画被重置，可以再次播放
//				if(bPassAnimatePlayedLeft)
//					bPassAnimatePlayedLeft = false;
				if(cards[id] == "null")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardLeft");
					deskCards3.length = 0;
					// 当4个玩家的出牌都是null，并且玩家有值的情况下，需要喊pass,自己不用判断
					if(obj.cards[0].number==27&&obj.cards[1].number==27
						&&obj.cards[2].number==27&&obj.cards[3].number==27){
						
					}else if(cards[0]=="null" && cards[1]=="null" && cards[2]=="null" && cards[3]=="null"){
						if(curPlayerLast == id)
							SoundManager.Instance().playSE("pass");
					}
				}
				else if(cards[id] == "pass")
				{
					GameObjectManager.Instance.removeCardfromScreen("PlayedCardLeft");
					deskCards3.length = 0;
					pok.imgDiscardLeft.visible = true;
					// SE
					if(curPlayerLast == id)
						SoundManager.Instance().playSE("pass");
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
						// 再追加一个上一个出牌人和本次的出牌人是否相同的判断
						if(deskCards3LastAmount != PlayerCardsLeft.length)
						{
							flag = true;
						}
					}
					if(flag)
					{
						// 删除之前该位置显示的所有卡牌
						deskCards3.length = 0;
						// 记录上个出牌玩家
						deskCards3LastAmount = PlayerCardsLeft.length;
//						GameObjectManager.Instance.setVisibleByName("PlayedCardLeft", false);
						GameObjectManager.Instance.removeCardfromScreen("PlayedCardLeft");
						// 重新描画
						for(i=0;i<cards[id].length;i++)
						{
	
							pt = new Point(playedleftCardStdX, playedleftCardStdY-(cards[id].length*cardsIntervalY/2)+i*cardsIntervalY);
//							GameObjectManager.Instance.setSpecCardVisible(cards[id][i], "PlayedCardLeft", pt, cardplayed3_BaseZOrder+i, true);
							GameObjectManager.Instance.addCardtoScreen(cards[id][i], "PlayedCardLeft", pt);
						}
						deskCards3 = deskCards3.concat(cards[id]);
						if(lastPlayer == id)
						{
							SEid = CardPattern.Instance.patternCheck(deskCards3.sort(Array.NUMERIC));
							if(SEid == 7 && deskCards3.length == 4)	// 王炸
								SEid = 36;
							SoundManager.Instance().playSEByCardtype(SEid, deskCards3[0]);
							// 同时播放动画
							var animation1:UIMovieClip;
							if(SEid >=8 && SEid <=15){	// 顺子
								animation1 = new donghuashunzi();
								animation1.x = 64;
								animation1.y = 200;
							}
							else if(SEid == 36){
								animation1 = new donghuatianwangzha();
								animation1.x = 456;
								animation1.y = 372;
							}
							else if(SEid >= 3 && SEid <= 7){
								animation1 = new donghuazhadan();
								animation1.x = 170;
								animation1.y = 254;
							}
							if(animation1 != null)
							{
								animation1.name = "anime";
								if(pok.animationGroup1.numElements >= 0)
								{
									pok.animationGroup1.removeAllElements();
								}
								pok.animationGroup1.addElement(animation1);
								animation1.play();
							}
						}
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
				GameObjectManager.Instance.removeOthersfromScreen("CardbackRight");
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsRight.length)
				{
					//清空原来的牌的记录
//					GameObjectManager.Instance.setVisibleByName("HandCardRight", false);
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
						pt = new Point(rightCardback_x,playedrightCardStdY-(PlayerCardsRight.length*cardsIntervalY/2)+k*cardsIntervalY);
						// 传入的是左上的位置坐标
//						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsRight[k], "HandCardRight", pt, cardback_BaseZOrder+k, true);
//						pt = null;
						GameObjectManager.Instance.addCardtoScreen(PlayerCardsRight[k], "HandCardRight", pt);
					}
				}
			}
			else if(pos == (selfseat+2)%4)	// 对家
			{
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsUp.length)
				{
					GameObjectManager.Instance.removeOthersfromScreen("CardbackUp");
					//清空原来的牌的记录
//					GameObjectManager.Instance.setVisibleByName("HandCardUp", false);
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
						pt = new Point(playedupCardStdX-(PlayerCardsUp.length*cardsIntervalX/2)+k*cardsIntervalX,upCardback_y);
						// 传入的是左上的位置坐标
//						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsUp[k], "HandCardUp", pt, cardback_BaseZOrder+k, true);
//						pt = null;
						GameObjectManager.Instance.addCardtoScreen(PlayerCardsUp[k], "HandCardUp", pt);
					}
				}
			}
			else if(pos == (selfseat+3)%4)	// 左手边
			{
				// 是否需要显示
				if(obj.cards[pos].number != PlayerCardsLeft.length)
				{
					GameObjectManager.Instance.removeOthersfromScreen("CardbackLeft");
					//清空原来的牌的记录
//					GameObjectManager.Instance.setVisibleByName("HandCardLeft", false);
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
						pt = new Point(leftCardback_x,playedleftCardStdY-(PlayerCardsLeft.length*cardsIntervalY/2)+k*cardsIntervalY);
						// 传入的是左上的位置坐标
//						GameObjectManager.Instance.setSpecCardVisible(PlayerCardsLeft[k], "HandCardLeft", pt, cardback_BaseZOrder+k, true);
//						pt = null;
						GameObjectManager.Instance.addCardtoScreen(PlayerCardsLeft[k], "HandCardLeft", pt);
					}
				}
			}
			rt = null;
		}
		// 控制显示所有的卡牌背面
		public function showCardback(flag:Boolean):void
		{
			if(flag)
			{
				GameObjectManager.Instance.addOtherstoScreen(ResourceManagerPoker.cardback1, "CardbackLeft", new Point(leftCardback_x,leftCardback_y));
				GameObjectManager.Instance.addOtherstoScreen(ResourceManagerPoker.cardback1, "CardbackUp", new Point(upCardback_x,upCardback_y));
				GameObjectManager.Instance.addOtherstoScreen(ResourceManagerPoker.cardback1, "CardbackRight", new Point(rightCardback_x,rightCardback_y));
			}
			else
			{
				GameObjectManager.Instance.removeOthersfromScreen("CardbackUp");
				GameObjectManager.Instance.removeOthersfromScreen("CardbackLeft");
				GameObjectManager.Instance.removeOthersfromScreen("CardbackRight");
			}
		}
		// function for find player pos
		public function getPlayerIndexByPos(obj:Object, pos:int):int
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
		// 更新玩家的信息  和玩家的头像图片
		// 同时对玩家数据进行更新（这个数据是用来在右边的数据列表上用的）
		public function updatePlayerName(obj:Object):void
		{
			// 玩家的姓名，显示在右上
			if(obj.hasOwnProperty("players"))
			{
				FlexGlobals.topLevelApplication.gamePoker.textPlayerSelf.text = obj.players[getPlayerIndexByPos(obj, selfseat)].name;
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameDown.text = FlexGlobals.topLevelApplication.gamePoker.textPlayerSelf.text;
					// 玩家的下面显示等级
				FlexGlobals.topLevelApplication.gamePoker.Lable_playerLevelDown.text = LevelDefine.getLevelName(obj.players[getPlayerIndexByPos(obj, selfseat)].score);
					// 玩家的右上部分积分，等级，金币
				FlexGlobals.topLevelApplication.gamePoker.textPlayerSelf_score.text = obj.players[getPlayerIndexByPos(obj, selfseat)].score;
				FlexGlobals.topLevelApplication.gamePoker.textPlayerSelf_level.text = FlexGlobals.topLevelApplication.gamePoker.Lable_playerLevelDown.text;
				FlexGlobals.topLevelApplication.gamePoker.textPlayerSelf_gold.text = obj.players[getPlayerIndexByPos(obj, selfseat)].money;
				FlexGlobals.topLevelApplication.gamePoker.playerinfoDown.visible = true;
				if(FlexGlobals.topLevelApplication.gamePoker.selfAvatar.source != obj.players[getPlayerIndexByPos(obj, selfseat)].avatar)
					FlexGlobals.topLevelApplication.gamePoker.selfAvatar.source = obj.players[getPlayerIndexByPos(obj, selfseat)].avatar;
				if(obj.players[getPlayerIndexByPos(obj,selfseat)].ready)
				{
					FlexGlobals.topLevelApplication.gamePoker.avatarDownGroup.visible = true;
					if(FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarDown.source != obj.players[getPlayerIndexByPos(obj, selfseat)].avatar)
						FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarDown.source = obj.players[getPlayerIndexByPos(obj, selfseat)].avatar;
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.avatarDownGroup.visible = false;
				}
			}

			// partner
			if(getPlayerIndexByPos(obj, (selfseat+2)%4) != -1)
			{
				var upPlayer:Object = obj.players[getPlayerIndexByPos(obj, (selfseat+2)%4)];
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameUp.text = upPlayer.name;
				// level
				FlexGlobals.topLevelApplication.gamePoker.Lable_playerLevelUp.text = LevelDefine.getLevelName(upPlayer.score);
				FlexGlobals.topLevelApplication.gamePoker.playerinfoUp.visible = true;
				
				FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.visible = true;
				if(FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarUp.source != upPlayer.avatar)
					FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarUp.source = upPlayer.avatar;
			}
			else
			{
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameUp.text = "";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumUp.text = "";
				FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.playerinfoUp.visible = false;
			}
			// right
			if(getPlayerIndexByPos(obj,(selfseat+1)%4) != -1)
			{
				var rightPlayer:Object = obj.players[getPlayerIndexByPos(obj, (selfseat+1)%4)];
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameRight.text = rightPlayer.name;
				// level
				FlexGlobals.topLevelApplication.gamePoker.Lable_playerLevelRight.text = LevelDefine.getLevelName(rightPlayer.score);
				FlexGlobals.topLevelApplication.gamePoker.playerinfoRight.visible = true;
				
				FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.visible = true;
				if(FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarRight.source != rightPlayer.avatar)
					FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarRight.source = rightPlayer.avatar;
			}
			else
			{
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameRight.text = "";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumRight.text = "";
				FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.visible = false; 
				FlexGlobals.topLevelApplication.gamePoker.playerinfoRight.visible = false;
			}
			// left
			if(getPlayerIndexByPos(obj, (selfseat+3)%4) != -1)
			{
				var leftPlayer:Object = obj.players[getPlayerIndexByPos(obj, (selfseat+3)%4)];
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameLeft.text = leftPlayer.name;
				// level
				FlexGlobals.topLevelApplication.gamePoker.Lable_playerLevelLeft.text = LevelDefine.getLevelName(leftPlayer.score);
				FlexGlobals.topLevelApplication.gamePoker.playerinfoLeft.visible = true;
				
				FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.visible = true;
				if(FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarLeft.source != leftPlayer.avatar)
					FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarLeft.source = leftPlayer.avatar;
			}
			else
			{
				FlexGlobals.topLevelApplication.gamePoker.Lable_playernameLeft.text = "";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumLeft.text = "";
				FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.playerinfoLeft.visible = false;
			}		
		}
		public function updateCurPlayerIcon(obj:Object):void
		{
			// 更新玩家出牌的剩余时间
			if(obj.hasOwnProperty("time"))
			{
				if(obj.time != -1)
				{
					// 显示沙漏动画和倒计时时间文字
					FlexGlobals.topLevelApplication.gamePoker.sandglass.visible = true;
					FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.visible = true;
					FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.text = obj.time.toString();
					// 调整沙漏和倒计时的文字位置
					if(obj.play.next == (selfseat+1)%4)
					{
						FlexGlobals.topLevelApplication.gamePoker.sandglass.x = 370;
						FlexGlobals.topLevelApplication.gamePoker.sandglass.y = 213;
					}
					else if(obj.play.next == (selfseat+2)%4)
					{
						FlexGlobals.topLevelApplication.gamePoker.sandglass.x = 270;
						FlexGlobals.topLevelApplication.gamePoker.sandglass.y = 132;
					}
					else if(obj.play.next == (selfseat+3)%4)
					{
						FlexGlobals.topLevelApplication.gamePoker.sandglass.x = 98;
						FlexGlobals.topLevelApplication.gamePoker.sandglass.y = 239;
					}
					else
					{
						FlexGlobals.topLevelApplication.gamePoker.sandglass.x = 272;
						FlexGlobals.topLevelApplication.gamePoker.sandglass.y = 353;
					}
					FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.x = FlexGlobals.topLevelApplication.gamePoker.sandglass.x + FlexGlobals.topLevelApplication.gamePoker.sandglass.width;
					FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.y = FlexGlobals.topLevelApplication.gamePoker.sandglass.y + 6;
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.sandglass.visible = false;
					FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.visible = false;
				}
			}

		}
		public function updatePlayerReadyState(obj:Object):void
		{
			// 玩家的状态
			if(obj.hasOwnProperty("players"))
			{
				// self
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,selfseat) ))
				{
					if(obj.players[getPlayerIndexByPos(obj,selfseat)].ready)
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerDownReady.visible = true;
						FlexGlobals.topLevelApplication.gamePoker.btnReady.visible = false;
					}
					else
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerDownReady.visible = false;
					}
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.imgPlayerDownReady.visible = false;
				}

				// partner
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+2)%4) ))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+2)%4)].ready)
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerUpReady.visible = true;
					}
					else
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerUpReady.visible = false;
					}
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.imgPlayerUpReady.visible = false;
				}
				
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+1)%4)))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+1)%4)].ready)
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerRightReady.visible = true;
					}
					else
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerRightReady.visible = false;
					}
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.imgPlayerRightReady.visible = false;
				}
				
				if(obj.players.hasOwnProperty( getPlayerIndexByPos(obj,(selfseat+3)%4) ))
				{
					if(obj.players[getPlayerIndexByPos(obj,(selfseat+3)%4)].ready)
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerLeftReady.visible = true;
					}
					else
					{
						FlexGlobals.topLevelApplication.gamePoker.imgPlayerLeftReady.visible = false;
					}
				}
				else{
					FlexGlobals.topLevelApplication.gamePoker.imgPlayerLeftReady.visible = false;
				}
			}
		}
		// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
		public function updatePlayerCardsInfo(obj:Object):void
		{
			//显示自己的剩余牌数
			FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumDown.text = "("+obj.cards[selfseat].number+")";
			FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumDown.visible = true;
			
			// partner
			if(obj.cards.hasOwnProperty( ((selfseat+2)%4).toString() ))
			{
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumUp.text = "("+obj.cards[(selfseat+2)%4].number+")";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumUp.visible = true;
				if(obj.cards[(selfseat+2)%4].number == 0)
				{
//					GameObjectManager.Instance.setVisibleByName("CardbackUp", false);
					GameObjectManager.Instance.removeOthersfromScreen("CardbackLeft");
				}
			}
			if(obj.cards.hasOwnProperty( ((selfseat+1)%4).toString() ))
			{
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumRight.text = "("+obj.cards[(selfseat+1)%4].number+")";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumRight.visible = true;
				if(obj.cards[(selfseat+1)%4].number == 0)
				{
//					GameObjectManager.Instance.setVisibleByName("CardbackRight", false);
					GameObjectManager.Instance.removeOthersfromScreen("CardbackRight");
				}
			}
			if(obj.cards.hasOwnProperty( ((selfseat+3)%4).toString() ))
			{
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumLeft.text = "("+obj.cards[(selfseat+3)%4].number+")";
				FlexGlobals.topLevelApplication.gamePoker.Label_leftcardsnumLeft.visible = true;
				if(obj.cards[(selfseat+3)%4].number == 0)
				{
//					GameObjectManager.Instance.setVisibleByName("CardbackLeft", false);
					GameObjectManager.Instance.removeOthersfromScreen("CardbackLeft");
				}
			}
			
			// 当前出牌玩家，显示在该玩家的头像的左上角
			if(obj.play.hasOwnProperty("next"))
			{
				// 将显示的图打开 
				FlexGlobals.topLevelApplication.gamePoker.label_thinking.visible = true;
				if(obj.play.next == selfseat)
				{
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.x = FlexGlobals.topLevelApplication.gamePoker.avatarDownGroup.x;
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.y = FlexGlobals.topLevelApplication.gamePoker.avatarDownGroup.y;
				}
				else if(obj.play.next == (selfseat+1)%4)
				{
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.x = FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.x;
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.y = FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.y;
				}
				else if(obj.play.next == (selfseat+2)%4)
				{
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.x = FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.x;
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.y = FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.y;
				}
				else if(obj.play.next == (selfseat+3)%4)
				{
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.x = FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.x;
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.y = FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.y;
				}
				else
				{
					// 将显示的图打开 
					FlexGlobals.topLevelApplication.gamePoker.label_thinking.visible = false;
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
			if(gamePlayerLeftTimeDef != -1)
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
				FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.text = gamePlayerLeftTimeCounter.toString();
			}
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
					// 进行游戏开始的动画演示
					FlexGlobals.topLevelApplication.gamePoker.gamebg.alpha += 0.1;
					if(FlexGlobals.topLevelApplication.gamePoker.gamebg.alpha >= 1) {
						FlexGlobals.topLevelApplication.gamePoker.gamebg.alpha = 1;
						// 开始播放flash本身的动画
//						gameState = 10;
						FlexGlobals.topLevelApplication.gamePoker._startup();
					}
					break;
				case 10:
					var mc:MovieClip = MovieClip(FlexGlobals.topLevelApplication.gamePoker.BGswf.content);
					if(mc.currentFrame == 60/*mc.totalFrames*/){
						FlexGlobals.topLevelApplication.gamePoker._startup();
					}
					break;
				case 2:
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileGame);
						requestFlag = false;
						if(curPlayer != selfseat)
						{
							FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = false;
						}
					}
					// 轮到自己出牌,并且按钮没有被按下
					if(curPlayer == selfseat)
					{
						// 检测该次的出牌是否符合要求，能否出牌。
						if(curPlayer == lastPlayer)
						{
							// 这意味着玩家自己出的牌最大，他可以没有限制的继续出
							// 这个时候不能够放弃
							if(FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled != false)
								FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled = false;
						}
					}
					updatePlayerLeftTime();
//				    GameObjectManager.Instance.enterFrame();
					break;
				case 20:	// 进行动画处理
					var no:int = cardAnimateCounter;
					var pok:poker = FlexGlobals.topLevelApplication.gamePoker as poker;
//					if(cardAnimateCounter/2 == no)
					if(true)
					{
						if(no >= 52)
						{
							// 删除所有的牌背
							var delobj:Image = pok.getChildByName("fcba") as Image;
							while(delobj != null){
								pok.removeElement(delobj);
								delobj = pok.getChildByName("fcba") as Image;
							}
							cardAnimateArray.length = 0;
							//	更新所有的游戏信息
							var obj:Object = StateUpdateForFirstFrame.Instance.lastSuccData;
							// 进入游戏逻辑，开始进行update处理
							gameState = 2;
							// 
							readyStateInit();
							if(obj.play.next == Game.Instance.selfseat)
							{
								// 显示所有的按钮
								FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = true;
								FlexGlobals.topLevelApplication.gamePoker.commandbar.btnSendCards.enabled = false;
								FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled = true;
								if(obj.play.last == obj.play.next)
								{
									FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled = false;
								}
							}
							else{
								FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = false;
							}
							lastPlayer = obj.play.last;
							curPlayerLast = curPlayer;
							curPlayer = obj.play.next;
							gamePlayerLeftTimeDef = obj.time;
							initPlayerLeftStartTime();
							// 更新其他玩家的名字和状态
							updatePlayerName(obj);
							// 更新右侧其他玩家的数据表格
							playersDatagridFill(obj);
							// 描画玩家手上的牌
							drawPlayerCards(obj);
							// 描画玩家打出来的牌
							drawOtherCards(obj, obj.status);
							// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
							updatePlayerCardsInfo(obj);
							// 描画出牌剩余时间
							updateCurPlayerIcon(obj);
							// 对时间进行修正
							modifyPlayerLefttime(obj);
							// 显示其他三家的牌堆
							showCardback(true);
							// 使过往牌记录的查看按钮有效
							FlexGlobals.topLevelApplication.gamePoker.btnCardView.visible = true;
							FlexGlobals.topLevelApplication.gamePoker.cpuAI.visible = true;							
						}
						else
						{
							if(no == 0)	// create all
							{
								var ca:Array = sortCards(StateUpdateForFirstFrame.Instance.lastSuccData);
								for(var j:int=0;j<27;j++)
								{
									var img:Image = new Image();
									img.source = ResourceManagerPoker.gameCardsRes[ca[j]];
									img.x = cardStandardX-(27*cardsIntervalX/2);//+no*cardsIntervalX;
									img.y = cardStandardY;
									img.name = "fcba";// for cardback animation
									pok.addElement(img);
									cardAnimateArray.push(img);
								}
							}
							var movenum:int = int(cardAnimateCounter/2)+1;
							for(var i:int=0;i<movenum;i++)
							{
//								if((52-cardAnimateCounter)/2 == int()
								cardAnimateArray[26-i].x += cardsIntervalX/2;
							}
						}
					}
					cardAnimateCounter++;
					break;
				case 3:
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileWait);
						requestFlag = false;
					}
//					GameObjectManager.Instance.enterFrame();
					break;
				case 4:	// 等待其他玩家准备完成
					// 在一定的频率下，发送消息，更新自己的数据。
					if(requestFlag)
					{
						NetManager.Instance.update(NetManager.send_updateWhileGame);
						requestFlag = false;
					}
//					GameObjectManager.Instance.enterFrame();
					break;
				case 5:
//					GameObjectManager.Instance.enterFrame();
					break;
			}
		}
		
		public function commonUpdate(obj:Object):void
		{
			// 更新其他玩家的名字和状态
			Game.Instance.updatePlayerName(obj);
			// 更新右侧其他玩家的数据表格
			Game.Instance.playersDatagridFill(obj);
			// 描画玩家手上的牌
			Game.Instance.drawPlayerCards(obj);
			// 描画玩家打出来的牌
			Game.Instance.drawOtherCards(obj, obj.status);
			// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
			Game.Instance.updatePlayerCardsInfo(obj);
			// 描画出牌剩余时间
			Game.Instance.updateCurPlayerIcon(obj);
			// 对时间进行修正
			Game.Instance.modifyPlayerLefttime(obj);
		}
		
		public function getSelfseat(obj:Object):void
		{
			for(var i:int=0;i<4;i++)
			{
				if(obj.players.hasOwnProperty(i.toString()))
				{
					if(obj.players[i].pid == pid)
					{
						// 获得玩家的座位号
						selfseat = obj.players[i].pos;
						break;
					}
				}
			}
		}
		
		public function sendcards():void
		{
			NetManager.Instance.send(NetManager.send_sendcardsWhileGame);
		}
		public function pass():void
		{
			NetManager.Instance.send(NetManager.send_passWhileGame);
			SoundManager.Instance().playSE("pass");
		}
		public function hint():void
		{
			if(curPlayer == selfseat)
			{
				// 检测该次的出牌是否符合要求，能否出牌。
				var checkarr:Array = new Array();
				if(curPlayer == lastPlayer)
				{
				}
				else
				{
					// 要求含有当前出牌情况的信息才能进行判断
					if(StateUpdateWhileGame.Instance.lastSuccData.hasOwnProperty("play"))
					{
						checkarr = checkarr.concat(StateUpdateWhileGame.Instance.lastSuccData.play.last_card);
					}
				}
				// 判断这次的要压的牌和最近的一次是不是一样
				var flag:Boolean = false;
				if(checkarr.length == lastCard.length && checkarr.length != 0) 
				{
					if( int(checkarr[0]/4) == int(lastCard[0]/4) && int(checkarr[checkarr.length-1]/4) == int(lastCard[lastCard.length-1]/4) )
					{
						flag = true;
					}
					
				}
				if(flag)
				{
					hintTimes++;
					if(hintCards.length > hintTimes){
						GameObjectManager.Instance.deselectAllCards();
						GameObjectManager.Instance.selectCards(hintCards[hintTimes]);
					}
					else{
						hintTimes = 0;
						GameObjectManager.Instance.deselectAllCards();
						GameObjectManager.Instance.selectCards(hintCards[hintTimes]);
					}
				}else if(!flag && checkarr.length!=0){
					lastCard = checkarr.concat();
					hintCards = GameObjectManager.Instance.showHintCards(checkarr);
					if(hintCards.length > 0){
						hintTimes = 0;
						GameObjectManager.Instance.selectCards(hintCards[hintTimes]);
					}
					else{
						if(FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled)
							Game.Instance.pass();
					}
				}
			}
		}

		public function click(event:MouseEvent):void
		{
//			if(gameState == 2)
//			{
//				GameObjectManager.Instance.click(event);
//				FlexGlobals.topLevelApplication.gamePoker.commandbar.btnSendCards.enabled = isSendBtnEnable();
//			}
		}
		public function isSendBtnEnable():Boolean
		{
			if(curPlayer == selfseat)
			{
				if(curPlayer != lastPlayer)
				{
					// 要求含有当前出牌情况的信息才能进行判断
					if(StateUpdateWhileGame.Instance.lastSuccData.hasOwnProperty("play"))
					{
						// 检测该次的出牌是否符合要求，能否出牌。
						var checkarr:Array = new Array();
						checkarr = checkarr.concat(StateUpdateWhileGame.Instance.lastSuccData.play.last_card);
						// 要求含有当前出牌情况的信息才能进行判断
						if(GameObjectManager.Instance.checkCardtobePlayed(checkarr.sort(Array.NUMERIC)))
						{
							return true;
						}
						else
						{
							return false;
						}
						checkarr = null;
					}
				}
				else{
					if(GameObjectManager.Instance.checkCardtobePlayed(new Array()))
						return true;
					else
						return false;
				}
			}
			return false;
		}
		
		/**
		 * 用来判断帧的大小，处理先后顺序
		 * @param str
		 * @return 
		 * 
		 */		
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
		
		/**
		 * 检查所有的动画是否结束，如果结束就关闭并删除 
		 * 
		 */		
		public function checkAnimationOver():Boolean
		{
			var pok:poker = FlexGlobals.topLevelApplication.gamePoker as poker;
			var mc:UIMovieClip;
			var flag:Boolean = true;
			mc = pok.animationGroup0.getChildByName("anime") as UIMovieClip;
			if(mc != null){
				if(mc.currentFrame >= mc.totalFrames)
					pok.animationGroup0.removeAllElements();
				else
					flag = false;
			}
			mc = pok.animationGroup1.getChildByName("anime") as UIMovieClip;
			if(mc != null){
				if(mc.currentFrame >= mc.totalFrames)
					pok.animationGroup1.removeAllElements();
				else
					flag = false;
			}
			mc = pok.animationGroup2.getChildByName("anime") as UIMovieClip;
			if(mc != null){
				if(mc.currentFrame >= mc.totalFrames)
					pok.animationGroup2.removeAllElements();
				else
					flag = false;
			}
			mc = pok.animationGroup3.getChildByName("anime") as UIMovieClip;
			if(mc != null){
				if(mc.currentFrame >= mc.totalFrames)
					pok.animationGroup3.removeAllElements();
				else
					flag = false;
			}
			
			return flag;
		}
		
		/**
		 * 填充游戏中使用的玩家数据
		 * @param data
		 * 
		 */		
		public function playersDatagridFill(obj:Object):void
		{
			var pok:poker = FlexGlobals.topLevelApplication.gamePoker as poker;
			// 直接对游戏中画面进行数据更新
			// partner
			var id:int = getPlayerIndexByPos(obj,(selfseat+2)%4);
			if(obj.players.hasOwnProperty( id.toString() ))
			{
				pok.label_pl_up_name.text = obj.players[id].name;
				pok.label_pl_up_score.text = obj.players[id].score;
				pok.label_pl_up_level.text = LevelDefine.getLevelName(obj.players[id].score);
				pok.label_pl_up_gold.text = obj.players[id].money;
			}
			else{
				pok.label_pl_up_name.text = "";
				pok.label_pl_up_score.text = "";
				pok.label_pl_up_level.text = "";
				pok.label_pl_up_gold.text = "";
			}
			pok.label_pl_up_name.toolTip = pok.label_pl_up_name.text;
			pok.label_pl_up_score.toolTip = pok.label_pl_up_score.text;
			pok.label_pl_up_level.toolTip = pok.label_pl_up_level.text;
			pok.label_pl_up_gold.toolTip = pok.label_pl_up_gold.text;
			
			id = getPlayerIndexByPos(obj,(selfseat+1)%4);
			if(obj.players.hasOwnProperty( id.toString() ))
			{
				pok.label_pl_right_name.text = obj.players[id].name;
				pok.label_pl_right_score.text = obj.players[id].score;
				pok.label_pl_right_level.text = LevelDefine.getLevelName(obj.players[id].score);
				pok.label_pl_right_gold.text = obj.players[id].money;
			}
			else{
				pok.label_pl_right_name.text = "";
				pok.label_pl_right_score.text = "";
				pok.label_pl_right_level.text = "";
				pok.label_pl_right_gold.text = "";
			}
			pok.label_pl_right_name.toolTip = pok.label_pl_right_name.text;
			pok.label_pl_right_score.toolTip = pok.label_pl_right_score.text;
			pok.label_pl_right_level.toolTip = pok.label_pl_right_level.text;
			pok.label_pl_right_gold.toolTip = pok.label_pl_right_gold.text;
			
			id = getPlayerIndexByPos(obj,(selfseat+3)%4);
			if(obj.players.hasOwnProperty( id.toString() ))
			{
				pok.label_pl_left_name.text = obj.players[id].name;
				pok.label_pl_left_score.text = obj.players[id].score;
				pok.label_pl_left_level.text = LevelDefine.getLevelName(obj.players[id].score);
				pok.label_pl_left_gold.text = obj.players[id].money;
			}
			else{
				pok.label_pl_left_name.text = "";
				pok.label_pl_left_score.text = "";
				pok.label_pl_left_level.text = "";
				pok.label_pl_left_gold.text = "";
			}
			pok.label_pl_left_name.toolTip = pok.label_pl_left_name.text;
			pok.label_pl_left_score.toolTip = pok.label_pl_left_score.text;
			pok.label_pl_left_level.toolTip = pok.label_pl_left_level.text;
			pok.label_pl_left_gold.toolTip = pok.label_pl_left_gold.text;
		
		}
	}
}