package lobystate
{
	import message.Messenger;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;

	public class StateGetPlayerInfo extends NetRequestState
	{
		// player avatar middle type
		public var playerMiddleAvatar:String = "";
		// 0 ：登录用， 1：用户请求用
		private var type:int = 0;
		
		private static var instance:StateGetPlayerInfo = null;
		// construct
		public function StateGetPlayerInfo()
		{
			super();
		}
		
		public function setType(value:int):void
		{
			type = value;
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
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("获得玩家个人信息中……");
			
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobyAddress + LobyNetManager.URL_playerInfo;
			LobyNetManager.Instance.httpservice.request = {}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				if(type == 0)
				{
					//http://uc.zj.chinamobile.com/avatar.php?uid=910&size=small&type=virtual
					var reg:RegExp = /size=small/;
					playerMiddleAvatar = lastSuccData.player.avatar.replace(reg, "size=middle");
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
					// 因为开始系统消息的获得只要一次，所以放在这里执行
					Messenger.Instance.startSystem();
					Messenger.Instance.startShout();
					// 对玩家信息进行分析，看玩家上次是否是意外离开，需不需要恢复
					if(obj.player.lid != "null")
					{
						// 设置左边的玩家所在房间位置的提示信息
						FlexGlobals.topLevelApplication.customcomponent21.setCurrentLobby(int(obj.player.lid));
	
						LobyManager.Instance.changeState(3);	// resotre
						if(obj.player.rid != "null")
						{
							 LobyManager.Instance.changeState(4);	// resotre
						}
						// 发出房间信息的请求
						LobyNetManager.Instance.send(LobyNetManager.tableInfo);
					}
				}
				else if(type == 1){
					FlexGlobals.topLevelApplication.playerinfo.visible = true;
					FlexGlobals.topLevelApplication.playerinfo.currentState="StateMain";
				}

				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				LobyManager.Instance.windowMutex = false;

				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
		}
		override public function fault():void
		{
			LobyManager.Instance.windowMutex = false;
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}

	}
}