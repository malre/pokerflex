package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.NetManager;

	public class StateUpdateWhileWait extends NetRequestState
	{
		private static var instance:StateUpdateWhileWait = null;

		public function StateUpdateWhileWait()
		{
			super();
		}
		public static function get Instance():StateUpdateWhileWait
		{
			if(instance == null)
				instance = new StateUpdateWhileWait();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.updater.url = NetManager.sendURL_game;
			NetManager.updater.request = {getPlayers:"true"};
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