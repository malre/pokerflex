package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateCheckGift extends NetRequestState
	{
		private static var instance:StateCheckGift = null;
		
		private var gifts:Array;

		public function StateCheckGift()
		{
			super();
			gifts = new Array();
		}

		public static function get Instance():StateCheckGift
		{
			if(instance == null)
				instance = new StateCheckGift();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_checkGift;
			LobyNetManager.Instance.httpservice.request = {"get":true}; // 无效参数，保证post请求格式
			LobyNetManager.Instance.httpservice.method = "POST";
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				for(var i:int=0; i<obj.gifts.length; i++)
				{
					gifts.push(obj.gifts[i]);
				}
//				{
//					pid: 赠送者id,
//					name: 赠送者用户名,
//					iid: 道具id,
//					amount: 数量
//				}
				
				FlexGlobals.topLevelApplication.shopmenu.visible = true;
				FlexGlobals.topLevelApplication.shopmenu.currentState="StateItemGetGift";
				
				return true;
			}
			else{
				FlexGlobals.topLevelApplication.shopmenu.visible = true;
				FlexGlobals.topLevelApplication.shopmenu.currentState="StateItemGetGift";
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			FlexGlobals.topLevelApplication.shopmenu.visible = true;
			FlexGlobals.topLevelApplication.shopmenu.currentState="StateItemGetGift";
		}
		
		public function getGift():Object
		{
			return gifts.shift();
		}
		public function getGiftsLength():int
		{
			return gifts.length;
		}
	}
}