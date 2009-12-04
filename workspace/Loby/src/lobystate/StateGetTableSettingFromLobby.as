package lobystate
{
	import mx.core.FlexGlobals;
	import mx.rpc.http.HTTPService;

	public class StateGetTableSettingFromLobby extends NetRequestState
	{
		private static var instance:StateGetTableSettingFromLobby = null;
		
		public function StateGetTableSettingFromLobby()
		{
			super();
		}

		public static function get Instance():StateGetTableSettingFromLobby
		{
			if(instance == null)
				instance = new StateGetTableSettingFromLobby();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("获得游戏桌设置……");

			var hp:HTTPService = LobyNetManager.Instance.httpservice;
			hp.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getTableSetting;
			hp.request = {};
			hp.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 获得房间的设置
				
				FlexGlobals.topLevelApplication.gamePoker.startup(obj);
				// 
				LobyManager.Instance.changeState(2);
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
		}
		override public function fault():void
		{
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}
	}
}