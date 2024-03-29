package lobystate
{
	import flash.events.Event;

	public class NetRequestState
	{
		public var lastFlag:Boolean;
		public var lastSuccData:Object = new Object();
		protected var showError:Boolean;
		protected var timeoutCounter:int = 0;
		protected var timeoutCounterMax:int = 3;
		// construct
		public function NetRequestState()
		{
			lastFlag = false;
			showError = true;
		}
		
		public function clearCounter():void
		{
			timeoutCounter = 0;
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
					if(obj.hasOwnProperty("error") && showError)
					{
						if(obj.error.hasOwnProperty("message")){
							LobyErrorState.Instance.showErrMsg(obj.error.message);
						}
					}
					return false;
				}
			}
			lastSuccData = obj;
			lastFlag = true;
			return true;
		}
		
		public function fault(event:Event):void
		{
			
		}
	}
}