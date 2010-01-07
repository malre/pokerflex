package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;
	
	public class StateGetAllFriends extends NetRequestState
	{
		private static var instance:StateGetAllFriends = null;
		private var type:int;
		
		public function StateGetAllFriends()
		{
			super();
		}
		
		public static function get Instance():StateGetAllFriends
		{
			if(instance == null)
				instance = new StateGetAllFriends();
			return instance;
		}
		
		// 请求的种类，游戏中还是大厅中，   0：大厅，  1：游戏
		public function settype(val:int):void
		{
			this.type = val;
		}
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getAllFriends;
			LobyNetManager.Instance.httpservice.request = {}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.friendslist.toState(2+type);
				StateGetFriends.Instance.friends.source = obj.friends as Array;
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			LobyErrorState.Instance.showErrMsg("失败，超时。");
		}
	}
}