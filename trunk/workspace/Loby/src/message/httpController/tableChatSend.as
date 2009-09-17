package message.httpController
{
	import flash.events.Event;
	import json.JSON;
	import message.Messenger;
	public class tableChatSend extends httpModelBase
	{
		public function tableChatSend()
		{
			super();
		}
		override public function send(val:Object=null) : void
		{
			var str:String = JSON.encode(val);
			httpservice.url = Messenger.Instance.chatSendRoom;
			httpservice.request = {"message":str};
			httpservice.send();
		}
		
		override public function result(event:Event) : void
		{
			Messenger.Instance.send(null, Messenger.receiveRoom);
		}
		
		override public function fault(event:Event) : void
		{
		}

	}
}