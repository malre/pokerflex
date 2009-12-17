package lobystate
{
	import flash.events.Event;
	
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
			LobyNetManager.Instance.httpservice.request = {};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				Alert.show("成功退出游戏桌","");
				
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