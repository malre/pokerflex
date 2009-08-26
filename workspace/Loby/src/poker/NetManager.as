package poker
{
	import flash.events.Event;
	
	import json.JSON;
	
	import lobystate.StateManager;
	
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import poker.gamestate.StateNotifyReady;
	import poker.gamestate.StateUpdateWhileWait;
	import poker.gamestate.StateUpdateWhileGame;
	
	public class NetManager
	{
		//
		protected static var instance:NetManager = null;
		//定义了进行连接的服务器地址
		public static const sendURL_serverIP:String = LobyNetManager.URL_lobyAddress;
		public static const sendURL_join:String = sendURL_serverIP+"/game/room/add";
		public static const sendURL_requestinfo:String = sendURL_serverIP+"/game/index/identity";
		public static const sendURL_leave:String = sendURL_serverIP+"/game/room/remove";
		public static const sendURL_ready:String = sendURL_serverIP+"/game/room/start";
		public static const sendURL_notready:String = sendURL_serverIP+"";
		public static const sendURL_game:String = sendURL_serverIP+"/game/room/update";
		//传送的数据内容
		private var sendData:String = null;
		//
		private var netManager:NetManager=null;
		// 发送数据的格式
		public static var send_joinRoom:String = "join Room";
		public static var send_leave:String = "leave Room";
		public static var send_iamReady:String = "i am ready";
		public static var send_cancelReady:String = "not ready";
		public static var send_updateWhileWait:String = "update While Wait";
		public static var send_updateWhileGame:String = "update While Game";
		public static var send_updateWhileGameFirstframe:String = "for getting cards";
		public static var send_requestinfo:String = "request player info";
		public static var send_sendcardsWhileGame:String = "send cards";
		public static var send_passWhileGame:String = "pass";
		public static var send_viewCardsHistory:String = "view card history";
		private var	send_type:String = null;
		// 记录了本次请求的内容, 请求的内容一般属于下面的几类
		public var request_type_cards:Boolean = false;
		public var request_type_play:Boolean = false;
		public var request_type_players:Boolean = false;
		public var request_type_history:Boolean = false;
		
		// 请求连接标志位
		// 当本次请求发出以后，置为真，这期间，不再发起人和的请求，直到收到或者超时为止。
		public var requestEnable:Boolean = true;
		public var requestSuccess:Boolean = false;
		
		static public var updater:HTTPService = new HTTPService();
		static public var sender:HTTPService = new HTTPService();
		private var updaterStateManager:StateManager = new StateManager();
		private var senderStateManager:StateManager = new StateManager();

		////////////////////////////////////////////////////////
		// 用来处理收到的json数据
 		public var json1:Object = new Object();
 		public var json2:Object = new Object();
		
		public function NetManager()
		{
			updater.method = "GET";
			updater.requestTimeout = 3;
			updater.showBusyCursor = false;
			updater.addEventListener(ResultEvent.RESULT, updateResultProcess);
			updater.addEventListener(FaultEvent.FAULT, updateFailProcess);
			
			sender.method = "POST";
			sender.requestTimeout = 3;
			sender.showBusyCursor = true;
			sender.addEventListener(ResultEvent.RESULT, sendResultProcess);
			sender.addEventListener(FaultEvent.FAULT, sendFailProcess);
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
			request_type_history = false;
			//改变处理类型
			send_type = type;
				
			if(type == send_joinRoom)
			{
				//LobyNetManager.Instance.httpservice.request={roomid:LobyManager.Instance.gamePoker.roomid.text, getPlayers:"true"};
				//LobyNetManager.Instance.httpservice.url = sendURL_join;
				//置上请求内容的标志位
				request_type_players = true;
			}
			else if(type == send_leave)
			{
				LobyNetManager.Instance.httpservice.request = {};
				LobyNetManager.Instance.httpservice.url = sendURL_leave;
			}
			else if(type == send_requestinfo)
			{
				LobyNetManager.Instance.httpservice.request = {};
				LobyNetManager.Instance.httpservice.url = sendURL_requestinfo;
			}
			else if(type == send_iamReady)
			{
				// 游戏状态变成 发送举手消息以后
				senderStateManager.changeState(StateNotifyReady.Instance);
				sender.send();
			}
			else if(type == send_updateWhileWait)
			{
				updaterStateManager.changeState(StateUpdateWhileWait.Instance);
				updater.send();
			}
			else if(type == send_updateWhileGame)
			{
				updaterStateManager.changeState(StateUpdateWhileGame.Instance);
				updater.send();
			}
			else if(type == send_updateWhileGameFirstframe)
			{
				LobyNetManager.Instance.httpservice.request = {getPlay:"true",getCards:"true",update:"0.0"};
				LobyNetManager.Instance.httpservice.url = sendURL_game;
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
				
				LobyNetManager.Instance.httpservice.request={play:data, getPlay:"true", getCards:"true"};
				LobyNetManager.Instance.httpservice.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
			}
			else if(type == send_passWhileGame)
			{
				LobyNetManager.Instance.httpservice.request={play:"pass", getPlay:"true", getCards:"true"};
				LobyNetManager.Instance.httpservice.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
			}
			else if(type == send_viewCardsHistory)
			{
				LobyNetManager.Instance.httpservice.request={getPlay:"true", getCards:"true", getHistory:"true"};
				LobyNetManager.Instance.httpservice.url = sendURL_game;
				//置上请求内容的标志位
				request_type_play = true;
				request_type_cards = true;
				request_type_history = true;
			}

		}
		
		public function updateResultProcess(event:Event):void
		{
			// 本次的请求到达，可以进行下一次请求
			requestEnable = true;
			requestSuccess = false;
			// 
			var str:String=null;
			
			// 当数据没有发生变动的时候，返回是“null”
			// 这个时候不做任何的更新，直接返回
			if(updater.lastResult.toString() == "null")
			{
				return;
			}
			
			//json1 = null;
				try{
					json1 = JSON.decode(updater.lastResult.toString());
	 			}catch(error:ArgumentError){
	 				trace("json decode error");
	 			}
			updaterStateManager.receive(json1);
			// 首先分析数据，本次请求成功还是失败,
			// 然后看是否得到了预期的数据
			if(json1.hasOwnProperty("success"))
			{
				if(!json1.success)
				{
					requestSuccess = false;
					//Alert.show(json1.error.message, "错误");
					trace(json1.error.message);
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
			if(request_type_history)
			{
				if(!json1.hasOwnProperty("history"))
				{
					requestSuccess = false;
					Alert.show("没有得到预期的History数据", "错误");
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
					//LobyManager.Instance.gamePoker.currentState = "Game";
					Game.Instance.gameState = 3;	// 3 发送举手消息以前
					// 关闭几个和出牌有关的按钮的显示
					LobyManager.Instance.gamePoker.btnReady.visible = true;
					LobyManager.Instance.gamePoker.btnReady.enabled = true;
					LobyManager.Instance.gamePoker.btnSendCards.visible = false;
					LobyManager.Instance.gamePoker.btnDiscard.visible = false;
					LobyManager.Instance.gamePoker.btnHint.visible = false;
					// 初始化玩家的准备用按钮
					Game.Instance.readyStateInit();
					// “等待其他玩家” 该信息不显示
					LobyManager.Instance.gamePoker.labelWait.visible = false;
					// 
					requestSuccess = true;
				}
			}
			else if(send_type == send_leave)
			{
    			// 使游戏本体不见，并回到游戏房间，刷新房间
    			LobyManager.Instance.gamePoker.endup();
    			// 回到游戏
    			LobyManager.Instance.changeState(1);
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
					LobyManager.Instance.gamePoker.btnReady.enabled = false;
					LobyManager.Instance.gamePoker.labelWait.visible = true;
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
						send(send_updateWhileGameFirstframe);
						setSendType(send_updateWhileGame);
						Game.Instance.gameState = 4;
						Game.Instance.getSelfseat();

						// 将准备按钮隐藏
						LobyManager.Instance.gamePoker.btnReady.visible = false;
						LobyManager.Instance.gamePoker.labelWait.visible = false;
						// 准备状态按钮初始化
						Game.Instance.readyStateInit();
					}
					else if(json1.status == 2)
					{
						Game.Instance.getSelfseat();
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
								LobyManager.Instance.gamePoker.btnSendCards.visible = true;
								LobyManager.Instance.gamePoker.btnSendCards.enabled = false;
								LobyManager.Instance.gamePoker.btnDiscard.visible = true;
								LobyManager.Instance.gamePoker.btnDiscard.enabled = true;
								LobyManager.Instance.gamePoker.btnHint.visible = true;
								if(json1.play.last == json1.play.next)
								{
									LobyManager.Instance.gamePoker.btnDiscard.enabled = false;
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
								LobyManager.Instance.gamePoker.btnSendCards.visible = true;
								LobyManager.Instance.gamePoker.btnSendCards.enabled = false;
								LobyManager.Instance.gamePoker.btnDiscard.visible = true;
								LobyManager.Instance.gamePoker.btnDiscard.enabled = true;
								LobyManager.Instance.gamePoker.btnHint.visible = true;
								if(json1.play.last == json1.play.next)
								{
									LobyManager.Instance.gamePoker.btnDiscard.enabled = false;
								}
							}
							// 对游戏正常结束的判断。
						}
						// 如果游戏意外结束，退回到开始界面
						else if(json1.status == 1)
						{
							Alert.show("游戏意外结束，重新开始","有玩家推出了房间");
//							GameObjectManager.Instance.shutdown();
//							LobyManager.Instance.gamePoker.currentState = "MainMenu";
						}
						// 游戏胜利
						else if(json1.status == 2)
						{
							GameObjectManager.Instance.shutdown();
							// 背景还是要保留
							GameObjectManager.Instance.setVisibleByName("BG", true);
							Game.Instance.gameState = 5;
							LobyManager.Instance.gamePoker.showPopupDlg();
						}
					}

				}
				else
				{
					if(json1.hasOwnProperty("error"))
					{
						if(json1.error.message != null)
							str += json1.error.message+"\n";
					}
					Alert.show(str, "");
				}
			}
			json2 = json1;
		}

		public function updateFailProcess(event:Event):void
		{
			requestEnable = true;
			updaterStateManager.fault();
		}
		private function sendResultProcess():void
		{
			try{
				json2 = JSON.decode(sender.lastResult.toString());
 			}catch(error:ArgumentError){
 				trace("json decode error");
 			}

			senderStateManager.receive(json2);			
		}
		private function sendFailProcess():void
		{
			senderStateManager.fault();
		}
	}
}