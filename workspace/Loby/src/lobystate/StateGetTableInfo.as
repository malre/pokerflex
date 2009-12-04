package lobystate
{
	import mx.core.FlexGlobals;

	public class StateGetTableInfo extends NetRequestState
	{
		private static var instance:StateGetTableInfo = null;
		
		// 用来记录玩家当前所在的大厅的游戏类型编号
		public var gameRoomGid:int;
		
		private var nPage:int;
		
		public function StateGetTableInfo()
		{
			super();
			nPage = 0;
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
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("获得大厅内游戏桌信息中……");

			var tree:XML = LobyManager.Instance.TreeData;
			var node:XMLList = tree..*.(@lid == StateGetPlayerInfo.Instance.lastSuccData.player.lid);
			LobyNetManager.Instance.httpservice.url = node.@address + LobyNetManager.URL_tableInfo;
			// 第一次的时候默认会请求page 第一页的内容
			LobyNetManager.Instance.httpservice.request = {"page":nPage};
			LobyNetManager.Instance.httpservice.send();
			// 设置lobysonaddress，该房间内的桌子请求都向这个地址发送
			LobyNetManager.URL_lobysonAddress = node.@address;
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 如果这个页面有游戏桌存在的话
				if(obj.length > 0)
					gameRoomGid = obj[0].gid;
				//
				LobyNetManager.Instance.tabledata = obj;
				LobyManager.Instance.getintoRoom(obj);
					// 设置自动加入桌子的按钮可见
				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = true;
				FlexGlobals.topLevelApplication.lobbyroomtag.visible = true;
					// 创建房间需要判断
				if(StateUpdateRoomInfo.Instance.isCreateTableEnable())
					FlexGlobals.topLevelApplication.BtnCreateTable.visible = true;
				else
					FlexGlobals.topLevelApplication.BtnCreateTable.visible = false;

				// 在大厅断线的恢复到大厅，在游戏断线的会在对房间玩家列表请求完成以后继续恢复
				if(LobyManager.Instance.state == 3)
				{
					LobyManager.Instance.changeState(1);	// normal
				}
				else if(LobyManager.Instance.state == 4){
					// 对玩家所在房间的号码进行赋值
					for(var i:int=0;i<obj.length;i++){
						if(obj[i].rid == StateGetPlayerInfo.Instance.lastSuccData.player.rid){
							StateLobyJoinTable.Instance.setTablename(obj[i].name);
							break;
						}
					}
				}
				// 请求玩家列表
				LobyNetManager.Instance.send(LobyNetManager.getRoomPlayerlist);
				// 当成功请求了一次游戏桌数据之后，将得到的值赋值给更新部分StateUpdateRoomTable
				StateUpdateRoomTable.Instance.setPage(nPage);

				// 关闭进行过程
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				// 加入房间失败
				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = false;
				FlexGlobals.topLevelApplication.BtnCreateTable.visible = false;

				// 关闭进行过程
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
		}
		override public function fault():void
		{
			// 关闭进行过程
			LobyNetManager.Instance.closeNetProcess();
		}
		
		public function setPage(val:int):void
		{
			nPage = val;
		}
	}
}