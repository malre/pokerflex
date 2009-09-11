package lobystate
{
	

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
				if(LobyManager.Instance.state == 3)
				{
					LobyManager.Instance.changeState(1);	// normal
				}
				if(LobyManager.Instance.state == 4)
				{
					// 继续进入游戏的请求
					//LobyManager.Instance.gamePoker.startup(obj);
					// 
					//LobyManager.Instance.changeState(2);
					//return true;
					LobyManager.Instance.changeState(1);
				}
				// 请求玩家列表
				LobyNetManager.Instance.send(LobyNetManager.getRoomPlayerlist);
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
			
		}
	}
}