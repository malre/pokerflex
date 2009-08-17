package lobystate
{
	public class StateUpdateRoomInfo extends NetRequestState
	{
		private static var instance:StateUpdateRoomInfo = null;
		// construct
		public function StateUpdateRoomInfo()
		{
			super();
		}
		
		public static function get Instance():StateUpdateRoomInfo
		{
			if(instance == null)
				instance = new StateUpdateRoomInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.Instance.URL_lobysonAddress + LobyNetManager.URL_roomInfo;
			LobyNetManager.Instance.httpservice.send();
			//request_roominfo = true;
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}