package lobystate
{
	public class StateJoinLoby extends NetRequestState
	{
		private static var instance:StateJoinLoby = null;
		private var lobyid:int;

		public function StateJoinLoby()
		{
			super();
		}
		public static function get Instance():StateJoinLoby
		{
			if(instance == null)
				instance = new StateJoinLoby();
			return instance;
		}
		public function setLobyid(id:int):void
		{
			lobyid = id;
		}
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_addloby;
			LobyNetManager.Instance.httpservice.request = {"lid":lobyid};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				LobyNetManager.Instance.send(LobyNetManager.tableInfo);
				// 成功之后需要把player对象的lid进行赋值
				LobyManager.Instance.playerInfo.player.lid = lobyid;
				
				return true;
			}
			else{
				return false;
			}
			
		}
		
	}
}