package lobystate
{
	import flash.events.Event;
	
	import mx.core.FlexGlobals;

	public class StateRefuseInvitation extends NetRequestState
	{
		private static var instance:StateRefuseInvitation = null;
		private var refusePidArray:Array = new Array();

		public function StateRefuseInvitation()
		{
			super();
		}

		public static function get Instance():StateRefuseInvitation
		{
			if(instance == null)
				instance = new StateRefuseInvitation();
			return instance;
		}
		public function setRefuselist(arr:Array):void
		{
			refusePidArray = arr.concat();
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			var refuselist:String = refusePidArray.toString();
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_refuseInvite;
			LobyNetManager.Instance.httpservice.request = {"pidlist":refuselist};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				FlexGlobals.topLevelApplication.invitation.close();
				return true;
			}
			else{
				FlexGlobals.topLevelApplication.invitation.showmsg("拒绝失败，请重新尝试");
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			FlexGlobals.topLevelApplication.invitation.showmsg();
		}
	}
}