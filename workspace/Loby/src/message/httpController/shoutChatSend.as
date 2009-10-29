package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	public class shoutChatSend extends httpModelBase
	{
		public function shoutChatSend()
		{
			super();
		}

		override public function send(val:Object=null) : void
		{
			var str:String = JSON.encode(val);
			httpservice.url = Messenger.Instance.chatSendShout;
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