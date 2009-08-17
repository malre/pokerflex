package lobystate
{
	public class StateGetTableInfo extends NetRequestState
	{
		private static var instance:StateGetTableInfo = null;
		
		public function StateGetTableInfo()
		{
			super();
		}

		public static function get Instance():StateGetTableInfo
		{
			if(instance == null)
				instance = new StateGetTableInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}