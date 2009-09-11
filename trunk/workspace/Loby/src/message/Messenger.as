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

	public class Messenger
	{
		// 消息服务器地址定义
		private var messengerServerAddress:String = "http://192.168.18.24/web/world/chat";
		private var messengerReceive:String = messengerServerAddress + "/receive";
		private var messengerSend:String = messengerServerAddress + "/send";
		
		public var chatSendLobby:String = messengerSend + "/lobby";
		public var chatSendRoom:String = messengerSend + "/room";
		public var chatSendPlayer:String = messengerSend + "/player";
		
		public var chatReceiveLobby:String = messengerReceive + "/lobby";
		public var chatReceiveRoom:String = messengerReceive + "/room";
		public var chatReceivePlayer:String = messengerReceive + "/player";
		public var chatReceiveSystem:String = messengerReceive + "/system";
		
		private var addressSet:Array = [chatSendLobby, chatSendRoom, chatSendPlayer,
			chatReceiveLobby, chatReceiveRoom, chatReceivePlayer, chatReceiveSystem];
		
		public static const sendLobby:int = 0;
		public static const sendRoom:int = 1;
		public static const sendPlayer:int = 2;
		public static const receiveLobby:int = 3;
		public static const receiveRoom:int = 4;
		public static const receivePlayer:int = 5;
		public static const receiveSystem:int = 6;
		
		public static const listenMsgLobby:int = 1;
		public static const listenMsgRoom:int = 2;
		public static const listenMsgPlayer:int = 4;
		public static const listenMsgSystem:int = 8;
		private var listenType:int;
		// instance 
		private static var instance:Messenger = null;
		// net worker instance
		public var lobbySend:lobbyChatSend;
		public var lobbyRec:lobbyChatRec;

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
			lobbyRec.setmethod("GET");
//			lobbySend.startTimer(5000);
		}
		public function send(obj:Object, type:int):void
		{
			if(type == sendLobby){
				lobbySend.send(obj);
			}
			
		}
		public function updateMsg(event:TimerEvent):void
		{
			if(listenType | listenMsgLobby)
			{
				
			}
		}
	}
}