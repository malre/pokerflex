package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	public class shoutChatRec extends httpModelBase
	{
		private var shoutmsg:Array;

		public function shoutChatRec()
		{
			super();
			shoutmsg = new Array();
		}

		override public function send(val:Object=null) : void
		{
			httpservice.url = Messenger.Instance.chatReceiveShout;
			if(lastSuccObj.hasOwnProperty("chat"))
			{
				if(lastSuccObj.chat.length != 0)
				{
					httpservice.request = {"time":lastSuccObj.chat[0].time};
				}
				else
					httpservice.request = {"time":0};
			}
			else
				httpservice.request = {"time":0};
			httpservice.send();
		}
		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			if(!obj.hasOwnProperty("chat"))
				return;
			if(obj.chat.length == 0)
			{
				return;
			}
			lastSuccObj = obj;
			// 传送给viewer来显示
			for(var i:int =0; i<obj.chat.length; i++)
			{
				var str:String = Messenger.Instance.delSlash(obj.chat[i].message);
				shoutmsg.push(str);
			}
		}
		override public function fault(event:Event) : void
		{
			
		}
		
		public function getShoutmsg():String
		{
			return shoutmsg.shift();
		}
	}
}