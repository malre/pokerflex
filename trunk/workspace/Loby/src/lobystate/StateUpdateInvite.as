package lobystate
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;

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
		
		public function getRefuselist():Array
		{
			var arr:Array = new Array();
			for(var i:int=0;i<invitation.length;i++){
				arr.push(invitation[i].pid);
			}
			return arr;
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
				var data:Array = new Array();
				var joinData:Object;
				for(var i:int=0; i<obj.length; i++){
					joinData = obj[i];
					joinData.text = obj[i].name+"邀请你去"+obj[i].lname+obj[i].rname+"参加游戏";
					data.push( joinData );
					
				}
				invitation.source = data;
				
				//
				if(data.length != 0){
					FlexGlobals.topLevelApplication.invitation.visible = true;
				}
				return true;
			}
			else{
				return false;
			}
		}
		override public function fault(event:Event):void
		{
		}
	}
}