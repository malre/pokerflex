package message.httpController
{
	import flash.events.Event;
	
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	
	import json.JSON;
	
	import message.Messenger;
	import message.ResEmotion;
	
	import mx.core.FlexGlobals;
	
	import spark.components.TextArea;

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
				//FlexGlobals.topLevelApplication.customcomponent31.showboxLobby.addNewMsg(obj.chat[(obj.chat.length-1)-i]);
				var ta:TextArea = TextArea(FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox);
				addNewMsg(obj.chat[(obj.chat.length-1)-i], ta.textFlow);
				ta.appendText("");
			}
		}
		override public function fault(event:Event) : void
		{
			
		}
		
		/**
		 * 把得到的新的消息加入到显示 
		 * @param str
		 * 
		 */		
		protected function addNewMsg(obj:Object, tf:TextFlow):void
		{
			var pp:ParagraphElement = new ParagraphElement();
			var data:Object = JSON.decode(obj.message);
			var span:SpanElement;
			span = new SpanElement();
			span.text = "["+obj.name+"]:";
			span.color = 0xffff66;
			span.fontSize = 12;
			pp.addChild(span);
			for(var i:int=0; i<data.content.length; i++)
			{
				if(data.content[i].type == "text")
				{
					span = new SpanElement();
					span.text = data.content[i].val;
					pp.addChild(span);
				}
				else if(data.content[i].type == "img"){
					var img:InlineGraphicElement = new InlineGraphicElement();
					img.width = data.size;
					img.height = data.size;
					img.source = ResEmotion.EmotionRes[data.content[i].val];
					pp.addChild(img);
				}
			}
			
			pp.fontSize = data.size;
			if(data.color != null)
				pp.color = data.color;
			else
				pp.color = 0xffffff;
			tf.addChild(pp);
//			textcontent.flowComposer.updateAllControllers();
		}
	}
}