package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.NetManager;
	
	public class StateLeaveTable extends NetRequestState
	{
		private static var instance:StateLeaveTable = null;

		public function StateLeaveTable()
		{
			super();
		}

		public static function get Instance():StateLeaveTable
		{
			if(instance == null)
				instance = new StateLeaveTable();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_leave;
			NetManager.sender.request = {};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
    			// 使游戏本体不见，并回到游戏房间，刷新房间
    			LobyManager.Instance.gamePoker.endup();
    			// 回到游戏
    			LobyManager.Instance.changeState(1);
    			// 退出的时候同时清除房间的聊天信息
    			LobyManager.Instance.gamePoker.showboxGame.clearContent();
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault():void
		{
			NetManager.Instance.send(NetManager.send_leave);
		}
	}
}