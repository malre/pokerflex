package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;

	public class StateKickPlayer extends NetRequestState
	{
		private static var instance:StateKickPlayer = null;

		public function StateKickPlayer()
		{
			super();
		}

		public static function get Instance():StateKickPlayer
		{
			if(instance == null)
				instance = new StateKickPlayer();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_kickplayer;
			NetManager.sender.requestTimeout = 3000;
			var pid:int = FlexGlobals.topLevelApplication.gamePoker.gameMenu.getPid();
			
			NetManager.sender.request = {"pid":pid};
			NetManager.sender.send();
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
		override public function fault(event:Event):void
		{
		}
	}
}
