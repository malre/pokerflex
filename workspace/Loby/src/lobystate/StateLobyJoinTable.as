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
		//
		public var tablename:String = "";
		
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
		
		public function setTablename(name:String):void
		{
			tablename = name;
		}
		// override function
		override public function send(obj:StateManager):void
		{
			// 互斥量有效
			LobyManager.Instance.windowMutex = true;

			var hp:HTTPService = LobyNetManager.Instance.httpservice;
			hp.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_joinTable;
			hp.request = request;
			hp.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				LobyNetManager.Instance.send(LobyNetManager.getTableSetting);
				return true;
			}
			else{
				// 关闭互斥量
				LobyManager.Instance.windowMutex = false;
				return false;
			}
		}

		override public function fault(event:Event):void
		{
			LobyErrorState.Instance.showErrMsg("加入房间失败,意外失败");
			// 关闭互斥量
			LobyManager.Instance.windowMutex = false;
		}
	}
}