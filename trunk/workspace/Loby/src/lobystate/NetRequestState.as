package lobystate
{
	public class NetRequestState
	{
		public var lastFlag:Boolean;
		public var lastSuccData:Object = new Object();
		// construct
		public function NetRequestState()
		{
			lastFlag = false;
		}
		
		// handler
		public function send(obj:StateManager):void
		{
		}
		public function receive(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("success"))
			{
				if(!obj.success)
				{
					lastFlag = false;
					if(obj.hasOwnProperty("error"))
					{
						LobyErrorState.Instance.showErrMsg(obj.error.message);
					}
					return false;
				}
			}
			lastSuccData = obj;
			lastFlag = true;
			return true;
		}
		
		public function fault():void
		{
			
		}
	}
}