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
		public static var send_iamReady:String = "i am ready";
		public static var send_updateWhileWait:String = "update While Wait";
		public static var send_updateWhileGame:String = "update While Game";
		public static var send_requestinfo:String = "request player info";
		public static var send_sendcardsWhileGame:String = "send cards";
		public static var send_passWhileGame:String = "pass";
		private var	send_type:String = null;
		// 记录了本次请求的内容, 请求的内容一般属于下面的几类
		public var request_type_cards:Boolean = false;
		public var request_type_play:Boolean = false;
		public var request_type_players:Boolean = false;
		
		// 请求连接标志位
		// 当本次请求发出以后，置为真，这期间，不再发起人和的请求，直到收到或者超时为止。
		public var requestEnable:Boolean = true;
		public var requestSuccess:Boolean = false;
		
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
			//重置所有的请求标志位
			request_type_cards = false;
			request_type_play = false;
			request_type_players = false;
			//改变处理类型
			send_type = type;
				
			if(type == send_joinRoom)
			{
				Application.application.httpService.request={roomid:Application.application.roomid.text, getPlayers:"true"};
				Application.application.httpService.url = sendURL_join;
				//置上请求内容的标志位
				request_type_players = true;
			}
			else if(type == send_leave)
			{
				Application.application.httpService.request = {};
				Application.application.httpService.url = sendURL_leave;
			}
			else if(type == send_requestinfo)
			{
				Application.application.httpService.request = {};
				Application.application.httpService.url = sendURL_requestinfo;
			}
			else if(type == send_iamReady)
			{
				// 游戏状态变成 发送举手消息以后
				//Game.Instance.gameState = 4;
				Application.application.httpService.request = {getPlayers:"true"};
				Application.application.httpService.url = sendURL_ready;
				//置上请求内容的标志位
				request_type_players = true;
			}
			else if(type == send_updateWhileWait)
			{
				Application.application.httpService.request = {getPlayers:"true"};
				Application.application.httpService.url = sendURL_game;
				//置上请求内容的标志位
				request_type_players = true;
			}
			else if(type == send_updateWhileGame)
			{
				Application.application.httpService.request = {getPlay:"true",getCards:"true"};
				Application.application.httpService.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
			}
			else if(type == send_sendcardsWhileGame)
			{
				var arr:Array = GameObjectManager.Instance.getSelectedCards();
				var data:String = "";
				for(var id:int=0;id<arr.length;id++)
				{
					data += arr[id].toString();
					if(id != arr.length-1)
						data += ",";
				}
				
				Application.application.httpService.request={play:data, getPlay:"true", getCards:"true"};
				Application.application.httpService.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
			}
			else if(type == send_passWhileGame)
			{
				Application.application.httpService.request={play:"pass", getPlay:"true", getCards:"true"};
				Application.application.httpService.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
			}

			Application.application.httpService.send();
		}
		
		public function resultProcess(event:Event):void
		{
			// 本次的请求到达，可以进行下一次请求
			requestEnable = true;
			requestSuccess = false;
			// 
			var str:String=null;
			json1 = null;
			json1 = JSON.decode(Application.application.httpService.lastResult.toString());
			
			// 首先分析数据，本次请求成功还是失败,当数据没有发生变动的时候，返回是“null”,暂时未对应
			// 然后看是否得到了预期的数据
			if(json1.hasOwnProperty("success"))
			{
				if(!json1.success)
				{
					requestSuccess = false;
					Alert.show(json1.errors[0], "错误");
 					return;
				}
			}
			else
			{
				// fault 处理
			}
			if(request_type_players)
			{
				if(!json1.hasOwnProperty("players"))
				{
					requestSuccess = false;
					Alert.show("没有得到预期的players数据", "错误");
					return;
				}
			}
			if(request_type_play)
			{
				if(!json1.hasOwnProperty("play"))
				{
					requestSuccess = false;
					Alert.show("没有得到预期的play数据", "错误");
					return;
				}
			}
			if(request_type_cards)
			{
				if(!json1.hasOwnProperty("cards"))
				{
					requestSuccess = false;
					Alert.show("没有得到预期的cards数据", "错误");
					return;
				}
			}
			
			// 通过了以上的验证，说明本次的请求是成功的，至于返回的数据是否成功，需要判断 
			requestSuccess = true;
			
			if(send_type == send_joinRoom)
			{
				if(json1.success)
				{
					// 链接成功，开始等待玩家点击准备完成按钮
					// 进入等待状态
					send_type = send_updateWhileWait;
					Application.application.currentState = "Game";
					Game.Instance.gameState = 3;	// 3 发送举手消息以前
					// 关闭几个和出牌有关的按钮的显示
					Application.application.btnReady.visible = true;
					Application.application.btnReady.enabled = true;
					Application.application.btnSendCards.visible = false;
					Application.application.btnDiscard.visible = false;
					Application.application.btnHint.visible = false;
					// “等待其他玩家” 该信息不显示
					Application.application.labelWait.visible = false;
					// 
					requestSuccess = true;
				}
			}
			else if(send_type == send_leave)
			{
			}
			else if(send_type == send_requestinfo)
			{
				if(json1.success)
				{
					Game.Instance.pid = json1.pid;

					// 继续请求进入房间
					requestEnable = true;
					send(send_joinRoom);
				}
				else
				{
					Alert.show("pid="+json1.pid, "fail");
				}
			}
			else if(send_type == send_iamReady)
			{
				// 发送“我准备好了”的消息以后
				if(json1.success)
				{
					// 将准备按钮的文字修改
					Application.application.btnReady.enabled = false;
					Application.application.labelWait.visible = true;
				}
			}
			else if(send_type == send_updateWhileWait)
			{
				if(json1.success)
				{
					// 链接成功，但游戏尚未开始
					if(json1.status == 1)
					{
						// 继续等待其他玩家
						//send_type = send_updateWhileGame;
						//Game.Instance.gameState = 4;
						Game.Instance.getSelfseat();
					}
					else if(json1.status == 0)
					{
						// 进入游戏逻辑，先转到游戏之前的状态，来获得一帧牌的数据，然后再跳转到正式的游戏中
						requestEnable = true;
						send(send_updateWhileGame);
						Game.Instance.gameState = 4;
						Game.Instance.getSelfseat();

						// 将准备按钮隐藏
						Application.application.btnReady.visible = false;
						Application.application.labelWait.visible = false;
					}
				}
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
							if(json1.play.next == Game.Instance.selfseat)
							{
								// 显示所有的按钮
								Application.application.btnSendCards.visible = true;
								Application.application.btnSendCards.enabled = false;
								Application.application.btnDiscard.visible = true;
								Application.application.btnDiscard.enabled = true;
								Application.application.btnHint.visible = true;
								if(json1.play.last == json1.play.next)
								{
									Application.application.btnDiscard.enabled = false;
								}
							}
						}
					}
					// 游戏中
					else if(Game.Instance.gameState == 2)
					{
						if(json1.status == 0)
						{
							// 判断是否到了玩家的出牌回合
							if(json1.play.next == Game.Instance.selfseat)
							{
								// 显示所有的按钮
								Application.application.btnSendCards.visible = true;
								Application.application.btnSendCards.enabled = false;
								Application.application.btnDiscard.visible = true;
								Application.application.btnDiscard.enabled = true;
								Application.application.btnHint.visible = true;
								if(json1.play.last == json1.play.next)
								{
									Application.application.btnDiscard.enabled = false;
								}
							}
							// 对游戏正常结束的判断。
						}
						// 如果游戏意外结束，退回到开始界面
						else if(json1.status == 1)
						{
							Alert.show("游戏意外结束，重新开始","有玩家推出了房间");
//							GameObjectManager.Instance.shutdown();
//							Application.application.currentState = "MainMenu";
						}
						// 游戏胜利
						else if(json1.status == 2)
						{
							GameObjectManager.Instance.shutdown();
							// 背景还是要保留
							GameObjectManager.Instance.setVisibleByName("BG", true);
							Game.Instance.gameState = 5;
							Application.application.showPopupDlg();
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
			requestEnable = true;
			Alert.show("接收消息失败", "错误");
			if(send_type == send_joinRoom)
			{
				Application.application.loginlog.text = "connect failed. join room";
			}
			else if(send_type == send_iamReady)
			{
				Application.application.loginlog.text = "connect failed. wait for ready";
			}
			else if(send_type == send_updateWhileWait)
			{
				
			}
			else if(send_type == send_updateWhileGame)
			{
			}
		}
	}
}