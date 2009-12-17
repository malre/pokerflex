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
			var arr:Array = GameObjectManager.Instance.getSelectedCards();
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
							// 判断是否到了玩家的出牌回合
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
						}
						// 游戏意外结束， OR 游戏胜利
						// 
						else //if(obj.status == 1)
						{
							// 关闭所有的出牌按钮
							FlexGlobals.topLevelApplication.gamePoker.commandbar.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.sandglass.visible = false;
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
							SoundManager.Instance().playSE("win");
							// 消去其他三家玩家头像和信息显示
							FlexGlobals.topLevelApplication.gamePoker.playerinfoLeft.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.playerinfoUp.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.playerinfoRight.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarUp.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarLeft.visible = false;
							FlexGlobals.topLevelApplication.gamePoker.Img_playerAvatarRight.visible = false;
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
			if(++timeoutCounter > timeoutCounterMax)
			{
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.sendcardFail);
			}else{
				NetManager.Instance.send(NetManager.send_sendcardsWhileGame);
			}
		}
	}
}