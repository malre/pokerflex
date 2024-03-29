package item
{
	import flash.events.Event;
	
	import json.JSON;
	
	import message.httpController.httpModelBase;
	
	import mx.core.FlexGlobals;
	
	public class playerItemsRequester extends httpModelBase
	{
		private static var instance:playerItemsRequester = null;

		//
		// 显示的页数
		public var page:int;
		public var offset:int;
		public var amount:int;
		// 请求的页数和相关信息
		private var rqOffset:int;
		private var rqAmount:int;
		private var rqPage:int;
		// 0: normal, 1:for item enum
		private var type:int;


		public static function Instance():playerItemsRequester
		{
			if(instance == null)
				instance = new playerItemsRequester();
				
			return instance;
		}

		public function playerItemsRequester()
		{
			super();
			offset = rqOffset = 0;
			amount = rqAmount = 12;
			page = rqPage = 0;
			type = 0;
		}
		
		public function setType(val:int):void
		{
			type = val;
		}
		
		override public function send(val:Object=null) : void
		{
			httpservice.url = miscDefines.playeritemListAdd;
			// 道具的起始序列号和道具的本次请求最大数量
			httpservice.request = {"offset":rqOffset, "limit":rqAmount};
			httpservice.send();
		}

		override public function result(event:Event) : void
		{
			var obj:Object = JSON.decode(httpservice.lastResult.toString());
			lastSuccObj = obj;
			if(type == 0)
			{
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
			else{
				if(isItemExist("1010313")){
					// 显示喊话窗口
					
				}
			}
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
		
		protected function isItemExist(id:String):int
		{
			for each(var obj:Object in lastSuccObj)
			{
				if(obj.name == id){
					return obj.number;
				}
			}
//			for(var i:int= 0;i<(obj.items.length>12?12:obj.items.length);i++)
//			{
//				var img:Image = Image(item_icon_group.getChildByName("item"+i.toString()));
//				img.source = ServerAddress + ServerPerfix + webResourePerfix + obj.items[i].image;
//				img.toolTip = obj.items[i].name;
//				img.addEventListener(ToolTipEvent.TOOL_TIP_CREATE, tooltipcreate);
//				img.visible = true;
//			}
			return 0;
		}
	}
}