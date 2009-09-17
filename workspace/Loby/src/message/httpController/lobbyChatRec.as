package message.httpController
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.ContentViewer;
	import message.Messenger;
	
	import mx.core.FlexGlobals;

	public class lobbyChatRec extends httpModelBase
	{
		public function lobbyChatRec()
		{
			super();
		}
		
		override public function send(val:Object=null) : void
		{
			httpservice.url = Messenger.Instance.chatReceiveLobby;
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
			if(obj.chat.length == 0)
			{
				return;
			}
			lastSuccObj = obj;
			// 传送给viewer来显示
			for(var i:int =0; i<obj.chat.length; i++)
			{
				FlexGlobals.topLevelApplication.customcomponent31.showboxLobby.addNewMsg(obj.chat[(obj.chat.length-1)-i]);
			}
		}
		override public function fault(event:Event) : void
		{
			
		}
	}
}