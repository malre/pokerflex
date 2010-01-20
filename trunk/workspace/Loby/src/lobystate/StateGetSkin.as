package lobystate
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.core.FlexGlobals;
	
	public class StateGetSkin extends NetRequestState
	{
		private static var instance:StateGetSkin = null;
		public var skin:int = 0;
		private var lb:Object = null;
		
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
		
		public function setLoadingBarObj(loadingbar:Object):void
		{
			lb = loadingbar;
		}
		
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getSkin;
			LobyNetManager.Instance.httpservice.request = {"skinNo":""};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				skin = obj.skinNo;
				lb.loadSuccess();
				return true;
			}
			else{
//				navigateToURL(new URLRequest("javascript:location.reload();"),"_self")
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			navigateToURL(new URLRequest("javascript:location.reload();"),"_self");
		}
	}
}