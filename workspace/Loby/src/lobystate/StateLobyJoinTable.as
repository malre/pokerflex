package lobystate
{
	import flash.events.Event;
	import mx.core.FlexGlobals;
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
			hp.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_joinTable;
			hp.request = request;
			hp.send();
		}
		override public function receive(obj:Object):void
		{
			if(LobyManager.Instance.isGameLoaded)
			{
				FlexGlobals.topLevelApplication.gameFlash.visible = true;
			}
			else
			{
				//开始调用游戏的flash
				FlexGlobals.topLevelApplication.gameFlash.addEventListener(Event.INIT, initlisten);
				FlexGlobals.topLevelApplication.gameFlash.load();
				// 生成local connection的本体， 并注册connect name
				LobyLocalConnReceiver.Instance;
			}
			
		}
		private function initlisten(event:Event):void
		{

            // Initialize variables with information from
            // the loaded application.
            FlexGlobals.topLevelApplication.gameFlash.x = 0;
            FlexGlobals.topLevelApplication.gameFlash.y = 0;
            FlexGlobals.topLevelApplication.gameFlash.width = 780;
            FlexGlobals.topLevelApplication.gameFlash.height = 560;
			FlexGlobals.topLevelApplication.gameFlash.visible = true;
			//
			LobyManager.Instance.isGameLoaded = true;
		}
	}
}