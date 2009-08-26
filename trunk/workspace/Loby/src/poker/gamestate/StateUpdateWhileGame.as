package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
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
			NetManager.updater.request = {getPlay:"true",getCards:"true"};
			NetManager.updater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
		}
	}
}