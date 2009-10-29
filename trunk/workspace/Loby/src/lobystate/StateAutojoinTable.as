package lobystate
{
	import mx.core.FlexGlobals;

	public class StateAutojoinTable extends NetRequestState
	{
		private static var instance:StateAutojoinTable = null;

		public function StateAutojoinTable()
		{
			super();
		}

		public static function get Instance():StateAutojoinTable
		{
			if(instance == null)
				instance = new StateAutojoinTable();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_autoAddlobby;
			LobyNetManager.Instance.httpservice.request = {"getPlayers":true}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.gamePoker.startup(obj);
				// 
				LobyManager.Instance.changeState(2);
				return true;
			}
			else{
				LobyErrorState.Instance.showErrMsg("没有找到适合的牌桌");
				return false;
			}
			
		}
		override public function fault():void
		{
			LobyErrorState.Instance.showErrMsg("加入房间失败");
		}
	}
}