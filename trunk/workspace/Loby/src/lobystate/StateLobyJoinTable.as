package lobystate
{
	import flash.events.Event;
	
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
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("正在加入游戏桌……");

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
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
		}

		override public function fault(event:Event):void
		{
			LobyErrorState.Instance.showErrMsg("加入房间失败,意外失败");
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}
	}
}