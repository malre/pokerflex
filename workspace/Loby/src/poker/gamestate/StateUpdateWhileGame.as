package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.Game;
	import poker.GameObjectManager;
	import poker.NetManager;
	
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
							// 判断是否到了玩家的出牌回合
							if(obj.play.next == Game.Instance.selfseat)
							{
								// 显示所有的按钮
								LobyManager.Instance.gamePoker.btnSendCards.visible = true;
								LobyManager.Instance.gamePoker.btnSendCards.enabled = false;
								LobyManager.Instance.gamePoker.btnDiscard.visible = true;
								LobyManager.Instance.gamePoker.btnDiscard.enabled = true;
								LobyManager.Instance.gamePoker.btnHint.visible = true;
								if(obj.play.last == obj.play.next)
								{
									LobyManager.Instance.gamePoker.btnDiscard.enabled = false;
								}
							}
							else{
								LobyManager.Instance.gamePoker.btnSendCards.visible = false;
								LobyManager.Instance.gamePoker.btnDiscard.visible = false;
								LobyManager.Instance.gamePoker.btnHint.visible = false;
							}
							Game.Instance.lastPlayer = obj.play.last;
							if(Game.Instance.curPlayer != obj.play.next)	// 出牌权交换
							{
								Game.Instance.initPlayerLeftStartTime();
							}
							Game.Instance.curPlayer = obj.play.next;
							// 描画玩家手上的牌
							Game.Instance.drawPlayerCards(obj);
							// 描画玩家打出来的牌
							Game.Instance.drawOtherCards(obj.play.history, obj.status);
							// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
							Game.Instance.updatePlayerCardsInfo(obj);
							// 描画出牌剩余时间
							Game.Instance.updateCurPlayerIcon(obj);
							// 对时间进行修正
							Game.Instance.modifyPlayerLefttime(obj);
						}
						// 游戏意外结束， OR 游戏胜利
						// 
						else if(obj.status == 1)
						{
							// 描画玩家手上的牌
							Game.Instance.drawPlayerCards(obj);
							// 描画玩家打出来的牌
							Game.Instance.drawOtherCards(obj.play.history, obj.status);
							// 描画玩家的剩余牌数,以及当前应该出牌玩家的提示
							Game.Instance.updatePlayerCardsInfo(obj);
							NetManager.Instance.send(NetManager.send_getGameoverPlayerLeftCard);
							Game.Instance.gameState = 5;	// 结束统计状态
							
							//GameObjectManager.Instance.shutdown();
							// 背景还是要保留
							//GameObjectManager.Instance.setVisibleByName("BG", true);
							//Game.Instance.gameState = 5;
							//LobyManager.Instance.gamePoker.showPopupDlg();
						}
					}
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
			NetManager.Instance.update(NetManager.send_updateWhileGame);
		}
	}
}