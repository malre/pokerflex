package lobystate
{
	import flash.events.Event;

	public class StateManager
	{
//		private static var instance:StateManager = null;
		// state 
		private var state:NetRequestState = null;
		
		public function StateManager()
		{
		}

//		public static function get Instance():StateManager
//		{
//			if(instance == null)
//				instance = new StateManager();
//			return instance;
//		}
		
		public function changeState(state:NetRequestState):void
		{
			this.state = state;
		}
		
		public function send():void
		{
			if(state != null)
				state.send(this);
		}
		public function receive(obj:Object):void
		{
			if(state != null)
				state.receive(obj);
		} 
		public function fault(event:Event):void
		{
			if(state != null)
				state.fault(event);
		}
	}
}