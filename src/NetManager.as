package
{
	import flash.events.Event;
	
	import json.JSON;
	
	import mx.controls.Alert;
	import mx.core.Application;
	
	public class NetManager
	{
		//
		protected static var instance:NetManager = null;
		//定义了进行连接的服务器地址
		public var sendURL_serverIP:String = "http://192.168.18.199/web/world";
		public var sendURL_join:String = sendURL_serverIP+"/game/room/add";
		public var sendURL_requestinfo:String = sendURL_serverIP+"/game/index/identity";
		public var sendURL_leave:String = sendURL_serverIP+"/game/room/remove";
		public var sendURL_ready:String = sendURL_serverIP+"/game/room/start";
		public var sendURL_game:String = sendURL_serverIP+"/game/room/update";
		//传送的数据内容
		private var sendData:String = null;
		//
		private var netManager:NetManager=null;
		// 发送数据的格式
		public static var send_joinRoom:String = "join Room";
		public static var send_leave:String = "leave Room";
		public static var send_waitForReady:String = "wait For Ready";
		public static var send_updateWhileGame:String = "update While Game";
		public static var send_requestinfo:String = "request player info";
		public static var send_sendcardsWhileGame:String = "send cards";
		public static var send_passWhileGame:String = "pass";
		private var	send_type:String = null;
		
		// 请求连接标志位
		// 当本次请求发出以后，置为真，这期间，不再发起人和的请求，直到收到或者超时为止。
		private var requestEnable:Boolean = true;
		
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
		
		// 用来改变用来处理返回数据的方式
		public function setSendType(type:String):void
		{
			send_type = type;
		}

		public static function getSendData():String
		{
			//return sendData;
			return "1";
		}
		
		public function	send(type:String):void
		{
			// 对发送进行控制
			if(requestEnable)
				requestEnable = false;
			else
				return;
			//改变处理类型
			send_type = type;
				
			if(type == send_joinRoom)
			{
				Application.application.httpService.method = "POST";
				Application.application.httpService.request={roomid:Application.application.roomid.text};
				Application.application.httpService.url = NetManager.Instance.sendURL_join;
			}
			else if(type == send_leave)
			{
				Application.application.httpService.method = "GET";
				Application.application.httpService.request = {};
				Application.application.httpService.url = NetManager.Instance.sendURL_leave;
			}
			else if(type == send_requestinfo)
			{
				Application.application.httpService.method = "GET";
				Application.application.httpService.request = {};
				Application.application.httpService.url = NetManager.Instance.sendURL_requestinfo;
			}
			else if(type == send_waitForReady)
			{
				// 游戏状态变成 发送举手消息以后
				Game.Instance.gameState = 4;
				Application.application.httpService.method = "GET";
				Application.application.httpService.request = {};
				Application.application.httpService.url = NetManager.Instance.sendURL_ready;
			}
			else if(type == send_updateWhileGame)
			{
				Application.application.httpService.method = "GET";
				Application.application.httpService.request={};
				Application.application.httpService.url = NetManager.Instance.sendURL_game;
			}
			else if(type == send_sendcardsWhileGame)
			{
				Application.application.httpService.method = "POST";
				var arr:Array = GameObjectManager.Instance.getSelectedCards();
				var data:String = "";
				for(var id:int=0;id<arr.length;id++)
				{
					data += arr[id].toString();
					if(id != arr.length-1)
						data += ",";
				}
				
				Application.application.httpService.request={play:data};
				Application.application.httpService.url = NetManager.Instance.sendURL_game;
			}
			else if(type == send_passWhileGame)
			{
				Application.application.httpService.method = "POST";
				Application.application.httpService.request={play:"pass"};
				Application.application.httpService.url = NetManager.Instance.sendURL_game;
			}

			Application.application.httpService.send();
		}
		
		public function resultProcess(event:Event):void
		{
			requestEnable = true;
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
					Application.application.btnReady.visible = true;
					Application.application.btnSendCards.visible = false;
					Application.application.btnDiscard.visible = false;
					Application.application.btnHint.visible = false;
					Application.application.labelWait.visible = false;
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
			else if(send_type == send_leave)
			{
			}
			else if(send_type == send_requestinfo)
			{
				if(json1.success)
				{
					Game.Instance.pid = json1.pid;
					//trace("pid = "+json1.pid+"\n");
					//Alert.show("pid="+json1.pid, "success");
					// 继续请求进入房间
					NetManager.Instance.send(NetManager.send_joinRoom);
				}
				else
				{
					Alert.show("pid="+json1.pid, "fail");
				}
			}
			else if(send_type == send_waitForReady)
			{
				if(json1.success)
				{
					// 链接成功，
					if(json1.status == 1)
					{
						// 继续等待其他玩家
						send_type = send_updateWhileGame;
						Game.Instance.gameState = 4;
						// 将准备按钮的文字修改
						Application.application.btnReady.enabled = false;
						Application.application.labelWait.visible = true;
					}
					else if(json1.status == 0)
					{
						// 进入游戏逻辑，开始进行update处理
						send_type = send_updateWhileGame;
						Game.Instance.gameState = 2;
						//Game.Instance.gameStart();
						// 将准备按钮隐藏
						Application.application.btnReady.visible = false;
					}
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
				//	更新所有的游戏信息
				if(json1.success)
				{
					// 等待游戏开始状态
					if(Game.Instance.gameState == 4)
					{
						// 链接成功，
						if(json1.status == 1)
						{
							// 继续等待其他玩家
						}
						else if(json1.status == 0)
						{
							// 进入游戏逻辑，开始进行update处理
							Game.Instance.gameState = 2;
							//Game.Instance.gameStart();
							// 将准备按钮隐藏
							Application.application.btnReady.visible = false;
							Application.application.labelWait.visible = false;
						}
					}
					// 游戏中
					else if(Game.Instance.gameState == 2)
					{
						// 如果游戏意外结束，退回到开始界面
						if(json1.status == 0)
						{
							// 更新所有玩家的信息
							if(json1.play != null)
							{
//								Game.Instance.curPlayer = json1.play.next;
//								Game.Instance.drawPlayerCards(null);
//								Game.Instance.drawOtherCards(json1.play.history);
//								Game.Instance.updatePlayerInfo();
//								//
								if(Game.Instance.selfseat == NetManager.Instance.json1.play.next)
								{
									//Game.Instance.isSendDirective = false;
								}
							}
						}
						else if(json1.status == 1)
						{
							Alert.show("游戏意外结束，重新开始","");
							GameObjectManager.Instance.shutdown();
							Application.application.currentState = "MainMenu";
						}
					}

				}
				else
				{
					if(json1.hasOwnProperty("errors"))
					{
						if(json1.errors != null)
							str += json1.errors[0]+"\n";
					}
					Alert.show(str, "");
				}
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