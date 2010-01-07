package item
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.httpController.httpModelBase;
	
	import mx.core.FlexGlobals;
	
	public class itembuyRequest extends httpModelBase
	{
		private static var instance:itembuyRequest = null;
		private var itemId:int;
		private var itemAmount:int;

		public static function Instance():itembuyRequest
		{
			if(instance == null)
				instance = new itembuyRequest();
				
			return instance;
		}

		public function itembuyRequest()
		{
			super();
		}
		
		override public function send(val:Object=null) : void
		{
			httpservice.url = miscDefines.itembuyAdd;
			// 道具的起始序列号和道具的本次请求最大数量
			httpservice.request = {"id":itemId, "number":itemAmount};
			httpservice.send();
		}

		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			lastSuccObj = obj;
			if(obj.success)
			{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox(0,"购买成功!");
			}
			else
			{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox(0,"购买失败! \n"+obj.error.message);
			}
		}
		
		override public function fault(event:Event) : void
		{
		}
		
		public function setItemBuy(id:int, count:int):void
		{
			itemId = id;
			itemAmount = count;
		}
	}
}