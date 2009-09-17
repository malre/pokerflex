package lobystate
{
	import flash.events.Event;
	
	import message.Messenger;
	
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
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				LobyManager.Instance.gamePoker.startup(obj);
				// 
				LobyManager.Instance.changeState(2);
				// 在这里改变聊天消息，不再接收大厅的消息，改成桌子的消息
				Messenger.Instance.stopLobby();
				Messenger.Instance.startGame();
				return true;
			}
			else{
				return false;
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
		override public function fault():void
		{
			
		}
	}
}