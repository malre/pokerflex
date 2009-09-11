package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	public class lobbyChatSend extends httpModelBase
	{
		public function lobbyChatSend()
		{
			super();
		}
		
		override public function send(val:Object=null) : void
		{
			var str:String = JSON.encode(val);
			httpservice.url = Messenger.Instance.chatSendLobby;
			httpservice.request = {"message":str};
			httpservice.send();
		}
		
		override public function result(event:Event) : void
		{
		}
		
		override public function fault(event:Event) : void
		{
		}
	}
}