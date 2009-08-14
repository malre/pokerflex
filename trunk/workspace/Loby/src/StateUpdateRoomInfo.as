package
{
	public class StateUpdateRoomInfo extends NetRequestState
	{
		private static var instance:StateUpdateRoomInfo = null;
		// construct
		public function StateUpdateRoomInfo()
		{
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
			LobyNetManager.Instance.httpservice.url = "http://192.168.18.24/web/world/game/list/list";
			LobyNetManager.Instance.httpservice.send();
			//request_roominfo = true;
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}