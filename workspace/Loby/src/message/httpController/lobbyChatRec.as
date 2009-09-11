package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	public class lobbyChatRec extends httpModelBase
	{
		public function lobbyChatRec()
		{
			super();
		}
		
		override public function send(val:Object=null) : void
		{
			httpservice.url = Messenger.Instance.chatReceiveLobby;
			httpservice.request = {};
			httpservice.send();
		}
		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			
		}
		override public function fault(event:Event) : void
		{
			
		}
	}
}