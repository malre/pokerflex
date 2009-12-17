package lobystate
{
	import flash.events.Event;

	public class StateUpdateRoomInfo extends NetRequestState
	{
		private static var instance:StateUpdateRoomInfo = null;
		// construct
		public function StateUpdateRoomInfo()
		{
			super();
		}
		
		public static function get Instance():StateUpdateRoomInfo
		{
			if(instance == null)
				instance = new StateUpdateRoomInfo();
			return instance;
		}
		
		public function isCreateTableEnable():Boolean
		{
			// is player in any room
			var lid:int = StateGetPlayerInfo.Instance.lastSuccData.player.lid;
			if(lid != 0)
			{
				var obj:Object = lastSuccData;
				for(var i:int=0; i<obj.length;i++)
				{
					if(lid == obj[i].lid)
					{
						var rtn:Boolean = int(obj[i].allowcreate)==0?false:true;
						return rtn;
					}
				}
				return false;
			}
			else
				return false;
		}
		
		public function getCurLobbyGoldRate():int
		{
			var lid:int = StateGetPlayerInfo.Instance.lastSuccData.player.lid;
			if(lid != 0)
			{
				var obj:Object = lastSuccData;
				for(var i:int=0; i<obj.length;i++)
				{
					if(lid == obj[i].lid)
					{
						return int(obj[i].goldratelimit);
					}
				}
				return 1;
			}
			else
				return 1;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobyAddress + LobyNetManager.URL_roomInfo;
			LobyNetManager.Instance.httpservice.request = {};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// compare obj with old one
				if(!compare(lastSuccData, obj))
				{
					LobyManager.Instance.LobyTreeCtrl(obj);
				}
				// 继续请求玩家信息
				StateGetPlayerInfo.Instance.setType(0);
				LobyNetManager.Instance.send(LobyNetManager.playerInfo);
				
				return true;
			}
			else{
				// if false
				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				return false;
			}
			
		}
		private function compare(v1:Object, v2:Object):Boolean
		{
			if(v1.length != v2.length)
				return false;
				
			for(var i:int=0;i<v1.length;i++)
			{
				if(v1[i].name != v2[i].name)
					return false;
				if(v1[i].lid != v2[i].name)
					return false;
				if(v1[i].parent != v2[i].parent)
					return false;
				if(v1[i].address != v2[i].address)
					return false;
				if(v1[i].type != v2[i].type)
					return false;
			}
			return true;
		}
		override public function fault(event:Event):void
		{
			
		}
	}
}