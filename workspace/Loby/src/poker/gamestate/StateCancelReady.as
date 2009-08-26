package poker.gamestate
{
	import lobystate.NetRequestState;
	
	public class StateCancelReady extends NetRequestState
	{
		private static var instance:StateCancelReady = null;

		public function StateCancelReady()
		{
			super();
		}
		
		public static function get Instance():StateCancelReady
		{
			if(instance == null)
				instance = new StateCancelReady();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
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