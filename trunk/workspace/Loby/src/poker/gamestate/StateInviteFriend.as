package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	import flash.events.Event;
	import poker.NetManager;
	
	public class StateInviteFriend extends NetRequestState
	{
		private static var instance:StateInviteFriend = null;
		private var pid:int;

		public function StateInviteFriend()
		{
			super();
		}
		
		public static function get Instance():StateInviteFriend
		{
			if(instance == null)
				instance = new StateInviteFriend();
			return instance;
		}
		public function setInvitePid(val:int):void
		{
			pid = val;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_inviteFriend;
			NetManager.sender.request = {"pid":pid};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.friendslist.showMsg("发送邀请成功");
				return true;
			}
			else{
				// if false
//				LobyErrorState.Instance.errorId = LobyErrorState.ERR_NOTLOGIN;
				FlexGlobals.topLevelApplication.friendslist.btnInvite.enabled = true;
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			FlexGlobals.topLevelApplication.friendslist.showMsg("发送邀请失败");
		}
	}
}