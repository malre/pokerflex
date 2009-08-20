package
{
	import flash.net.LocalConnection;
	
	import mx.controls.Alert;

	// 用来接受游戏传回来的，游戏结束返回的消息
	// 使用Local Connection， 该类为客户端类
	public class LobyLocalConnReceiver
	{
		// instance
		private static var instance:LobyLocalConnReceiver = null;
		
		private var conn:LocalConnection;
		
		private var isGameOver:Boolean = false;
		
		public static function get Instance():LobyLocalConnReceiver
		{
			if(instance == null)
				instance = new LobyLocalConnReceiver();
			return instance;
		}
		
		public function LobyLocalConnReceiver()
		{
			conn = new LocalConnection();
			conn.client = this;
			conn.allowDomain('*');
			try{
				conn.connect("THFlashGameLoby");
			}catch(error:ArgumentError)	{
				Alert.show("大厅注册链接失败","错误");
			}
		}
		public function notifyGameStart():void
		{
			conn.send("THFlashGamePoker", "setGameOver", true);
		}
		
		public function getGameOver():Boolean
		{
			return isGameOver;
		}

		public function setGameOver(v:Boolean):void
		{
			isGameOver = v;
			// debug
			LobyManager.Instance.closeGame();
		}

	}
}