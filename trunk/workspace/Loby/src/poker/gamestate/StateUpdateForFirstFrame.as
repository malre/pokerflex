package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.GameObjectManager;
	import poker.NetManager;
	
	public class StateUpdateForFirstFrame extends NetRequestState
	{
		private static var instance:StateUpdateForFirstFrame = null;
		public function StateUpdateForFirstFrame()
		{
			super();
			showError = false;
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
			NetManager.sender.request = {"getPlay":"true","getCards":"true","getPlayers":"true","update":"0.0"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 判断是否是刚开始的游戏，如果是需要进行发牌动画的演示
				// 要求演示的速度非常的快，因为这个时候其实游戏是已经开始计算时间了
				// 保证在1-2秒左右为最佳
				if(obj.cards[0].number == 27 && obj.cards[1].number == 27 && obj.cards[2].number == 27
					&& obj.cards[3].number == 27)
				{
					Game.Instance.gameState = 20;
					Game.Instance.cardAnimateCounter = 0;
					Game.Instance.readyStateInit();
				}
				else
				{
					//	更新所有的游戏信息
					// 进入游戏逻辑，开始进行update处理
					Game.Instance.gameState = 2;
					// 
					Game.Instance.readyStateInit();
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
					Game.Instance.lastPlayer = obj.play.last;
					Game.Instance.curPlayerLast = Game.Instance.curPlayer;
					Game.Instance.curPlayer = obj.play.next;
					Game.Instance.gamePlayerLeftTimeDef = obj.time;
					Game.Instance.initPlayerLeftStartTime();
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
					// 显示其他三家的牌堆
					Game.Instance.showCardback(true);
					// 使过往牌记录的查看按钮有效
					FlexGlobals.topLevelApplication.gamePoker.btnCardView.visible = true;
					FlexGlobals.topLevelApplication.gamePoker.cpuAI.visible = true;
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			// 如果此次发送超时， 同样的内容将会被重发
			NetManager.Instance.send(NetManager.send_updateWhileGameFirstframe);
		}
	}
}