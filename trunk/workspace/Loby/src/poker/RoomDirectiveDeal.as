package poker
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;

	public class RoomDirectiveDeal
	{
		static private var instance:RoomDirectiveDeal=null;
		
		private var conn:LocalConnection;
		
		private var isGameOver:Boolean = false;
		
		static public function get Instance():RoomDirectiveDeal
		{
			if(instance  == null)
				instance = new RoomDirectiveDeal();
			return instance;
		}
		
		public function RoomDirectiveDeal()
		{
			conn = new LocalConnection();
			conn.client = this;
			conn.addEventListener(StatusEvent.STATUS, onStatus);
			try{
				conn.connect("THFlashGamePoker");
			}catch(error:ArgumentError)	{
				Alert.show("游戏注册链接失败","错误");
			}
		}
		
		public function onStatus(event:StatusEvent):void
		{
            switch (event.level) {
                case "status":
                    //Alert.show("LocalConnection.send() succeeded");
					GameObjectManager.Instance.shutdown();
					// 背景还是要保留
					GameObjectManager.Instance.setVisibleByName("BG", true);
					Game.Instance.gameState = 0;
                    break;
                case "error":
                    Alert.show("LocalConnection.send() failed", "error");
                    break;
            }

		}
		
		public function sendMessage():void
		{
			conn.send("THFlashGameLoby", "setGameOver", true);
		}
		
		public function getGameOver():Boolean
		{
			return isGameOver;
		}

		public function setGameOver(v:Boolean):void
		{
			isGameOver = v;
			//
			FlexGlobals.topLevelApplication.creationComplete();
		}
		
		public function setServerAddress(address:String):void
		{
			
		}
	}
}