package
{
	public class StateLobyJoinTable extends NetRequestState
	{
		private static var instance:StateLobyJoinTable = null;
		// construct
		public function StateLobyJoinTable()
		{
		}
		
		public static function get Instance():StateLobyJoinTable
		{
			if(instance == null)
				instance = new StateLobyJoinTable();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}