package lobystate
{
	import flash.events.Event;
	
	public class StateGetSkin extends NetRequestState
	{
		private static var instance:StateGetSkin = null;
		public var skin:int = 0;
		
		public function StateGetSkin()
		{
			super();
		}
		
		public static function get Instance():StateGetSkin
		{
			if(instance == null)
				instance = new StateGetSkin();
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
				skin = obj.skinNo;
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