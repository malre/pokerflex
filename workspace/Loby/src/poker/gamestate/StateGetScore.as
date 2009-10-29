package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;
	
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
		override public function fault():void
		{
			NetManager.Instance.send(NetManager.send_getScore);
		}
	}
}