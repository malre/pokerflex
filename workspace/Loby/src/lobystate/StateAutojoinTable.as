package lobystate
{
	import flash.events.Event;
	
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
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("自动选择游戏桌，准备加入……");

			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_autoAddlobby;
			LobyNetManager.Instance.httpservice.request = {"getPlayers":true}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				StateLobyJoinTable.Instance.setTablename(obj.room.name);
				FlexGlobals.topLevelApplication.gamePoker.startup(obj);
				// 
				LobyManager.Instance.changeState(2);

				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				LobyErrorState.Instance.showErrMsg("没有找到适合的牌桌");
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
			LobyErrorState.Instance.showErrMsg("加入房间失败,意外失败");
		}
	}
}