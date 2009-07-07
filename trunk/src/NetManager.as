package
{
	import flash.events.Event;
	
	import mx.core.Application;
	
	public class NetManager
	{
		//
		protected static var instance:NetManager = null;
		//定义了进行连接的服务器地址
		public var sendURL_serverIP:String = "http://192.168.18.24/web/world";
		public var sendURL_join:String = sendURL_serverIP+"/game/room/add";
		public var sendURL_ready:String = sendURL_serverIP+"/game/room/start";
		public var sendURL_game:String = sendURL_serverIP+"/game/room/update";
		//传送的数据内容
		private var sendData:String = null;
		//
		private var netManager:NetManager=null;
		// 发送数据的格式
		public static var send_joinRoom:String = "join Room";
		public static var send_waitForReady:String = "wait For Ready";
		public static var send_updateWhileGame:String = "update While Game";
		private var	send_type:String = null;
		
		public function NetManager()
		{
		}
		
		public static function get Instance():NetManager
		{
			if(instance)
				return instance;
			else
				return instance = new NetManager();
		}

		public static function getSendData():String
		{
			//return sendData;
			return "1";
		}
		
		public function	send(type:String):void
		{
			send_type = type;
			if(type == send_joinRoom)
			{
				Application.application.httpService.request={roomid:"1"};
				Application.application.httpService.url = NetManager.Instance.sendURL_join;
			}
			else if(type == send_waitForReady)
			{
//				Application.application.httpService.request={roomid:"1"};
				Application.application.httpService.url = NetManager.Instance.sendURL_ready;
			}
			else if(type == send_updateWhileGame)
			{
				//Application.application.httpService.request={play:"1"};
				Application.application.httpService.url = NetManager.Instance.sendURL_game;
			}

			Application.application.httpService.send();
		}
		
		public function resultProcess(event:Event):void
		{
			if(send_type == send_joinRoom)
			{
				Application.application.loginlog.text = "";
			}
			else if(send_type == send_waitForReady)
			{
			}
			else if(send_type == send_updateWhileGame)
			{
			}
		}

		public function failProcess(event:Event):void
		{
			if(send_type == send_joinRoom)
			{
			}
			else if(send_type == send_waitForReady)
			{
			}
			else if(send_type == send_updateWhileGame)
			{
			}
		}
	}
}