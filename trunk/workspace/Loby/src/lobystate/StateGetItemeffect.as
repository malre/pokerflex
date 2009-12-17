package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateGetItemeffect extends NetRequestState
	{
		private static var instance:StateGetItemeffect = null;
		
		public function StateGetItemeffect()
		{
			super();
		}
		
		public static function get Instance():StateGetItemeffect
		{
			if(instance == null)
				instance = new StateGetItemeffect();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getItemEffect;
			LobyNetManager.Instance.httpservice.request = {}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.playerinfo.visible = true;
				FlexGlobals.topLevelApplication.playerinfo.currentState="StateMain";
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			LobyErrorState.Instance.showErrMsg("失败，超时。");
		}
		
	}
}