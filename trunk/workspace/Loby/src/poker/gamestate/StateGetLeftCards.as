package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.Game;
	import poker.NetManager;
	import poker.timeoutDealwithGUI;
	
	public class StateGetLeftCards extends NetRequestState
	{
		private static var instance:StateGetLeftCards = null;

		public function StateGetLeftCards()
		{
			super();
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
				// 判断除了自己以外还有哪几个人牌没有出光
				for(var i:int=0;i<4;i++)
				{
					if(obj.cards[i].number != 0){
						Game.Instance.drawPlayerHandCards(obj,i);
					}
				}
				NetManager.Instance.send(NetManager.send_getScore);
				// 清空计数器
				StateGetScore.Instance.clearCounter();
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault():void
		{
			if(++timeoutCounter > timeoutCounterMax)
			{
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.getPlayerLeftcards);
			}else{
				NetManager.Instance.send(NetManager.send_getGameoverPlayerLeftCard);
			}
		}
	}
}