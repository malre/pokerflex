package lobystate
{
	import mx.rpc.http.HTTPService;

	public class StateLobyJoinTable extends NetRequestState
	{
		private static var instance:StateLobyJoinTable = null;
		//
		private var request:Object;
		
		// construct
		public function StateLobyJoinTable()
		{
			super();
		}
		
		public static function get Instance():StateLobyJoinTable
		{
			if(instance == null)
				instance = new StateLobyJoinTable();
			return instance;
		}
		
		public function setRequest(rq:Object):void
		{
			request = rq;
		}
		// override function
		override public function send(obj:StateManager):void
		{
			var hp:HTTPService = LobyNetManager.Instance.httpservice;
			hp.url = LobyNetManager.Instance.URL_lobysonAddress + LobyNetManager.URL_joinTable;
			hp.request = request;
			hp.send();
			//request_jointable = true;
		}
		override public function receive(obj:StateManager):void
		{
			
		}
	}
}