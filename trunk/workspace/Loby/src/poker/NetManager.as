package poker
{
	import flash.events.Event;
	
	import json.JSON;
	
	import lobystate.StateManager;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import poker.gamestate.StateDiscard;
	import poker.gamestate.StateGetLeftCards;
	import poker.gamestate.StateGetScore;
	import poker.gamestate.StateGetTableSetting;
	import poker.gamestate.StateInviteFriend;
	import poker.gamestate.StateItemGetPlayedCards;
	import poker.gamestate.StateLeaveTable;
	import poker.gamestate.StateNotifyReady;
	import poker.gamestate.StateSendCards;
	import poker.gamestate.StateUpdateForFirstFrame;
	import poker.gamestate.StateUpdateWhileGame;
	import poker.gamestate.StateUpdateWhileWait;
	
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
		public static const sendURL_tableSetting:String = sendURL_serverIP+"/game/room/viewSetting";
		public static const sendURL_inviteFriend:String = sendURL_serverIP+"/game/friend/invite";
		//传送的数据内容
		private var sendData:String = null;
		//
		private var netManager:NetManager=null;
		// 发送数据的格式
		public static const send_joinRoom:String = "join Room";
		public static const send_leave:String = "leave Room";
		public static const send_iamReady:String = "i am ready";
		public static const send_cancelReady:String = "not ready";
		public static const send_updateWhileWait:String = "update While Wait";
		public static const send_updateWhileGame:String = "update While Game";
		public static const send_updateWhileGameFirstframe:String = "for getting cards";
		public static const send_requestinfo:String = "request player info";
		public static const send_sendcardsWhileGame:String = "send cards";
		public static const send_passWhileGame:String = "pass";
		public static const send_getScore:String = "get score";
		public static const send_itemGetPlayedCards:String = "item get played cards";
		public static const send_getGameoverPlayerLeftCard:String = "get left cards";
		public static const send_getTableSetting:String = "get table setting";
		public static const send_inviteFriend:String = "i f";
		private var	send_type:String = null;
		// 记录了本次请求的内容, 请求的内容一般属于下面的几类
		public var request_type_cards:Boolean = false;
		public var request_type_play:Boolean = false;
		public var request_type_players:Boolean = false;
		public var request_type_history:Boolean = false;
		
		// 请求连接标志位
		// 当本次请求发出以后，置为真，这期间，不再发起人和的请求，直到收到或者超时为止。
		public var updaterequestEnable:Boolean = true;
		public var sendrequestEnable:Boolean = true;
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
			//updater.requestTimeout = 3;
			updater.showBusyCursor = false;
			updater.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			updater.addEventListener(ResultEvent.RESULT, updateResultProcess);
			updater.addEventListener(FaultEvent.FAULT, updateFailProcess);
			
			sender.method = "POST";
			sender.requestTimeout = 2;
			sender.showBusyCursor = true;
			sender.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
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
	
		public function update(type:String):void
		{
			if(updaterequestEnable)
				updaterequestEnable = false;
			else
				return;
				
			if(type == send_updateWhileWait)
			{
				updaterStateManager.changeState(StateUpdateWhileWait.Instance);
			}
			else if(type == send_updateWhileGame)
			{
				updaterStateManager.changeState(StateUpdateWhileGame.Instance);
			}
			updaterStateManager.send();
		}
		public function	send(type:String):void
		{
			// 对发送进行控制
			if(sendrequestEnable)
				sendrequestEnable = false;
			else
				return;
			//重置所有的请求标志位
			request_type_cards = false;
			request_type_play = false;
			request_type_players = false;
			request_type_history = false;
			//改变处理类型
			send_type = type;
				
			if(type == send_leave)
			{
				senderStateManager.changeState(StateLeaveTable.Instance);
			}
			else if(type == send_iamReady)
			{
				// 游戏状态变成 发送举手消息以后
				senderStateManager.changeState(StateNotifyReady.Instance);
			}
			else if(type == send_updateWhileGameFirstframe)
			{
				senderStateManager.changeState(StateUpdateForFirstFrame.Instance);
			}
			else if(type == send_sendcardsWhileGame)
			{
				senderStateManager.changeState(StateSendCards.Instance);
			}
			else if(type == send_passWhileGame)
			{
				senderStateManager.changeState(StateDiscard.Instance);
			}
			else if(type == send_getScore)
			{
				senderStateManager.changeState(StateGetScore.Instance);
			}
			else if(type == send_getGameoverPlayerLeftCard)
			{
				senderStateManager.changeState(StateGetLeftCards.Instance);
			}
			else if(type == send_itemGetPlayedCards)
			{
				senderStateManager.changeState(StateItemGetPlayedCards.Instance);
			}
			else if(type == send_getTableSetting)
			{
				senderStateManager.changeState(StateGetTableSetting.Instance);
			}
			else if(type == send_inviteFriend)
			{
				senderStateManager.changeState(StateInviteFriend.Instance);
			}

			senderStateManager.send();
		}
		
		public function updateResultProcess(event:Event):void
		{
			// 本次的请求到达，可以进行下一次请求
			updaterequestEnable = true;
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
		}

		public function updateFailProcess(event:Event):void
		{
			updaterequestEnable = true;
			updaterStateManager.fault(event);
		}
		private function sendResultProcess(event:Event):void
		{
			sendrequestEnable = true;
			try{
				json2 = JSON.decode(sender.lastResult.toString());
 			}catch(error:ArgumentError){
 				trace("json decode error");
 			}

			senderStateManager.receive(json2);			
		}
		private function sendFailProcess(event:Event):void
		{
			sendrequestEnable = true;
			senderStateManager.fault(event);
		}
	}
}