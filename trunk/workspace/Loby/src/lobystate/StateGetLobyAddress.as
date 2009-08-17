package lobystate
{
	public class StateGetLobyAddress extends NetRequestState
	{
		private static var instance:StateGetLobyAddress = null;
		
		public function StateGetLobyAddress()
		{
			super();
		}

		public static function get Instance():StateGetLobyAddress
		{
			if(instance == null)
				instance = new StateGetLobyAddress();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.Instance.URL_lobysonAddress + LobyNetManager.URL_playerInfo;
			LobyNetManager.Instance.httpservice.send();
			//request_playerinfo = true;
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}