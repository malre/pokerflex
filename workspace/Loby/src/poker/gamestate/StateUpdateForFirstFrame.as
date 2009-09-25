package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.Game;
	import poker.GameObjectManager;
	import poker.NetManager;
	
	public class StateUpdateForFirstFrame extends NetRequestState
	{
		private static var instance:StateUpdateForFirstFrame = null;
		public function StateUpdateForFirstFrame()
		{
			super();
		}
		public static function get Instance():StateUpdateForFirstFrame
		{
			if(instance == null)
				instance = new StateUpdateForFirstFrame();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.request = {getPlay:"true",getCards:"true",getPlayers:"true",update:"0.0"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				//	更新所有的游戏信息
				// 进入游戏逻辑，开始进行update处理
				Game.Instance.gameState = 2;
				// 
				Game.Instance.readyStateInit();
				if(obj.play.next == Game.Instance.selfseat)
				{
					// 显示所有的按钮
					LobyManager.Instance.gamePoker.commandbar.visible = true;
					LobyManager.Instance.gamePoker.commandbar.btnSendCards.enabled = false;
					LobyManager.Instance.gamePoker.commandbar.btnDiscard.enabled = true;
					if(obj.play.last == obj.play.next)
					{
						LobyManager.Instance.gamePoker.commandbar.btnDiscard.enabled = false;
					}
				}
				else{
					LobyManager.Instance.gamePoker.commandbar.visible = false;
				}
				Game.Instance.lastPlayer = obj.play.last;
				Game.Instance.curPlayer = obj.play.next;
				Game.Instance.gamePlayerLeftTimeDef = obj.time;
				Game.Instance.initPlayerLeftStartTime();
				// 更新其他玩家的名字和状态
				Game.Instance.updatePlayerName(obj);
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
				// 左边的玩家的牌堆
				// 上面的玩家的牌堆
				// 右边的玩家的牌堆
				GameObjectManager.Instance.setVisibleByName("CardbackRight", true);
				GameObjectManager.Instance.setVisibleByName("CardbackUp", true);
				GameObjectManager.Instance.setVisibleByName("CardbackLeft", true);
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
			// 如果此次发送超时， 同样的内容将会被重发
			NetManager.Instance.send(NetManager.send_updateWhileGameFirstframe);
		}
	}
}