package lobystate
{
	import flash.events.Event;
	import mx.core.FlexGlobals;

	public class StateLeaveLoby extends NetRequestState
	{
		private static var instance:StateLeaveLoby = null;

		public function StateLeaveLoby()
		{
			super();
		}

		public static function get Instance():StateLeaveLoby
		{
			if(instance == null)
				instance = new StateLeaveLoby();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("离开大厅中……");

			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_leaveloby;
			LobyNetManager.Instance.httpservice.request = {};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				StateGetPlayerInfo.Instance.lastSuccData.player.lid = 0;
				// 设置部分功能按钮不可见
				FlexGlobals.topLevelApplication.functionpanel.BtnCreateTable.enabled = false;
				//
				// 消去右侧玩家列表数据
				StateGetRoomPlayerlist.Instance.roomlist.removeAll();
				// 消去右边的聊天数据
				FlexGlobals.topLevelApplication.functionpanel.lobbychatbox.selectAll();
				FlexGlobals.topLevelApplication.functionpanel.lobbychatbox.insertText("");
				
				// 使当前所有的房间成为空（不在任何房间中）
				FlexGlobals.topLevelApplication.lobbypanel.setCurrentLobby(0);
				FlexGlobals.topLevelApplication.tolobby_clickHandler(null);
				
				if(LobyManager.Instance.state == 1){
					
				}
				else if(LobyManager.Instance.state == 5){
					StateJoinLoby.Instance.setLobyid(FlexGlobals.topLevelApplication.invitation.getDestLobbyId());
					var lid:int = FlexGlobals.topLevelApplication.invitation.getDestLobbyId();
					var node:XMLList = LobyManager.Instance.TreeData..*.(@lid == lid);
					StateJoinLoby.Instance.setLobyAddress(node.@address);
				}

				LobyNetManager.Instance.send(LobyNetManager.addloby);

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
		override public function fault(event:Event):void
		{
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}

	}
}