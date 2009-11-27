package message
{
	/**
	 * 
	 * @author Eric
	 * 这个类是一个分离的用来进行通信的类
	 * 拥有独立的界面和通信类
	 * 界面部分预计使用的是fte，也就是10.0提供的新的功能来进行文字和图的混合编排
	 * 使用httpservice来进行消息的传递
	 */
	import flash.events.TimerEvent;
	
	import message.httpController.lobbyChatRec;
	import message.httpController.lobbyChatSend;
	import message.httpController.shoutChatRec;
	import message.httpController.shoutChatSend;
	import message.httpController.systemChatRec;
	import message.httpController.tableChatRec;
	import message.httpController.tableChatSend;

	public class Messenger
	{
		// 消息服务器地址定义
		include "../ServerAddress.ini"
		private var messengerServerAddress:String = ServerAddress + ServerPerfix+"/chat";
		private var messengerReceive:String = messengerServerAddress + "/receive";
		private var messengerSend:String = messengerServerAddress + "/send";
		
		public var chatSendLobby:String = messengerSend + "/lobby";
		public var chatSendRoom:String = messengerSend + "/room";
		public var chatSendPlayer:String = messengerSend + "/player";
		public var chatSendShout:String = messengerSend + "/yell";
		
		public var chatReceiveLobby:String = messengerReceive + "/lobby";
		public var chatReceiveRoom:String = messengerReceive + "/room";
		public var chatReceivePlayer:String = messengerReceive + "/player";
		public var chatReceiveSystem:String = messengerReceive + "/system";
		public var chatReceiveShout:String = messengerReceive + "/yell";
		
		private var addressSet:Array = [chatSendLobby, chatSendRoom, chatSendPlayer,
			chatReceiveLobby, chatReceiveRoom, chatReceivePlayer, chatReceiveSystem];
		
		public static const sendLobby:int = 0;
		public static const sendRoom:int = 1;
		public static const sendPlayer:int = 2;
		public static const receiveLobby:int = 3;
		public static const receiveRoom:int = 4;
		public static const receivePlayer:int = 5;
		public static const receiveSystem:int = 6;
		public static const sendShout:int = 7;
		public static const receiveShout:int = 8;
		
		public static const listenMsgLobby:int = 1;
		public static const listenMsgRoom:int = 2;
		public static const listenMsgPlayer:int = 4;
		public static const listenMsgSystem:int = 8;
		
		public static const msgContainerMaxLength:int = 30;
		private var listenType:int;
		// instance 
		private static var instance:Messenger = null;
		// net worker instance
		public var lobbySend:lobbyChatSend;
		public var lobbyRec:lobbyChatRec;
		public var tableSend:tableChatSend;
		public var tableRec:tableChatRec;
		public var systemRec:systemChatRec;
		public var shoutSend:shoutChatSend;
		public var shoutRec:shoutChatRec;

		public static function get Instance():Messenger
		{
			if(instance == null)
				instance = new Messenger();
			return instance;
		}

		public function Messenger()
		{
			// 构建所有的消息收发类
			lobbySend = new lobbyChatSend();
			lobbySend.setmethod("POST");
			lobbyRec = new lobbyChatRec();
			lobbyRec.setmethod("POST");
			tableSend = new tableChatSend();
			tableSend.setmethod("POST");
			tableRec = new tableChatRec();
			tableRec.setmethod("POST");
			systemRec = new systemChatRec();
			systemRec.setmethod("POST");
			
			shoutSend = new shoutChatSend();
			shoutSend.setmethod("POST");
			shoutRec = new shoutChatRec();
			shoutRec.setmethod("POST");
		}

		public function startLobby():void
		{
			lobbyRec.startTimer(5000);
		}
		public function stopLobby():void
		{
			lobbyRec.stopTimer();
		}
		public function startGame():void
		{
			tableRec.startTimer(5000);
		}
		public function stopGame():void
		{
			tableRec.stopTimer();
		}
		public function startSystem():void
		{
			systemRec.startTimer(5000);
		}
		public function startShout():void
		{
			shoutRec.startTimer(5000);
		}
		public function send(obj:Object, type:int):void
		{
			if(type == sendLobby){
				lobbySend.send(obj);
			}
			else if(type == receiveLobby)
			{
				lobbyRec.send();
			}
			else if(type == sendRoom){
				tableSend.send(obj);
			}
			else if(type == receiveRoom){
				tableRec.send();
			}
			else if(type == sendShout){
				shoutSend.send(obj);
			}
		}
		public function updateMsg(event:TimerEvent):void
		{
			if(listenType | listenMsgLobby)
			{
				
			}
		}
		
		// 因为服务器 magic_quotes_gpc 参数设置的影响，得到的需要进行一次去除斜杠的处理
		public function delSlash(str:String):String
		{
			// 首先，先去除一次引号前的斜杠，是2个
			var pattern:RegExp = /\\"/g;
			var src:String = new String(str);
			var rlt:String = src.replace(pattern, "\"");
			
			var pattern2:RegExp = /\\\\/g;
			src = rlt;
			rlt = src.replace(pattern2, "\\");
			return rlt;
		}
	}
}