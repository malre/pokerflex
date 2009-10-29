package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.NetManager;
	import poker.ResourceManagerPoker;

	public class StateUpdateWhileWait extends NetRequestState
	{
		private static var instance:StateUpdateWhileWait = null;

		public function StateUpdateWhileWait()
		{
			super();
		}
		public static function get Instance():StateUpdateWhileWait
		{
			if(instance == null)
				instance = new StateUpdateWhileWait();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.updater.url = NetManager.sendURL_game;
			NetManager.updater.request = {getPlayers:"true"};
			NetManager.updater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 链接成功，但游戏尚未开始
				if(obj.status == 1)
				{
					// 继续等待其他玩家
					Game.Instance.getSelfseat(obj);
					// 更新其他玩家的名字和状态
					Game.Instance.updatePlayerName(obj);
					Game.Instance.updatePlayerReadyState(obj);
				}
				else if(obj.status == 0)
				{
					// 进入游戏逻辑，先转到游戏之前的状态，来获得一帧牌的数据，然后再跳转到正式的游戏中
					NetManager.Instance.send(NetManager.send_updateWhileGameFirstframe);
					Game.Instance.gameState = 4;
					// 播放准备完成音效 
					ResourceManagerPoker.SoundStart.play();

					// 将准备按钮隐藏
					FlexGlobals.topLevelApplication.gamePoker.btnReady.visible = false;
				}
				else if(obj.status == 2)
				{
					Game.Instance.getSelfseat(obj);
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
			// 如果此次发送超时， 同样的内容将会被重发
			NetManager.Instance.send(NetManager.send_updateWhileWait);
		}
	}
}