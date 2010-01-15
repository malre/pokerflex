package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateSetSkin extends NetRequestState
	{
		private static var instance:StateSetSkin = null;

		public function StateSetSkin()
		{
			super();
		}

		public static function get Instance():StateSetSkin
		{
			if(instance == null)
				instance = new StateSetSkin();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.setskin;
			LobyNetManager.Instance.httpservice.request = {"skinNo":""};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
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