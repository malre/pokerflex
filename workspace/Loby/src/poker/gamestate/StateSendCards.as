package poker.gamestate
{
	import lobystate.NetRequestState;
	
	public class StateSendCards extends NetRequestState
	{
		private static var instance:StateSendCards = null;

		public function StateSendCards()
		{
			super();
		}
		
		public static function get Instance():StateSendCards
		{
			if(instance == null)
				instance = new StateSendCards();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
			
		}
	}
}