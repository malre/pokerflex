package 
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.geom.*;
	import fl.controls.Button;
	
	import Def.*;
	
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class Main extends Sprite 
	{
		private static const CARD_OPEN:Boolean = true;
		private static const CARDLIST_POSITION:Array = [10, 50];
		private static const INVALIDCARDS_POSITION:Array = [10, 50];
		private static const CARD_MOVESPEED:int = 5;
		private static const CARD_WIDTH:int = 79;
		private static const CARD_HEIGHT:int = 112;
		private static const membernamelist:Array = ["貂蝉", "昭君", "贵妃", "西施"];	
		private static const memberpostionlist:Array = [new Point(350, 450), new Point(550, 275), new Point(350, 100), new Point(150, 275)];
		private static const BG_COLOR:uint = 0x80C0;
		/** Anchor Left */
		private static const LEFT:int    = 0;
		/** Anchor Right */
		private static const RIGHT:uint   = 0x1;
		/** Anchor HCenter */
		private static const HCENTER:uint = 0x2;
		/** Anchor Top */
		private static const TOP:uint     = 0x4;
		/** Anchor Bottom */
		private static const BOTTOM:uint  = 0x8;
		/** Anchor VCenter */
		private static const VCENTER:uint = 0x10;	
		
		
		private var m_Game:Game;
		private var m_DealFrmCnt:int;
		private var m_CardDealMoveTime:int;
		
		
		
		
		private var m_ShowBmpd:BitmapData;
		private var m_string:TextField;
		private var m_matrix:Matrix;
		private var m_ReplayBtn:Button;
		private var m_SendBtn:Button;
		private var m_SkipBtn:Button;
		
		[Embed(source='Card.png')]
		private var image_card_src:Class;
		private var image_card:Bitmap;
		
		
		
		
		
		public function Main():void 
		{
			load();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function load():void
		{
			image_card = new image_card_src();
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point				
			m_ShowBmpd = new BitmapData(this.stage.stageWidth, this.stage.stageHeight, false, BG_COLOR);
			var bmp:Bitmap = new Bitmap(m_ShowBmpd);
			this.addChild(bmp);
			
			m_SendBtn = new Button();
           	m_SendBtn.move(600, 300);
			m_SendBtn.width = 40;
			m_SendBtn.height = 20;
            m_SendBtn.label = "Send";            
			m_SendBtn.addEventListener(MouseEvent.CLICK, SendMClick);	
			this.addChild(m_SendBtn);
			m_SkipBtn = new Button();
           	m_SkipBtn.move(600, 370);
			m_SkipBtn.width = 40;
			m_SkipBtn.height = 20;
            m_SkipBtn.label = "Skip";            
			m_SkipBtn.addEventListener(MouseEvent.CLICK, SkipMClick);	
			this.addChild(m_SkipBtn);
			m_ReplayBtn = new Button();
			m_ReplayBtn.move(CARDLIST_POSITION[0], CARDLIST_POSITION[1] + CARD_HEIGHT + 50);
			m_ReplayBtn.width = 100;
			m_ReplayBtn.height = 40;
            m_ReplayBtn.label = "Replay";            
			m_ReplayBtn.addEventListener(MouseEvent.CLICK, ReplayMClick);	
			this.addChild(m_ReplayBtn);
			m_ReplayBtn.visible = false;
			
			m_string = new TextField();
			m_matrix = new Matrix();
			
			m_CardDealMoveTime = int(0.2 * this.stage.frameRate);
			m_Game = new Game(membernamelist);
			m_Game.GameState = GAME_STATE.INIT;
			
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, KeyDown);
			this.stage.addEventListener(Event.ENTER_FRAME, Frame);
			this.stage.addEventListener(MouseEvent.CLICK, MClick);
		}
		private function SendMClick(event:MouseEvent):void
		{
			send();
		}
		private function SkipMClick(event:MouseEvent):void
		{
			skip();
		}
		private function MClick(event:MouseEvent):void
		{
			if (m_Game.GameState == GAME_STATE.PLAY)
			{
				var m_x:int = event.stageX;
				var m_y:int = event.stageY;
				var player:Player = m_Game.PlayerList[m_Game.GetActPlayer()/*m_Game.GetLocalPlayer()*/];
				var card:CardInfo;
				for (var i:int = player.CardList.length - 1 ; i >= 0  ; --i)
				{
					card = player.CardList[i];
					if ((m_x >= card.position.x && m_x < (card.position.x + CARD_WIDTH)) && (m_y >= card.position.y && m_y < (card.position.y + CARD_HEIGHT)))
					{
						trace("SelectCard[number:" + card.number + " mark:" + card.mark);
						switch (card.state)
						{
							case CARD_STATE.NORMAL:
								{
									card.tarposition.offset(0, -10);
									card.state = CARD_STATE.READY;
								}
								break;
							case CARD_STATE.READY:
								{
									card.state = CARD_STATE.NORMAL;
									card.tarposition.offset(0, 10);
								}
								break;
							default:
								break;
							
						}
						break;
					}
				}
			}
		}
		private function ReplayMClick(event:MouseEvent):void
		{
			replay();
		}
		private function KeyDown(event:KeyboardEvent):void
		{
			trace("KeyDown");
			if (event.keyCode == Key.ZERO)
			{
				replay();
			}
			else if (event.keyCode == Key.ENTER)
			{
				send();
			}
			/////////////////////
			// 无法跟牌
			/////////////////////
			else if (event.keyCode == Key.ESC)
			{
				skip();
			}
			
		}
		private function procPaint ():void
		{
			m_ShowBmpd.fillRect(new Rectangle(0, 0, m_ShowBmpd.width, m_ShowBmpd.height), BG_COLOR);
			
			
			var i:int;
			var card:CardInfo;
			
			////////////////
			// 打出去的牌
			////////////////
			for (i = 0 ; i < m_Game.InvalidCardList.length ; ++i)
			{
				card = m_Game.InvalidCardList[i];
				drawCard(card);
			}
			////////////////
			// 余牌
			////////////////
			for (i = 0 ; i < m_Game.CardList.length ; ++i)
			{
				card = m_Game.CardList[i];
				drawCard(card);
			}
			////////////////
			// 玩家手中的牌
			////////////////
			var player:Player;
			for (i = 0 ; i < m_Game.PlayerList.length ; ++i)
			{
				player = m_Game.PlayerList[i];
				var j:int;
				for (j = 0 ; j < player.CardList.length ; ++j)
				{
					card = player.CardList[j];
					drawCard(card);
				}
			}
			
			var cardcnt:String = "余牌:" + m_Game.CardList.length.toString();
			drawString(cardcnt, CARDLIST_POSITION[0], CARDLIST_POSITION[1] - 20, LEFT, 0xFFFFFF);
			
			//drawString("Play", memberpostionlist[m_Game.GetActPlayer()].x+80, memberpostionlist[m_Game.GetActPlayer()].y + CARD_HEIGHT, LEFT, 0xFF00);
			m_SendBtn.move(memberpostionlist[m_Game.GetActPlayer()].x + 80, memberpostionlist[m_Game.GetActPlayer()].y + CARD_HEIGHT);
			m_SkipBtn.move(memberpostionlist[m_Game.GetActPlayer()].x + 80 + 50, memberpostionlist[m_Game.GetActPlayer()].y + CARD_HEIGHT);
			
			var color:uint;
			for (i = 0 ; i < m_Game.PlayerList.length ; ++i)
			{
				player = m_Game.PlayerList[i];
				color = 0xFFFFFF;
				if (player.GetIndex() == m_Game.GetActPlayer())
				{
					color = 0xFF00;
				}
				else if (player.GetIndex() == m_Game.GetRoundWinPlayer())
				{
					color = 0xFF0000;
				}
				
				drawString(membernamelist[i] + "(" + player.CardList.length + ")", memberpostionlist[i].x, memberpostionlist[i].y + CARD_HEIGHT, LEFT, color);
			}
			if (m_Game.GameState == GAME_STATE.END)
			{
				var overstr:String = "游戏结束!" + (m_Game.GetGameWinPlayer() <= -1 ? "无人" : membernamelist[m_Game.GetGameWinPlayer()]) + "胜!";
				//trace(overstr);
				drawString(overstr, CARDLIST_POSITION[0], CARDLIST_POSITION[1] + CARD_HEIGHT + 20, LEFT, 0xFF8040, 12);
				
			}
			m_ReplayBtn.visible = m_Game.GameState == GAME_STATE.END;
			m_SendBtn.enabled = m_Game.GameState == GAME_STATE.PLAY;
			m_SkipBtn.enabled = m_Game.GameState == GAME_STATE.PLAY;
		}
		private function drawCard(card:CardInfo):void
		{			
			var x:Number;
			var y:Number;
			x = card.open == false ? 928 : (card.mark * 109 + ((card.number >= CARD_NUMBER.THREE && card.number <= CARD_NUMBER.NINE) ? 15 : 451));
			y = card.open == false ? 834 : ((card.number - ((card.number >= CARD_NUMBER.THREE && card.number <= CARD_NUMBER.NINE) ? 3 : 10)) * 137 + 17);
			var rect:Rectangle = new Rectangle(x, y, CARD_WIDTH, CARD_HEIGHT);
			var pt:Point = new Point(card.position.x, card.position.y);
			m_ShowBmpd.copyPixels(image_card.bitmapData, rect, pt);
		}
		private function drawString(str:String, px:int, py:int, anchor:int, color:uint, size:uint = 14):void
		{
			
			var format:TextFormat = new TextFormat();
            format.size = size;
			m_string.defaultTextFormat = format;
			m_string.textColor = color;
			m_string.text = str;
						
			
			var w:Number = m_string.textWidth;
			var h:Number = m_string.textHeight;
			var x:Number = px, y:Number = py;
			if (anchor & LEFT)
			{
				x = px; 
			}
			else if (anchor & RIGHT)
			{
				x = px - w;
			}
			if (anchor & TOP)
			{
				y = py; 
			}
			else if (anchor & BOTTOM)
			{
				y = py - h;
			}
			if (anchor & HCENTER)
			{
				x = px - w / 2;
			}
			if (anchor & VCENTER)
			{
				y = py - h / 2;
			}
				
			
			m_matrix.identity();
			m_matrix.translate( x, y);
			m_ShowBmpd.draw(m_string, m_matrix);
			
		}
		private function send():void
		{
			if (m_Game.GameState == GAME_STATE.PLAY)
			{
				trace("send");
				m_Game.GameState = GAME_STATE.SEND;
			}
		}
		private function skip():void
		{
			if (m_Game.GameState == GAME_STATE.PLAY)
			{
				if (m_Game.GetActPlayer() != m_Game.GetRoundWinPlayer())
				{
					SortPlayerCards(m_Game.GetActPlayer());
					trace("[" + membernamelist[m_Game.GetActPlayer()] + "]放弃");
					m_Game.NextPlayer();					
					trace("跳到[" + membernamelist[m_Game.GetActPlayer()] + "]");
					
					if (m_Game.GetActPlayer() == m_Game.GetRoundWinPlayer())
					{
						m_Game.GameState = GAME_STATE.DEAL;
						m_Game.NewRound(); 
						
					}
				}
			}
		}
		private function replay():void
		{
			trace("replay");
			m_Game.GameState = GAME_STATE.INIT;
		}
		private function procLogic ():void
		{
			var i:int, j:int;
			var player:Player;
			var card:CardInfo;
			var pos:Point;
			
			////////////////
			// 初始化
			////////////////
			if (m_Game.GameState == GAME_STATE.INIT)
			{
				
				m_Game.Init();
				m_Game.GameState = GAME_STATE.DEAL;
				m_DealFrmCnt = m_Game.PlayerList.length * Player.CARD_MAX * m_CardDealMoveTime;
				trace("DealTotalTime:" + m_DealFrmCnt);
				////////////////
				// 余牌
				////////////////
				for (i = 0 ; i < m_Game.CardList.length ; ++i)
				{
					card = m_Game.CardList[i];
					card.position.x = CARDLIST_POSITION[0];
					card.position.y = CARDLIST_POSITION[1];
				}
			}
			////////////////
			// 发牌
			////////////////
			else if (m_Game.GameState == GAME_STATE.DEAL)
			{
				
				var cardcnt:int;
				trace(m_DealFrmCnt);
				// 全体发牌
				if (m_Game.DealType == DEAL_TYPE.ALLPLAYER)
				{
					if ((m_Game.DealFrameCnt % m_CardDealMoveTime) == 0)
					{
						player = m_Game.PlayerList[m_Game.DealPlayerCnt];								
						cardcnt = player.CardList.length;
						pos = memberpostionlist[m_Game.DealPlayerCnt];
						
						if (player.IsCardFull())
						{
							m_Game.DealPlayerCnt++;
							m_Game.DealFrameCnt = -1;
							
						}
						else
						{
							
							card = m_Game.PopCard(player.GetIndex());
							if (player.GetIndex() == m_Game.GetLocalPlayer() || CARD_OPEN)
							{
								card.open = true;
							}
							card.tarposition.x = pos.x + cardcnt * 20;
							card.tarposition.y = pos.y;
							card.speed.x = int(Math.abs(card.tarposition.x - card.position.x) / m_CardDealMoveTime);
							card.speed.y = int(Math.abs(card.tarposition.y - card.position.y) / m_CardDealMoveTime);
							card.state = CARD_STATE.DEAL;
							
							
							player.AddCard(card);		
							trace("发牌("+player.CardList.length.toString()+")给[" + membernamelist[player.GetIndex()] + "]");
							
							m_Game.DealFrameCnt = 0;
						}
					}
					m_Game.DealFrameCnt++;			
					
				}
				// 发牌给胜者
				else if (m_Game.DealType == DEAL_TYPE.WINPLAYER)
				{
					
					if ((m_Game.DealFrameCnt % m_CardDealMoveTime) == 0)
					{
						player = m_Game.PlayerList[m_Game.GetRoundWinPlayer()];
						pos = memberpostionlist[player.GetIndex()];
						cardcnt = player.CardList.length;
						card = m_Game.PopCard(player.GetIndex());
						if (player.GetIndex() == m_Game.GetLocalPlayer() || CARD_OPEN)
						{
							card.open = true;
						}
						card.tarposition.x = pos.x + cardcnt * 20;
						card.tarposition.y = pos.y;
						card.speed.x = int(Math.abs(card.tarposition.x - card.position.x) / m_CardDealMoveTime);
						card.speed.y = int(Math.abs(card.tarposition.y - card.position.y) / m_CardDealMoveTime);
						card.state = CARD_STATE.DEAL;
						
						player.AddCard(card);
					
						m_DealFrmCnt = m_CardDealMoveTime;
						
					}
					m_Game.DealFrameCnt++;
				}
				
				if (--m_DealFrmCnt <= 0)
				{
					m_Game.DealFrameCnt = 0;
					m_Game.DealType = DEAL_TYPE.WINPLAYER;									
					m_Game.GameState = GAME_STATE.READY;
					// 被发牌的玩家手中只有怪游戏结束,无人赢
					if (m_Game.CheckPlayerOnlyJoker(m_Game.GetActPlayer()))
					{
						m_Game.GameState = GAME_STATE.END;
						
					}
				}
			}
			////////////////
			// 理牌
			////////////////
			else if (m_Game.GameState == GAME_STATE.READY)
			{
				
				for (i = 0 ; i < m_Game.PlayerList.length ; ++i)
				{
					SortPlayerCards(i);
				}
				
				m_Game.GameState =  GAME_STATE.PLAY;
				
			}
			////////////////
			// 选牌
			////////////////
			else if (m_Game.GameState == GAME_STATE.PLAY)
			{
				
			}
			////////////////
			// 出牌
			////////////////
			else if (m_Game.GameState == GAME_STATE.SEND)
			{
				player = m_Game.PlayerList[m_Game.GetActPlayer()];
				var sendlist:Array = new Array();
				for (j = 0 ; j < player.CardList.length ; ++j)
				{
					card = player.CardList[j];
					if (card.state == CARD_STATE.READY)
					{						
						sendlist.push(card);					
					}
				}
				
				// 整理要打出去的牌
				m_Game.sortCardList(sendlist);						
				////////////////////
				// 查看选择的牌型
				////////////////////
				var type:Type = m_Game.GetType(sendlist);
				trace("type[cardtype:" + CARD_TYPE.Name[type.cardtype] + " start:" + type.start + "]");
				//////////////////////////
				// 根据游戏规则判定结果
				//////////////////////////
				var res:int = m_Game.Check(type);
				trace("CheckResult:" + ERROR_TYPE.Name[res]);
				// 成功
				if (res == ERROR_TYPE.SUCCESS)
				{
					m_Game.SendCard(sendlist);
					// 从玩家手中删除牌
					for (i = 0 ; i < sendlist.length ; ++i)
					{
						card = sendlist[i];
						for (j = 0 ; j < player.CardList.length ; ++j)
						{
							if (card.equals(player.CardList[j]))
							{
								player.CardList.splice(j, 1);
								break;
							}
						}
					}
					// 记录当前牌型
					m_Game.CurrType = type;
					// 记录出牌成功的玩家
					m_Game.RoundWinPlayer(m_Game.GetActPlayer());
					trace("[" + membernamelist[m_Game.GetRoundWinPlayer()] + "]出牌成功");
					
					// 玩家手中无牌
					if (m_Game.CheckPlayerCardEmpty(m_Game.GetActPlayer()))
					{
						m_Game.GameState = GAME_STATE.END;
						m_Game.GameWinPlayer(m_Game.GetActPlayer());
					}
					// 玩家手中有牌
					else
					{
						m_Game.GameState = GAME_STATE.PLAY;
						// 把出牌权转交到下一个玩家
						m_Game.NextPlayer();
					}
					
					SortPlayerCards(player.GetIndex());
					
				}
				// 失败
				else
				{
					m_Game.GameState = GAME_STATE.PLAY;
				}
				
				
			}
			else if (m_Game.GameState == GAME_STATE.END)
			{
				
			}
			
			//////////////////
			// 刷新牌的位置
			//////////////////
			if (1)
			{
				
				var x_dis:int, y_dis:int;
				var x_dir:int, y_dir:int;
				var x_add:int, y_add:int;
				////////////////
				// 玩家手中的牌
				////////////////
				for (i = 0 ; i < m_Game.PlayerList.length ; ++i)
				{
					player = m_Game.PlayerList[i];
					pos = memberpostionlist[i];
					
					for (j = 0 ; j < player.CardList.length ; ++j)
					{
						card = player.CardList[j];
						
						if (!card.position.equals(card.tarposition))
						{
							x_dis = card.tarposition.x - card.position.x;										
							x_dir = x_dis >= 0 ? 1 : -1;
							x_add = (x_dis >= card.speed.x ? x_dir * card.speed.x : x_dir * Math.abs(x_dis));
							
							y_dis = card.tarposition.y - card.position.y;
							y_dir = y_dis >= 0 ? 1 : -1;
							y_add = (y_dis >= card.speed.y ? y_dir * card.speed.y : y_dir * Math.abs(y_dis));
							
							card.position.offset(x_add, y_add);										
							
						}
						else
						{
							switch (card.state)
							{
								case CARD_STATE.DEAL:
									{
										card.state = CARD_STATE.NORMAL;
										
									}
									break;
								default:
									break;
							}
						}
					}
				}
				////////////////
				// 打出去的牌
				////////////////
				for (i = 0 ; i < m_Game.InvalidCardList.length ; ++i)
				{
					card = m_Game.InvalidCardList[i];
					
					if (!card.position.equals(card.tarposition))
					{
						x_dis = card.tarposition.x - card.position.x;										
						x_dir = x_dis >= 0 ? 1 : -1;
						x_add = x_dir * ((Math.abs(x_dis) >= card.speed.x ? card.speed.x : Math.abs(x_dis)));
						
						y_dis = card.tarposition.y - card.position.y;
						y_dir = y_dis >= 0 ? 1 : -1;
						y_add = y_dir * ((Math.abs(y_dis) >= card.speed.y ? card.speed.y : Math.abs(y_dis)));
						
						card.position.offset(x_add, y_add);	
						
						
					}
					else
					{
						switch (card.state)
						{
							case CARD_STATE.SEND:
								{
									card.state = CARD_STATE.INVALID;
									
								}
								break;
							default:
								break;
						}
					}
				}
				
				
			}
		}
		private function SortPlayerCards(player:int):void
		{
			if (player >= 0 && player < m_Game.PlayerList.length)
			{
				m_Game.sortCardList(m_Game.PlayerList[player].CardList);
				var pos:Point = memberpostionlist[m_Game.PlayerList[player].GetIndex()];
				var card:CardInfo;
				for (var i:int = 0 ; i < m_Game.PlayerList[player].CardList.length ; ++i)
				{
					card = m_Game.PlayerList[player].CardList[i];
					card.tarposition.x = pos.x + i * 20;
					card.tarposition.y = pos.y;
					card.speed.x = 100000;
					//card.speed.y = 100000;
					card.state = CARD_STATE.DEAL;
				}
			}
		}
		private function Frame (event:Event):void
		{
			procLogic();
			procPaint();
		}
	}
	
}