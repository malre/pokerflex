package item
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.httpController.httpModelBase;
	
	import mx.core.FlexGlobals;
	
	public class itemuseRequest extends httpModelBase
	{
		private static var instance:itemuseRequest = null;
		private var itemId:int;

		public static function Instance():itemuseRequest
		{
			if(instance == null)
				instance = new itemuseRequest();
				
			return instance;
		}

		public function itemuseRequest()
		{
			super();
		}

		override public function send(val:Object=null) : void
		{
			httpservice.url = miscDefines.playeritemUseAdd;
			// 道具的起始序列号和道具的本次请求最大数量
			httpservice.request = {"id":itemId};
			httpservice.send();
		}
		
		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			lastSuccObj = obj;
			if(obj.success)
			{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox("使用成功!");
				// 如果使用成功，我们需要对现有的道具情况进行更新
				playerItemsRequester.Instance().setRequest(playerItemsRequester.Instance().offset);
				playerItemsRequester.Instance().send();
			}
			else
			{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox("使用失败! \n错误代码:"+ obj.error.code+" "+obj.error.message);
			}
		}

		override public function fault(event:Event) : void
		{
		}

		public function setItemUse(id:int):void
		{
			itemId = id;
		}
	}
}