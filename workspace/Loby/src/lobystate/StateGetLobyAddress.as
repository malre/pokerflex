package lobystate
{
	import flash.events.Event;

	public class StateGetLobyAddress extends NetRequestState
	{
		private static var instance:StateGetLobyAddress = null;
		
		public function StateGetLobyAddress()
		{
			super();
		}

		public static function get Instance():StateGetLobyAddress
		{
			if(instance == null)
				instance = new StateGetLobyAddress();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_playerInfo;
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 把成功得到的loby地址记录下来
				//URL_lobysonAddress = result.address;
				// 请求房间信息
				LobyNetManager.Instance.send(LobyNetManager.roomInfo);
				// 成功的情况下， 把进入的游戏的名字加入到标签里面
				// LobyManager.Instance.joinShuangkou();
				return true;
			}
			else{
				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			
		}
	}
}