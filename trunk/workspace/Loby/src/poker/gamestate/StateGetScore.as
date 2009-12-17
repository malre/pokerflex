package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;
	import poker.timeoutDealwithGUI;
	
	public class StateGetScore extends NetRequestState
	{
		private static var instance:StateGetScore = null;
		
		public function StateGetScore()
		{
			super();
		}
		public static function get Instance():StateGetScore
		{
			if(instance == null)
				instance = new StateGetScore();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.requestTimeout = 3000;
			NetManager.sender.request = {"getScore":"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.gamePoker.showPopupDlg(obj);
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
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.getPlayerScore);
			}else{
				NetManager.Instance.send(NetManager.send_getScore);
			}
		}
	}
}