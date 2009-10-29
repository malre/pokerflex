package lobystate
{
	import mx.core.FlexGlobals;

	public class StateCreateTable extends NetRequestState
	{
		private static var instance:StateCreateTable = null;
		//
		private var password:String;
		private var passwordEnable:Boolean = false;
		private var lowlv:int;
		private var highlv:int;
		private var goldrate:int;
		private var goldrateEnable:Boolean = false;
		private var chatEnable:Boolean = false;

		public function StateCreateTable()
		{
			super();
		}

		public static function get Instance():StateCreateTable
		{
			if(instance == null)
				instance = new StateCreateTable();
			return instance;
		}

		public function setOption(pw:String, pwEn:Boolean, llv:int, hlv:int, gdrate:int, gdrateEn:Boolean, chatEn:Boolean):void
		{
			password = pw;
			passwordEnable = pwEn;
			lowlv = llv;
			highlv = hlv;
			goldrate = gdrate;
			goldrateEnable = gdrateEn;
			chatEnable = chatEn;
		}
		
		override public function send(obj:StateManager):void
		{
			var req:Object = new Object();
			if(passwordEnable)
				req.pw = password;
			if(lowlv != 0)
				req.llv = lowlv;
			if(highlv != 0)
				req.ulv = highlv;
			if(goldrateEnable)
				req.mag = goldrate;
			req.ac = chatEnable;
			req.lid = StateGetPlayerInfo.Instance.lastSuccData.player.lid;
			req.gid = StateGetPlayerInfo.Instance.lastSuccData.player.gid;
			req.getPlayers = true;
			
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_createTable;
			LobyNetManager.Instance.httpservice.request = req; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.gamePoker.startup(obj);
				// 
				LobyManager.Instance.changeState(2);
				return true;
			}
			else{
				LobyErrorState.Instance.showErrMsg("创建房间失败！");
				return false;
			}
			
		}
		override public function fault():void
		{
			LobyErrorState.Instance.showErrMsg("超时，创建房间失败！");
		}
	}
}