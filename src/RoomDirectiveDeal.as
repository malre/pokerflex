package
{
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	
	import mx.controls.Alert;

	public class RoomDirectiveDeal
	{
		private var instance:RoomDirectiveDeal=null;
		
		private var conn:LocalConnection;
		
		public function get Instance():RoomDirectiveDeal
		{
			if(instance == null)
				instance = new RoomDirectiveDeal();
			return instance;
		}
		
		public function RoomDirectiveDeal()
		{
			conn = new LocalConnection();
			conn.addEventListener(StatusEvent.STATUS, onStatus);
		}
		
		public function onStatus(event:StatusEvent):void
		{
            switch (event.level) {
                case "status":
                    //Alert.show("LocalConnection.send() succeeded");
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
	}
}