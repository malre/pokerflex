package
{
	import flash.events.Event;
	
	import json.JSON;
	
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
		
		////////////////////////////////////////////////////////
		// 用来处理收到的json数据
 		public var json1:Object = new Object();
 		public var json2:Object = new Object();
		
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
			// 
			var str:String=null;
			json1 = JSON.decode(Application.application.httpService.lastResult.toString());

			if(send_type == send_joinRoom)
			{
				if(json1.success)
				{
					// 链接成功，开始等待玩家点击准备完成按钮
					// 进入等待状态
					send_type = send_waitForReady;
					Application.application.currentState = "Game";
					//Game.Instance.menuState = 1;
					Game.Instance.gameState = 3;	// 3 发送举手消息以前
					// 关闭几个和出牌有关的按钮的显示
					Application.application.btnSendCards.visible = false;
					Application.application.btnDiscard.visible = false;
					Application.application.btnHint.visible = false;
				}
				// 加入房间失败的情况下，显示失败的消息
				if(json1.hasOwnProperty("errors"))
				{
					if(json1.errors != null)
						str += json1.errors[0]+"\n";
				}
				if(json1.hasOwnProperty("players"))
				{
					str += json1.players[0];
				}
				Application.application.loginlog.text = "success="+json1.success+"\n"
														+"status="+json1.status+"\n"
														+str;
			}
			else if(send_type == send_waitForReady)
			{
				if(json1.success)
				{
					// 链接成功，进入游戏逻辑，开始进行update处理
					send_type = send_updateWhileGame;
					if(json1.status == 0)	// game start
						Application.application.currentState ="Game";
				}
				// text 
				if(json1.hasOwnProperty("errors"))
				{
					if(json1.errors != null)
						str += json1.errors[0]+"\n";
				}
				if(json1.hasOwnProperty("players"))
				{
					str += json1.players[0];
				}
				Application.application.loginlog.text = "success="+json1.success+"\n"
														+"status="+json1.status+"\n"
														+str;
			}
			else if(send_type == send_updateWhileGame)
			{
			}
		}

		public function failProcess(event:Event):void
		{
			if(send_type == send_joinRoom)
			{
				Application.application.loginlog.text = "connect failed. join room";
			}
			else if(send_type == send_waitForReady)
			{
				Application.application.loginlog.text = "connect failed. wait for ready";
			}
			else if(send_type == send_updateWhileGame)
			{
			}
		}
	}
}