package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.GameObjectManager;
	import poker.NetManager;
	
	import soundcontrol.SoundManager;
	
	public class StateUpdateWhileGame extends NetRequestState
	{
		private static var instance:StateUpdateWhileGame = null;

		public function StateUpdateWhileGame()
		{
			super();
		}
		public static function get Instance():StateUpdateWhileGame
		{
			if(instance == null)
				instance = new StateUpdateWhileGame();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.updater.url = NetManager.sendURL_game;
			NetManager.updater.request = {"getPlay":"true","getCards":"true", "update":lastSuccData.update};
			NetManager.updater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				//	更新所有的游戏信息
				// 游戏中
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
							//
							SoundManager.Instance().playSE("win");
							// 消去其他三家玩家头像和信息显示
							FlexGlobals.topLevelApplication.gamePoker.playerinfoLeft.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.playerinfoUp.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.playerinfoRight.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.label_thinking.visible = false;
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
			NetManager.Instance.update(NetManager.send_updateWhileGame);
		}
	}
}