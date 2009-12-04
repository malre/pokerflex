package message.httpController
{
	import flash.events.Event;
	
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	
	import json.JSON;
	
	import message.Messenger;
	
	import mx.core.FlexGlobals;
	
	import spark.components.TextArea;

	public class lobbyChatSend extends httpModelBase
	{
		private var time:int = 0;
		public function lobbyChatSend()
		{
			super();
		}
		
		override public function send(val:Object=null) : void
		{
			var curTime:Date = new Date();
			var delta:int = curTime.getTime() - time;
			if( delta >= Messenger.lobbySendmsgInterval)
			{
				var str:String = JSON.encode(val);
				httpservice.url = Messenger.Instance.chatSendLobby;
				httpservice.request = {"message":str};
				httpservice.send();
			}
			else{
				addErrMsg(Messenger.lobbySendErrorText);
			}
		}
		
		override public function result(event:Event) : void
		{
			time = (new Date()).getTime();
			Messenger.Instance.send(null, Messenger.receiveLobby);
		}
		
		override public function fault(event:Event) : void
		{
			addErrMsg("发送的消息超时失败。");
		}
		
		protected function addErrMsg(str:String) : void
		{
			var ta:TextArea = TextArea(FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox);

			//
			var pp:ParagraphElement = new ParagraphElement();
			var span:SpanElement;
			span = new SpanElement();
			span.text = "系统提示:"+str;
			span.color = 0xffcc33;
			span.fontSize = 12;
			pp.addChild(span);
			ta.textFlow.addChild(pp);		

			ta.appendText("");
		}
	}
}