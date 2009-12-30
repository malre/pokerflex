package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateSendGift extends NetRequestState
	{
		private static var instance:StateSendGift = null;
		
		public var friend:String;
		public var itemId:String;
		public var amount:int;

		public function StateSendGift()
		{
			super();
		}

		public static function get Instance():StateSendGift
		{
			if(instance == null)
				instance = new StateSendGift();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_sendGift;
			LobyNetManager.Instance.httpservice.request = {"companion":friend, "iid":itemId, "amount":amount}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox(0, "赠送成功!");
				return true;
			}
			else{
				FlexGlobals.topLevelApplication.shopmenu.showMsgBox(0, "赠送失败!");
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
		}
	}
}