package lobystate
{
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
				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = false;
				FlexGlobals.topLevelApplication.lobbyroomtag.visible = false;
				FlexGlobals.topLevelApplication.BtnCreateTable.visible = false;
				//
				// 不显示右边的信息和聊天面板
				FlexGlobals.topLevelApplication.customcomponent31.currentState='State2';
				// 打开说明文字
				FlexGlobals.topLevelApplication.introduceText.visible = true;
				// 除去游戏桌的描画
				FlexGlobals.topLevelApplication.gameRoomCanvas.removeAllChildren();
				// 消去右侧玩家列表数据
				StateGetRoomPlayerlist.Instance.roomlist.removeAll();
				// 消去右边的聊天数据
				FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox.selectAll();
				FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox.insertText("");
				
				// 使当前所有的房间成为空（不在任何房间中）
				FlexGlobals.topLevelApplication.customcomponent21.setCurrentLobby(0);
				
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
		override public function fault():void
		{
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}

	}
}