package lobystate
{
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;

	public class StateSetSkin extends NetRequestState
	{
		private static var instance:StateSetSkin = null;
		private var skin:int = 0;

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
		
		public function setSkin(no:int):void
		{
			skin = no;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_setSkin;
			LobyNetManager.Instance.httpservice.request = {"skinNo":skin};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				Alert.yesLabel = "确定";
				Alert.noLabel = "取消";
				Alert.show("新的皮肤将会在重新载入游戏以后生效，你确定现在重新载入吗？", "", Alert.YES|Alert.NO, null/*Application(FlexGlobals.topLevelApplication)*/, alertClickHandler);
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

		private function alertClickHandler(event:CloseEvent):void{
			if(event.detail == Alert.YES){
				navigateToURL(new URLRequest("javascript:location.reload();"),"_self");
			}
			else{
			}
		}
	}
}