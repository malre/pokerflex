package lobystate
{
	import mx.core.FlexGlobals;
	
	import poker.Game;

	public class StateGetPlayerInfo extends NetRequestState
	{
		private static var instance:StateGetPlayerInfo = null;
		// construct
		public function StateGetPlayerInfo()
		{
			super();
		}
		
		public static function get Instance():StateGetPlayerInfo
		{
			if(instance == null)
				instance = new StateGetPlayerInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobyAddress + LobyNetManager.URL_playerInfo;
			LobyNetManager.Instance.httpservice.send();
			//request_playerinfo = true;
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 设置玩家的信息
				FlexGlobals.topLevelApplication.imgAvatar.source = obj.player.avatar;
				FlexGlobals.topLevelApplication.imgAvatar.scaleX = 0.7;
				FlexGlobals.topLevelApplication.imgAvatar.scaleY = 0.7;
				FlexGlobals.topLevelApplication.textPlayname.text = obj.player.name;
				//
				LobyManager.Instance.state = 1;	// goto normal
				//
				Game.Instance.pid = obj.player.pid;
				// 给恢复用的备用变量赋值
				LobyManager.Instance.playerInfo = obj;
				// 对玩家信息进行分析，看玩家上次是否是意外离开，需不需要恢复
				if(obj.player.lid != "null")
				{
					LobyManager.Instance.changeState(3);	// resotre
					if(obj.player.rid != "null")
					{
						 LobyManager.Instance.changeState(4);	// resotre
					}
					// 发出房间信息的请求
					LobyNetManager.Instance.send(LobyNetManager.tableInfo);
				}
				return true;
			}
			else{
				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				return false;
			}
		}

	}
}