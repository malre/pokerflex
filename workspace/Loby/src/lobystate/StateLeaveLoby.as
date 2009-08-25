package lobystate
{
	public class StateLeaveLoby extends NetRequestState
	{
		private static var instance:StateLeaveLoby = null;

		public function StateLeaveLoby()
		{
			super();
		}

		public static function get Instance():StateLeaveLoby
		{
			if(instance == null)
				instance = new StateLeaveLoby();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_leaveloby;
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				if(LobyManager.Instance.state == 1)
				{
					LobyNetManager.Instance.send(LobyNetManager.addloby);
				}
				return true;
			}
			else{
				return false;
			}
		}

	}
}