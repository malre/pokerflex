package  
{
	import flash.geom.Point;
	import Def.*;
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class Game 
	{
		private static const CARD_MAX:int = 54; 
		
		private var m_ScoreList:Array;
		
		private var m_ActPlayer:int;// 当前需要出牌的玩家
		private var m_RoundWinPlayer:int;// 刚刚出过牌的玩家
		private var m_GameWinPlayer:int;// 赢家
		private var m_LocalPlayer:int;
		
		
		
		public var InvalidCardList:Array;
		public var CardList:Array;
		public var PlayerList:Array;		
		public var GameState:int = GAME_STATE.NONE;
		
		public var DealType:int;
		public var DealPlayerCnt:int;
		public var DealFrameCnt:int;
		
		public var CurrType:Type;
		public var bRoundEnd:Boolean;
		
				
		public function Game(playerlist:Array) 
		{
			GameState = GAME_STATE.NONE;
			// 牌
			CardList = new Array();	
			InvalidCardList = new Array();
			
			// 玩家
			m_LocalPlayer = playerlist.length > 0 ? 0 : -1;
			m_ActPlayer = playerlist.length > 0 ? 0 : -1;
			m_RoundWinPlayer = -1;
			m_GameWinPlayer = -1;
			var player:Player;
			PlayerList = new Array();
			for (var i:int = 0 ; i < playerlist.length ; ++i)
			{
				player = new Player(i, playerlist[i]);
				PlayerList.push(player);
			}
			CurrType = new Type();
		}
		public function Init():void
		{
			var i:int;
			DealType = DEAL_TYPE.ALLPLAYER;
			DealPlayerCnt = 0;	
			DealFrameCnt = 0;
			bRoundEnd = false;
			m_ActPlayer = PlayerList.length > 0 ? 0 : -1;
			m_RoundWinPlayer = m_ActPlayer;
			m_GameWinPlayer = -1;
			////////////////
			// 玩家手中的牌
			////////////////
			var player:Player;
			for (i = 0 ; i < PlayerList.length ; ++i)
			{
				player = PlayerList[i];
				player.ClearCards();
			}
			////////////////
			// 打出去的牌
			////////////////
			InvalidCardList.splice(0, InvalidCardList.length);
			////////////////
			// 洗牌
			////////////////
			RefreshCards();	
			
			NewRound();
			
		}
		/////////////////////////////
		// 摸牌
		/////////////////////////////
		public function PopCard(target:int = -1):CardInfo
		{
			var card:CardInfo = new CardInfo();
			if (CardList.length )
			{
				var card_info:CardInfo = CardList[0];
				card.number = card_info.number;
				card.mark = card_info.mark;
				card.target = target;
				card.open = card_info.open;
				card.position = card_info.position;
				card.speed = card_info.speed;
				card.state = card_info.state;				
				card.tarposition = card_info.tarposition;
				
				CardList.splice(0, 1);
			}
			
			return card;
		}
		/////////////////////////////
		// 出牌
		/////////////////////////////
		public function SendCard(sendlist:Array):void
		{
			var i:int;
			var card:CardInfo;
			var cnt:int = InvalidCardList.length - 1;
			while (InvalidCardList.length)
			{
				card  = InvalidCardList[cnt--];
				if (card.state == CARD_STATE.SEND)
				{
					card.state = CARD_STATE.INVALID;					
				}
				else if (card.state == CARD_STATE.INVALID)
				{
					break;
				}
			}
			
			sortCardList(sendlist);
			var card_info:CardInfo;
			for (i = 0 ; i < InvalidCardList.length ; ++i)
			{
				card_info = InvalidCardList[i];
				card_info.open = false;
			}
			for (i = 0 ; i < sendlist.length ; ++i)
			{
				card_info = sendlist[i];
				
				card = new CardInfo();
				card.number = card_info.number;
				card.mark = card_info.mark;
				card.open = true;// card_info.open;
				card.position = card_info.position;
				card.speed.x = 10000;
				card.speed.y = 10000;
				card.state = CARD_STATE.SEND;
				card.target = -2;
				card.tarposition.x = 350 + i * 20;
				card.tarposition.y = 280;
				
				InvalidCardList.push(card);
			}
		}
		public function NewRound():void
		{
			trace("新一轮开始");
			var i:int;
			var card_info:CardInfo;
			for (i = 0 ; i < InvalidCardList.length ; ++i)
			{
				card_info = InvalidCardList[i];
				card_info.open = false;
			}
			CurrType.Reset();
		}
		public function sortCardList(list:Array):void
		{
			list.sortOn(["number", "mark"], [Array.NUMERIC, Array.NUMERIC]);
		}
		/////////////////////////////
		// 洗牌
		/////////////////////////////
		private function RefreshCards():void 
		{
			var i:int, j:int;
			
			CardList.splice(0, CardList.length);
			var src:CardInfo, rand:CardInfo;
			var number:int = CARD_NUMBER.THREE;
			var lst_number:int = CARD_NUMBER.NONE;
			var mark:int;
			var src_list:Array = new Array();
			for (i = 0 ; i < CARD_MAX ; ++i)
			{
				mark = lst_number != number ? CARD_MARK.SPADE : ++mark;
				mark = number == CARD_NUMBER.JOKER ? CARD_MARK.HEART : mark;
				lst_number = number;
				src = new CardInfo(number, mark);
				var cnt:int = number == CARD_NUMBER.JOKER ? 10 : 1;
				for (j = 0 ; j < cnt ; ++j)
				{
					src_list.push(src);
				}
				
				if (mark >= CARD_MARK.DIAMOND)
				{
					++number;
					lst_number = CARD_NUMBER.NONE;
				}
				//trace("Src[index:" + i + " number:" + CARD_NUMBER.Name[src.number] + " mark:" + CARD_MARK.Name[src.mark] + "]");
			}
				
			var index:int;
			var card_info:CardInfo;
			while (src_list.length)
			{
				index = int(100 * Math.random()) % src_list.length;
				rand = src_list[index];
				card_info = new CardInfo(rand.number, rand.mark);
				CardList.push(card_info);
				trace("Card[index:" + index + " number:" + CARD_NUMBER.Name[rand.number] + " mark:" + CARD_MARK.Name[rand.mark] + " target:" + rand.target + "]");
				src_list.splice(index, 1);
			}			
				
			
		}
		public function NextPlayer():void
		{
			m_ActPlayer = m_ActPlayer >= (PlayerList.length - 1) ? 0 : ++m_ActPlayer;
		}
		public function Next2RoundWinPlayer():void
		{
			m_ActPlayer = m_RoundWinPlayer;
		}
		public function RoundWinPlayer(player:int):void
		{
			m_RoundWinPlayer = player;
		}
		public function GameWinPlayer(player:int):void
		{
			//var i:int, j:int;
			//var player:Player;
			//var card:CardInfo;
			//var flag:Boolean;
			//for (i = 0 ; i < PlayerList.length ; ++i)
			//{
				//player = PlayerList[i];
				//flag = CheckPlayerOnlyJoker(i);
				//if (m_GameWinPlayer == -1)
				//{
					// 手中有牌
					//if (player.CardList.length > 0)
					//{
						// 手中只有怪
						//if (flag)
						//{
							//m_GameWinPlayer = -2;
							//break;
						//}
					//}
					// 手中无牌
					//else
					//{
						//m_GameWinPlayer = player.GetIndex();
						//break;
					//}
					//
				//}
			//}
		//
			m_GameWinPlayer = player;
		}
		public function CheckPlayerCardEmpty(player:int):Boolean
		{
			var bRes:Boolean = false;
			if (player >= 0 && player < PlayerList.length)
			{
				bRes = PlayerList[player].CardList.length == 0;
			}
			
			return bRes;
		}
		public function CheckPlayerOnlyJoker(player:int):Boolean
		{
			var bRes:Boolean = false;
			if (player >= 0 && player < PlayerList.length)
			{
				var card:CardInfo;
				bRes = true;
				for (var i:int = 0 ; i < PlayerList[player].CardList.length ; ++i)
				{
					card = PlayerList[player].CardList[i];
					if (card.number != CARD_NUMBER.JOKER)
					{
						bRes = false;
						break;
					}
				}
			}
			
			return bRes;
		}
		public function GetActPlayer():int
		{
			return m_ActPlayer;
		}
		public function GetRoundWinPlayer():int
		{
			return m_RoundWinPlayer;
		}
		public function GetGameWinPlayer():int
		{
			return m_GameWinPlayer;
		}
		public function GetLocalPlayer():int
		{
			return m_LocalPlayer;
		}
		public function IsCardMoveEnd():Boolean
		{
			var bEnd:Boolean = true;
			var card:CardInfo;
			if (GameState == GAME_STATE.DEAL)
			{
				
			}
			else if (GameState == GAME_STATE.SEND)
			{
				
				var cnt:int = InvalidCardList.length - 1;
				while (InvalidCardList.length)
				{
					card  = InvalidCardList[cnt--];
					if (card.state == CARD_STATE.SEND)
					{
						if (!card.position.equals(card.tarposition))
						{
							bEnd = false;
							break;
						}
					}
					else if (card.state == CARD_STATE.INVALID)
					{
						break;
					}
				}
			}
			return bEnd;
		}
		/////////////////////
		// 判断牌型和开始牌
		/////////////////////
		public function GetType(list:Array):Type
		{
			trace("Type===>");
			var card:CardInfo;
			var i:int;
			var type:Type = new Type();
			
			
			var splitlist:Array = new Array(CARD_NUMBER.MAX);
			for (i = 0 ; i < CARD_NUMBER.MAX ; ++i)
			{
				splitlist[i] = new Array();
			}
			for (i = 0 ; i < list.length ; ++i)
			{
				card = list[i];
				splitlist[card.number].push(card.number);				
			}
			
			
			var startnumber:int = CARD_NUMBER.NONE;
			// 牌的最大长度
			var tmplist:Array;
			var maxlen:int = 0;
			var jokercnt:int = splitlist[CARD_NUMBER.JOKER].length;
			var numbertypecnt:int = 0;
			for (i = CARD_NUMBER.NONE+1 ; i < CARD_NUMBER.MAX ; ++i)
			{
				if (i != CARD_NUMBER.JOKER)
				{
					tmplist = splitlist[i];
					if (maxlen < tmplist.length)
					{
						maxlen = tmplist.length;					
					}
					if (tmplist.length > 0)
					{
						numbertypecnt++;
						if (startnumber == CARD_NUMBER.NONE)
						{
							startnumber = i;
						}
					}
				}
			}
			trace("numbertypecnt:" + numbertypecnt);
			trace("maxlen:" + maxlen);
			if (numbertypecnt == 1)
			{
				if (jokercnt > 0)
				{
					if ((maxlen + jokercnt) <= 3)
					{
						maxlen = maxlen + jokercnt;
					}
					else
					{
						numbertypecnt = numbertypecnt + (CARD_NUMBER.TWO - startnumber) >= jokercnt ? jokercnt : (CARD_NUMBER.TWO - startnumber);
					}
				}
			}
			else if (numbertypecnt >= 2)
			{
				if (jokercnt > 0)
				{
					if (jokercnt % maxlen == 0)
					{
						numbertypecnt = numbertypecnt + jokercnt / maxlen;
					}
				}
			}
			trace("numbertypecnt:" + numbertypecnt);
			trace("maxlen:" + maxlen);
			if (maxlen <= 3 && startnumber != CARD_NUMBER.NONE)
			{
				var cnt:int = 0;
				for (i = startnumber ; i < CARD_NUMBER.MAX ; ++i)
				{		
					if (cnt < numbertypecnt)
					{
						if (i != CARD_NUMBER.JOKER)
						{
							tmplist = splitlist[i];
							
							// 牌不足
							if (tmplist.length < maxlen)
							{
								trace("牌[" + i + "] 不足...");
								// joker填补
								if ((maxlen - tmplist.length) <= jokercnt)
								{
									trace("joker填补个数:" + (maxlen - tmplist.length));
									jokercnt = jokercnt - (maxlen - tmplist.length);
								}
								// joker不足
								else
								{
									trace("joker不足个数:" + (maxlen - tmplist.length));
									type.cardtype = CARD_TYPE.ERROR;
								}
							}
							else
							{
								trace("牌[" + i + "] 充足!");
							}
							
						}
						cnt++;
					}
					else
					{
						break;
					}
				}
				
				
			}
			else
			{
				type.cardtype = CARD_TYPE.ERROR;
			}
			
			
			//i = 0;
			//var lstnumber:int = list.length > 0 ? list[i++].number : CARD_NUMBER.NONE;
			//var cnt:int = list.length > 0 ? 1 : 0;
			//trace("numbertypecnt:" + numbertypecnt);
			//trace("maxlen:" + maxlen);
			//if (maxlen <= 3)
			//{
				//
				//for (; i < list.length ; ++i)
				//{				
					//card = list[i];
					//
					//trace("lstnumber:" + lstnumber);
					//trace("number:" + card.number);
					// 单独出王牌
					//if (list.length <= 1 && card.number == CARD_NUMBER.JOKER)
					//{
						//break;
					//}
					//
					//if (card.number != lstnumber)
					//{
						// 牌相连
						//if (card.number == (lstnumber + 1))
						//{
							//trace("牌相连");
							//if (cnt < maxlen)
							//{
								//trace("牌["+card.number+"] 不足");
								// joker填补
								//if ((maxlen - cnt) <= jokercnt)
								//{
									//trace("joker填补个数:" + (maxlen - cnt));
									//jokercnt = jokercnt - (maxlen - cnt);
								//}
								// joker不足
								//else
								//{
									//trace("joker不足");
									//type.cardtype = CARD_TYPE.ERROR;
								//}
							//}
						//}
						// 不相连
						//else
						//{
							//trace("不相连");
							// joker填补
							//if (maxlen <= jokercnt)
							//{
								//trace("joker填补个数:" + maxlen);
								//jokercnt = jokercnt - maxlen;
							//}
							// joker不足
							//else
							//{
								//trace("joker不足");
								//type.cardtype = CARD_TYPE.ERROR;
								//break;
							//}
						//}
						//cnt = 1;
						//lstnumber = card.number;
					//}
					//else
					//{
						//cnt++;
					//}
				//}
				//
				//
			//}
			//else
			//{
				//type.cardtype = CARD_TYPE.ERROR;
			//}
			// joker只能用来配牌，不能有剩余
			if (jokercnt > 0)
			{
				type.cardtype = CARD_TYPE.ERROR;
			}
			if (type.cardtype != CARD_TYPE.ERROR)
			{
				// 单牌/顺子
				if (maxlen == 1)
				{
					// 单牌
					if (numbertypecnt == 1)
					{
						type.cardtype = CARD_TYPE.SINGLE;
						type.start = startnumber;
						type.length = numbertypecnt;
					}
					// 顺子
					else if (numbertypecnt >= 3)
					{
						type.cardtype = CARD_TYPE.STRAIGHT;
						type.start = startnumber;
						type.length = numbertypecnt;
					}
					else
					{
						type.cardtype = CARD_TYPE.ERROR;
					}
				}
				// 双牌/连队
				else if (maxlen == 2)
				{
					// 双牌
					if (numbertypecnt == 1)
					{
						type.cardtype = CARD_TYPE.DOUBLE;
					}
					// 连队
					else 
					{
						type.cardtype = CARD_TYPE.DOUBLESTRAIGHT;
					}
					type.start = startnumber;
					type.length = numbertypecnt;
				}
				// 三牌/三连队
				else if (maxlen == 3)
				{
					// 三牌
					if (numbertypecnt == 1)
					{
						type.cardtype = CARD_TYPE.THREE;
					}
					// 三连队
					else 
					{
						type.cardtype = CARD_TYPE.THREESTRAIGHT;
					}
					type.start = startnumber;
					type.length = numbertypecnt;
				}
				else
				{
					type.cardtype = CARD_TYPE.ERROR;
				}
			}
			
			
			
			return type;
		}
		/////////////////////
		// 规则
		/////////////////////
		public function Check(tartype:Type):int
		{
			var res:int = ERROR_TYPE.SUCCESS;
			if (tartype.cardtype != CARD_TYPE.ERROR)
			{
				if (CurrType.cardtype != CARD_TYPE.NONE)
				{
					// target不是炸弹
					if (tartype.cardtype != CARD_TYPE.THREE)
					{
						// 牌型不匹配
						if (CurrType.cardtype != tartype.cardtype)
						{
							res = ERROR_TYPE.CARDTYPE;
						}
						// 牌型匹配
						else
						{
							// 压上
							if (CurrType.start == (tartype.start - 1))
							{
								if (CurrType.length != tartype.length)
								{
									res = ERROR_TYPE.LENGTH;
								}
							}
							// 没有压上
							else
							{
								res = ERROR_TYPE.NUMBER;
								// TARGET的开始为2
								if (tartype.start == CARD_NUMBER.TWO && CurrType.start != CARD_NUMBER.TWO)
								{
									res = ERROR_TYPE.SUCCESS;
								}
							}
						}
					}
					// target是炸弹
					else
					{
						// currtype是炸弹
						if (CurrType.cardtype == CARD_TYPE.THREE)
						{
							if (tartype.start <= CurrType.start)
							{
								res = ERROR_TYPE.NUMBER;
							}
						}
						
					}
				}
			}
			else
			{
				res = ERROR_TYPE.OTHERS;
			}
			
			return res;
		}
		public function AutoSend():Array
		{
			var sendlist:Array = new Array();
			var player:Player = PlayerList[m_ActPlayer];
			var card:CardInfo;
			var i:int;
			var jokercnt:int = GetNumberCnt(player.CardList, CARD_NUMBER.JOKER);
			
			// 当前牌为单牌
			if (CurrType.cardtype == CARD_TYPE.SINGLE)
			{
				var cnt:int;
				// 不是2
				if (CurrType.start < CARD_NUMBER.TWO)
				{
					cnt = GetNumberCnt(player.CardList, CurrType.start);
				}
				// 2
				else
				{
					//for (i = CARD_NUMBER.MAX - 1 ; i >= 0 ; --i)
					//{
						//if (i != CARD_NUMBER.JOKER)
						//{
							//cnt = GetNumberCnt(i);
							//if (cnt > 3
						//}
					//}
				}
			
			}
			else if (CurrType.cardtype == CARD_TYPE.DOUBLE)
			{
				
			}
			else if (CurrType.cardtype == CARD_TYPE.THREE)
			{
				
			}
			else if (CurrType.cardtype == CARD_TYPE.STRAIGHT)
			{
				
			}
			else if (CurrType.cardtype == CARD_TYPE.DOUBLESTRAIGHT)
			{
				
			}
			
			return sendlist;
		}
		private function GetNumberCnt(list:Array, number:int):int
		{
			var cnt:int = 0;
			var card:CardInfo;
			for (var i:int = 0 ; i < list.length ; ++i)
			{
				card = list[i];
				if (card.number == number)
				{
					cnt++;
				}
			}
			
			return cnt;
		}
	}
	
}