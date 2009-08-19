package lobystate
{
	public class StateGetPlayerInfo extends NetRequestState
	{
		private static var instance:StateGetPlayerInfo = null;
		// construct
		public function StateGetPlayerInfo()
		{
			super();
		}
		
		public static function get Instance():StateGetPlayerInfo
		{
			if(instance == null)
				instance = new StateGetPlayerInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_playerInfo;
			LobyNetManager.Instance.httpservice.send();
			//request_playerinfo = true;
		}
		override public function receive(obj:Object):void
		{
			
		}

	}
}