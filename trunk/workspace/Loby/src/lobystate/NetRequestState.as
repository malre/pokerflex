package lobystate
{
	import mx.controls.Alert;

	public class NetRequestState
	{
		public var lastSuccData:Object = new Object();
		// construct
		public function NetRequestState()
		{
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
					if(obj.hasOwnProperty("error"))
					{
						Alert.show(obj.error.message);
					}
					return false;
				}
			}
			lastSuccData = obj;
			return true;
		}
	}
}