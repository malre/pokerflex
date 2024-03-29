package lobystate
{
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

	public class StateGetFriends extends NetRequestState
	{
		private static var instance:StateGetFriends = null;
		private var type:int;
		[Bindable]
		public var friends:ArrayCollection = new ArrayCollection();

		public function StateGetFriends()
		{
			super();
		}

		public static function get Instance():StateGetFriends
		{
			if(instance == null)
				instance = new StateGetFriends();
			return instance;
		}

		// 请求的种类，游戏中还是大厅中，   0：大厅，  1：游戏
		public function settype(val:int):void
		{
			this.type = val;
		}
		override public function send(obj:StateManager):void
		{
			// 显示进行过程
			LobyNetManager.Instance.showNetProcess("获得玩家好友数据中……");

			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getFriends;
			LobyNetManager.Instance.httpservice.request = {}; 
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.friendslist.toState(2+type);
				friends.source = obj.friends as Array;
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return true;
			}
			else{
//				LobyErrorState.Instance.showErrMsg("获得好友列表失败，请关闭后再次尝试。您可能还没有好友。");
				// 关闭显示视窗
				LobyNetManager.Instance.closeNetProcess();
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			LobyErrorState.Instance.showErrMsg("失败，超时。");
			// 关闭显示视窗
			LobyNetManager.Instance.closeNetProcess();
		}
	}
}