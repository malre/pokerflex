package lobystate
{
	import mx.core.FlexGlobals;
	

	public class StateGetTableInfo extends NetRequestState
	{
		private static var instance:StateGetTableInfo = null;
		
		public function StateGetTableInfo()
		{
			super();
		}

		public static function get Instance():StateGetTableInfo
		{
			if(instance == null)
				instance = new StateGetTableInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
//			if(LobyManager.Instance.state == 1)
//			{
//				LobyNetManager.Instance.httpservice.url = FlexGlobals.topLevelApplication.gameTreeView.selectedItem.@address + LobyNetManager.URL_tableInfo;
//				LobyNetManager.Instance.httpservice.send();
//				// 设置lobysonaddress，该房间内的桌子请求都向这个地址发送
//				LobyNetManager.URL_lobysonAddress = FlexGlobals.topLevelApplication.gameTreeView.selectedItem.@address;
//			}
//			else
			{
				var tree:XML = LobyManager.Instance.TreeData;
				var node:XMLList = tree..*.(@lid == StateGetPlayerInfo.Instance.lastSuccData.player.lid);
				LobyNetManager.Instance.httpservice.url = node.@address + LobyNetManager.URL_tableInfo;
				LobyNetManager.Instance.httpservice.request = {};
				LobyNetManager.Instance.httpservice.send();
				// 设置lobysonaddress，该房间内的桌子请求都向这个地址发送
				LobyNetManager.URL_lobysonAddress = node.@address;
			}
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				LobyNetManager.Instance.tabledata = obj;
				LobyManager.Instance.getintoRoom(obj);
					// 设置自动加入桌子的按钮可见
				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = true;
				FlexGlobals.topLevelApplication.BtnCreateTable.visible = true;

				// 在大厅断线的恢复到大厅，在游戏断线的会在对房间玩家列表请求完成以后继续恢复
				if(LobyManager.Instance.state == 3)
				{
					LobyManager.Instance.changeState(1);	// normal
				}
				// 请求玩家列表
				LobyNetManager.Instance.send(LobyNetManager.getRoomPlayerlist);
				return true;
			}
			else{
				// 加入房间失败
				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = false;
				FlexGlobals.topLevelApplication.BtnCreateTable.visible = false;
				return false;
			}
		}
		override public function fault():void
		{
			
		}
	}
}