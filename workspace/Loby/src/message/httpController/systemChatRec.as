package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.Messenger;

	/**
	 * 保存公告消息的内容
	 * 
	 */	

	public class systemChatRec extends httpModelBase
	{
		private var announcement:Array;
		public function systemChatRec()
		{
			super();
			announcement = new Array();
		}

		override public function send(val:Object=null) : void
		{
			httpservice.url = Messenger.Instance.chatReceiveSystem;
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
				announcement.push( obj.chat[i].message );
			}
		}
		override public function fault(event:Event) : void
		{
			
		}
		
		/**
		* 获得公告的内容，一旦一条内容被取出，就不在存在在数组中
		*/	
		public function getAnnouncement():String
		{
			return announcement.shift();
		}
	}
}