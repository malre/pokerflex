package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateJoinLoby extends NetRequestState
	{
		private static var instance:StateJoinLoby = null;
		private var lobyid:int;
		private var lobyAddress:String;

		public function StateJoinLoby()
		{
			super();
		}
		public static function get Instance():StateJoinLoby
		{
			if(instance == null)
				instance = new StateJoinLoby();
			return instance;
		}
		public function setLobyAddress(val:String):void
		{
			lobyAddress = val;
		}
		public function setLobyid(id:int):void
		{
			lobyid = id;
		}
		
		override public function send(obj:StateManager):void
		{
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("加入大厅中……");

			LobyNetManager.Instance.httpservice.url = lobyAddress + LobyNetManager.URL_addloby;
			LobyNetManager.Instance.httpservice.request = {"lid":lobyid}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 成功之后需要把player对象的lid进行赋值
				StateGetPlayerInfo.Instance.lastSuccData.player.lid = lobyid;
				// 设置左边的玩家所在房间位置的提示信息
				FlexGlobals.topLevelApplication.lobbypanel.setCurrentLobby(lobyid);
				FlexGlobals.topLevelApplication.currentState = "room";
				FlexGlobals.topLevelApplication.toroom_clickHandler(null);
				// 切换大厅使回到游戏按钮无效
				FlexGlobals.topLevelApplication.btn2LastTable.enabled = false;

				LobyNetManager.Instance.send(LobyNetManager.tableInfo);
				
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				// 加入房间失败
//				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = false;
//				FlexGlobals.topLevelApplication.functionpanel.BtnCreateTable.enabled = false;

				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
			LobyErrorState.Instance.showErrMsg("加入房间失败");
		}
		
	}
}