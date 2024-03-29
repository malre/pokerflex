package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.GameObjectManager;
	import poker.NetManager;
	import poker.timeoutDealwithGUI;
	
	import soundcontrol.SoundManager;
	
	public class StateSendCards extends NetRequestState
	{
		private static var instance:StateSendCards = null;

		public function StateSendCards()
		{
			super();
			showError = false;
		}
		
		public static function get Instance():StateSendCards
		{
			if(instance == null)
				instance = new StateSendCards();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
			var arr:Array = GameObjectManager.Instance.getSelectedCardsandMark();
			var data:String = "";
			for(var id:int=0;id<arr.length;id++)
			{
				data += arr[id].toString();
				if(id != arr.length-1)
					data += ",";
			}
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.requestTimeout = 3;
			NetManager.sender.request = {"play":data, "getPlay":"true", "getCards":"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				if(Game.Instance.frametimeJudge(obj.update))
				{
					if(Game.Instance.gameState == 2)
					{
						// 正常游戏中
						if(obj.status == 0)
						{
							Game.Instance.lastPlayer = obj.play.last;
							if(Game.Instance.curPlayer != obj.play.next)	// 出牌权交换
							{
								Game.Instance.initPlayerLeftStartTime();
							}
							Game.Instance.curPlayerLast = Game.Instance.curPlayer;
							Game.Instance.curPlayer = obj.play.next;
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
							// 判断是否到了玩家的出牌回合
							if(obj.play.next == Game.Instance.selfseat)
							{
								// 首先判断是不是在CPU的托管状态
								if(Game.Instance.isCpuAI)
								{
									if(obj.play.next == obj.play.last)
									{
										if(Game.Instance.PlayerCards.length != 0)
										{
											var cards:Array = new Array();
											GameObjectManager.Instance.deselectAllCards();
											cards.push(Game.Instance.PlayerCards[Game.Instance.PlayerCards.length-1])
											GameObjectManager.Instance.selectCards(cards);
											Game.Instance.sendcards();
										}
									}
									else{
										GameObjectManager.Instance.deselectAllCards();
										var selcards:Array = GameObjectManager.Instance.showHintCards(StateUpdateWhileGame.Instance.lastSuccData.play.last_card);
										if(selcards.length > 0)
										{
											GameObjectManager.Instance.selectCards(selcards[0]);
											Game.Instance.sendcards();
										}
										else{
											Game.Instance.pass();
										}		
									}
								}
								else
								{
									// 显示所有的按钮
									FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = true;
									if(obj.play.last == obj.play.next)
										FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled = false;
									else
										FlexGlobals.topLevelApplication.gamePoker.commandbar.btnDiscard.enabled = true;
									
									FlexGlobals.topLevelApplication.gamePoker.commandbar.btnSendCards.enabled = Game.Instance.isSendBtnEnable();
								}
							}
							else{
								FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = false;
							}
						}
						// 游戏意外结束， OR 游戏胜利
						// 
						else //if(obj.status == 1)
						{
							// 关闭所有的出牌按钮
							FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.sandglass.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.label_leftTimeCounter.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.cancelCpu();
							// 描画玩家手上的牌
							Game.Instance.drawPlayerCards(obj);
							// 描画玩家打出来的牌
							Game.Instance.drawOtherCards(obj, obj.status);
							// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
							Game.Instance.updatePlayerCardsInfo(obj);
							NetManager.Instance.send(NetManager.send_getGameoverPlayerLeftCard);
							// 清空计数器
							StateGetLeftCards.Instance.clearCounter();
							
							Game.Instance.gameState = 5;	// 结束统计状态
						}
					}
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			if(++timeoutCounter > timeoutCounterMax)
			{
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.sendcardFail);
			}else{
				NetManager.Instance.send(NetManager.send_sendcardsWhileGame);
			}
		}
	}
}