package lobystate
{
	import mx.collections.ArrayCollection;

	public class StateUpdateInvite extends NetRequestState
	{
		private static var instance:StateUpdateInvite = null;
		[Bindable]
		public var invitation:ArrayCollection = new ArrayCollection();

		public function StateUpdateInvite()
		{
			super();
		}

		public static function get Instance():StateUpdateInvite
		{
			if(instance == null)
				instance = new StateUpdateInvite();
			return instance;
		}

		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.lobbyUpdater.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_getInviteList;
			LobyNetManager.Instance.lobbyUpdater.request = {};
			LobyNetManager.Instance.lobbyUpdater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				var data:Object;
				for(var i:int=0; i<obj.length; i++){
					data = new Object();
					data.text = obj[i].name+"邀请你去"+obj[i].lname+obj[i].rname+"参加游戏";
					invitation.addItem(data);
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault():void
		{
		}
	}
}