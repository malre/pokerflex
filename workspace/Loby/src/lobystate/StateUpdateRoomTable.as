package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	public class StateUpdateRoomTable extends NetRequestState
	{
		private static var instance:StateUpdateRoomTable = null;
		
		private var nPage:int;
		
		public function StateUpdateRoomTable()
		{
			super();
			nPage = 0;
		}
		
		public static function get Instance():StateUpdateRoomTable
		{
			if(instance == null)
				instance = new StateUpdateRoomTable();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			// 显示进行过程
//			LobyNetManager.Instance.showNetProcess("获得大厅内游戏桌信息中……");
			
			var tree:XML = LobyManager.Instance.TreeData;
			var node:XMLList = tree..*.(@lid == StateGetPlayerInfo.Instance.lastSuccData.player.lid);
			LobyNetManager.Instance.lobbyUpdater.url = node.@address + LobyNetManager.URL_tableInfo;
			// 第一次的时候默认会请求page 第一页的内容
			LobyNetManager.Instance.lobbyUpdater.request = {"page":nPage};
			LobyNetManager.Instance.lobbyUpdater.send();
			// 设置lobysonaddress，该房间内的桌子请求都向这个地址发送
			LobyNetManager.URL_lobysonAddress = node.@address;
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				//
				LobyNetManager.Instance.tabledata = obj;
				LobyManager.Instance.refreshRoom(obj);
				// 创建房间需要判断
				if(StateUpdateRoomInfo.Instance.isCreateTableEnable())
					FlexGlobals.topLevelApplication.functionpanel.BtnCreateTable.enabled = true;
				else
					FlexGlobals.topLevelApplication.functionpanel.BtnCreateTable.enabled = false;
				
				// 在大厅断线的恢复到大厅，在游戏断线的会在对房间玩家列表请求完成以后继续恢复
				if(LobyManager.Instance.state == 3)
				{
					LobyManager.Instance.changeState(1);	// normal
				}
				else if(LobyManager.Instance.state == 4){
//					// 对玩家所在房间的号码进行赋值
//					for(var i:int=0;i<obj.length;i++){
//						if(obj[i].rid == StateGetPlayerInfo.Instance.lastSuccData.player.rid){
//							StateLobyJoinTable.Instance.setTablename(obj[i].name);
//							break;
//						}
//					}
				}
				// 请求玩家列表
				LobyNetManager.Instance.update(LobyNetManager.updateRoomplayerlist);
				
				// 关闭进行过程
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				// 加入房间失败
//				FlexGlobals.topLevelApplication.BtnAutojoinTable.visible = false;
				FlexGlobals.topLevelApplication.functionpanel.BtnCreateTable.enabled = false;
				
				// 关闭进行过程
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			// 关闭进行过程
//			LobyNetManager.Instance.closeNetProcess();
		}
		
		public function setPage(val:int):void
		{
			nPage = val;
		}
	}
}