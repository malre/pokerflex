package poker.gamestate
{
	import lobystate.NetRequestState;
	
	public class StateLeaveTable extends NetRequestState
	{
		private static var instance:StateNotifyReady = null;

		public function StateLeaveTable()
		{
			super();
		}

		public static function get Instance():StateNotifyReady
		{
			if(instance == null)
				instance = new StateNotifyReady();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
			NetManager.updater.url = NetManager.sendURL_ready;
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