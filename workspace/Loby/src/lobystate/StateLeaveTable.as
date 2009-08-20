package lobystate
{
	import mx.controls.Alert;

	public class StateLeaveTable extends NetRequestState
	{
		private static var instance:StateLeaveTable = null;

		public function StateLeaveTable()
		{
			super();
		}
		
		public static function get Instance():StateLeaveTable
		{
			if(instance == null)
				instance = new StateLeaveTable();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_leaveTable;
			LobyNetManager.Instance.httpservice.send();
			//request_playerinfo = true;
		}
		override public function receive(obj:Object):void
		{
			Alert.show("成功退出游戏桌","");
		}
	}
}