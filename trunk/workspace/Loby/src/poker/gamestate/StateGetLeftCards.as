package poker.gamestate
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.NetManager;
	import poker.timeoutDealwithGUI;
	
	public class StateGetLeftCards extends NetRequestState
	{
		private static var instance:StateGetLeftCards = null;
		private var timer:Timer;

		public function StateGetLeftCards()
		{
			super();
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, waitAnimationOver);
		}
		public static function get Instance():StateGetLeftCards
		{
			if(instance == null)
				instance = new StateGetLeftCards();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.requestTimeout = 3000;
			NetManager.sender.request = {"getCards":"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 如果成功的接收到了游戏结束的消息，无论如何都需要判断游戏的最后的动画是否结束
				// 定时器监听事件，直到所有的游戏中动画都结束了以后，才可以继续进行后面的处理。
				timer.start();
//				// 判断除了自己以外还有哪几个人牌没有出光
//				for(var i:int=0;i<4;i++)
//				{
//					if(obj.cards.hasOwnProperty(i.toString()))
//					{
//						if(obj.cards[i].number != 0){
//							Game.Instance.drawPlayerHandCards(obj,i);
//						}
//					}
//				}
//				NetManager.Instance.send(NetManager.send_getScore);
				// 清空计数器
				StateGetScore.Instance.clearCounter();
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
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.getPlayerLeftcards);
			}else{
				NetManager.Instance.send(NetManager.send_getGameoverPlayerLeftCard);
			}
		}
		
		private function waitAnimationOver(event:TimerEvent):void
		{
			if(Game.Instance.checkAnimationOver()){
				timer.stop();
				
				// 消去其他三家玩家头像和信息显示
				FlexGlobals.topLevelApplication.gamePoker.playerinfoLeft.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.playerinfoUp.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.playerinfoRight.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.avatarUpGroup.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.avatarLeftGroup.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.avatarRightGroup.visible = false;
				FlexGlobals.topLevelApplication.gamePoker.label_thinking.visible = false;
				// 判断除了自己以外还有哪几个人牌没有出光并显示
				var obj:Object = lastSuccData;
				for(var i:int=0;i<4;i++)
				{
					if(obj.cards.hasOwnProperty(i.toString()))
					{
						if(obj.cards[i].number != 0){
							Game.Instance.drawPlayerHandCards(obj,i);
						}
					}
				}
				NetManager.Instance.send(NetManager.send_getScore);
			}
		}
	}
}