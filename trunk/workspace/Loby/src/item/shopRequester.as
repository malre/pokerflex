package item
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.httpController.httpModelBase;
	
	import mx.core.FlexGlobals;
	
	public class shopRequester extends httpModelBase
	{
		private static var instance:shopRequester = null;
		//
		public var offset:int;
		public var amount:int;
		// 显示的页数
		public var page:int;
		// 请求的页数和相关信息
		private var rqOffset:int;
		private var rqAmount:int;
		private var rqPage:int;
		
		public static function Instance():shopRequester
		{
			if(instance == null)
				instance = new shopRequester();
				
			return instance;
		}
		
		public function shopRequester()
		{
			super();
			offset = rqOffset = 0;
			amount = rqAmount = 12;
			page = rqPage = 0;
		}
		
		override public function send(val:Object=null) : void
		{
			httpservice.url = miscDefines.shoplistAdd;
			// 道具的起始序列号和道具的本次请求最大数量
			httpservice.request = {"offset":rqOffset, "limit":rqAmount};
			httpservice.send();
		}
		
		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			lastSuccObj = obj;
			FlexGlobals.topLevelApplication.shopmenu.clearItem();
			// 传送给viewer来显示
			FlexGlobals.topLevelApplication.shopmenu.drawItem(obj);
			// 同步当前数据
			offset = rqOffset;
			amount = rqAmount;
			page = rqPage;
			
			// 控制左右的按钮的有效
			if(rqPage == 0)
				FlexGlobals.topLevelApplication.shopmenu.pageleft.enabled = false;
			else
				FlexGlobals.topLevelApplication.shopmenu.pageleft.enabled = true;
			if(obj.items.length > 12)
				FlexGlobals.topLevelApplication.shopmenu.pageright.enabled = true;
			else
				FlexGlobals.topLevelApplication.shopmenu.pageright.enabled = false;
			// 改变page的值
			FlexGlobals.topLevelApplication.shopmenu.pagenumber.text = (page+1).toString();
		}

		override public function fault(event:Event) : void
		{
		}
		
		/**
		 * 用来设置发送的道具请求 
		 * @param startIndex
		 * 	起始的道具序号
		 * @param count
		 * 	道具的数量
		 */		
		public function setRequest(startIndex:int, count:int=13):void
		{
			rqOffset = startIndex;
			rqAmount = count;
			rqPage = startIndex/12;
		}
		public function AddPage():void
		{
			
		}
		public function SubPage():void
		{
			
		}

	}
}