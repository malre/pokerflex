package
{
	import flash.net.LocalConnection;

	// 用来接受游戏传回来的，游戏结束返回的消息
	// 使用Local Connection， 该类为客户端类
	public class LobyLocalConnReceiver
	{
		private var conn:LocalConnection;
		
		private var isGameOver:Boolean = false;
		
		public function LobyLocalConnReceiver()
		{
			conn = new LocalConnection();
			conn.client = this;
			try{
				conn.connect("THFlashGameLoby");
			}catch(error:ArgumentError)	{
				Alert.show("注册链接失败","错误");
			}
		}
		
		public function getGameOver():Boolean
		{
			return isGameOver;
		}

		public function setGameOver(v:Boolean):void
		{
			isGameOver = v;
		}

	}
}