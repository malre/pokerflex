package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	public class shoutChatRec extends httpModelBase
	{
		private var shoutmsg:Array;
		private var systemmsg:Array;

		public function shoutChatRec()
		{
			super();
			shoutmsg = new Array();
			systemmsg = new Array();
		}

		override public function send(val:Object=null) : void
		{
			httpservice.url = Messenger.Instance.chatRecShoutSystemPlayer;
			var rq:Object = new Object();
			if(lastSuccObj.hasOwnProperty("system"))
			{
				if(lastSuccObj.system.length != 0)
				{
					rq.systemtime = lastSuccObj.system[0].time;
				}
				else
					rq.systemtime = 0;
			}
			else
				rq.systemtime = 0;
			if(lastSuccObj.hasOwnProperty("yell"))
			{
				if(lastSuccObj.yell.length != 0)
				{
					rq.yelltime = lastSuccObj.yell[0].time;
				}
				else
					rq.yelltime = 0;
			}
			else
				rq.yelltime = 0;
			httpservice.request = rq;
			httpservice.send();
		}
		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			var str:String;
			var i:int;
			if(obj.hasOwnProperty("system"))
			{
				if(obj.system.length != 0)
				{
					for(i =0; i<obj.system.length; i++)
					{
						str = Messenger.Instance.delSlash(obj.system[obj.system.length-1-i].message);
						systemmsg.push(str);
					}
					lastSuccObj = obj;
				}
			}
			if(obj.hasOwnProperty("yell"))
			{
				if(obj.yell.length != 0)
				{
					for(i =0; i<obj.yell.length; i++)
					{
						str = Messenger.Instance.delSlash(obj.yell[obj.yell.length-1-i].message);
						shoutmsg.push(str);
					}
					lastSuccObj = obj;
				}
			}
		}
		override public function fault(event:Event) : void
		{
			
		}
		
		public function getShoutmsg():String
		{
			return shoutmsg.shift();
		}
		public function getSystemmsg():String
		{
			return systemmsg.shift();
		}
	}
}