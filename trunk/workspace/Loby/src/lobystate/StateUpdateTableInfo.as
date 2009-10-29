package lobystate
{
	import mx.core.FlexGlobals;

	/**
	 * 用来给玩家恢复游戏用
	 * 如果玩家连接时处在游戏中，那么就去对这张桌子进行请求，获得玩家在该桌子上的信息 
	 * @author Eric
	 * 
	 */	
	
	public class StateUpdateTableInfo extends NetRequestState
	{
		private static var instance:StateUpdateTableInfo = null;

		public function StateUpdateTableInfo()
		{
			super();
		}

		public static function get Instance():StateUpdateTableInfo
		{
			if(instance == null)
				instance = new StateUpdateTableInfo();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_updateTableInfo;
			LobyNetManager.Instance.httpservice.request = {"getPlayers":"true","update":"0"};
			LobyNetManager.Instance.httpservice.send();
		}

		/**
		 * 收到该房间的消息 ，对房间状态进行判断，如果是未开始状态，那么进入等待准备状态
		 * 反之直接进入游戏
		 * @param obj
		 * @return 
		 * 
		 */
		override public function receive(obj:Object):Boolean
		{
			
			if(super.receive(obj))
			{
				// 正常游戏中
				if(obj.status == 0)
				{
					// 先进入游戏
					FlexGlobals.topLevelApplication.gamePoker.startup(obj);
					FlexGlobals.topLevelApplication.changeState(2);
					// 将准备按钮隐藏
					FlexGlobals.topLevelApplication.gamePoker.btnReady.visible = false;
					// 然后恢复到当前的游戏状态
					
				}
				// 游戏尚未开始
				// 
				else if(obj.status == 1)
				{
					FlexGlobals.topLevelApplication.gamePoker.startup(obj);
					// 
					LobyManager.Instance.changeState(2);
				}
				return true;
			}
			else{
				return false;
			}
		}

		override public function fault():void
		{
//			NetManager.Instance.update(NetManager.send_updateWhileGame);
		}
	}
}