package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateCheckItemNum extends NetRequestState
	{
		private static var instance:StateCheckItemNum = null;

		public function StateCheckItemNum()
		{
			super();
		}

		public static function get Instance():StateCheckItemNum
		{
			if(instance == null)
				instance = new StateCheckItemNum();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_checkItemNum;
			LobyNetManager.Instance.httpservice.request = {"iid":"1010314"};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.createTable.visible = true;
				FlexGlobals.topLevelApplication.createTable.setLobbyGoldrate();
				FlexGlobals.topLevelApplication.createTable.currentState = "State2";
				return true;
			}
			else{
				LobyManager.Instance.windowMutex = false;
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			LobyManager.Instance.windowMutex = false;
		}
	}
}