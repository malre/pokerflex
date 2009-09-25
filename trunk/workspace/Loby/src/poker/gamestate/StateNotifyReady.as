package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import poker.Game;
	import poker.NetManager;
	
	public class StateNotifyReady extends NetRequestState
	{
		private static var instance:StateNotifyReady = null;
		
		public function StateNotifyReady()
		{
			super();
		}
		public static function get Instance():StateNotifyReady
		{
			if(instance == null)
				instance = new StateNotifyReady();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_ready;
			NetManager.sender.request = {getPlayers:"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				if(obj.status == 0)
				{
					// 进入游戏逻辑，先转到游戏之前的状态，来获得一帧牌的数据，然后再跳转到正式的游戏中
					NetManager.Instance.send(NetManager.send_updateWhileGameFirstframe);
					Game.Instance.gameState = 4;
					// 提示文字
					LobyManager.Instance.gamePoker.labelWait.visible = false;
				}
				// 将准备按钮隐藏
				LobyManager.Instance.gamePoker.btnReady.visible = false;
				
				return true;
			}
			else{
				// if false
				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				return false;
			}
			
		}
		override public function fault():void
		{
			//重发准备完成消息
			NetManager.Instance.send(NetManager.send_iamReady);
		}
	}
}