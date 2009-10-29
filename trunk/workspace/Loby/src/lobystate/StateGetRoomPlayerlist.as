package lobystate
{
	import mx.collections.ArrayCollection;

	public class StateGetRoomPlayerlist extends NetRequestState
	{
		private static var instance:StateGetRoomPlayerlist = null;
		//
		[Bindable]
		public var roomlist:ArrayCollection = new ArrayCollection();

		public function StateGetRoomPlayerlist()
		{
			super();
		}

		public static function get Instance():StateGetRoomPlayerlist
		{
			if(instance == null)
				instance = new StateGetRoomPlayerlist();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_roomPlayerlist;
			LobyNetManager.Instance.httpservice.request = {};
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				roomlist.removeAll();
				for(var i:int=0;i<obj.players.length;i++)
					roomlist.addItem(obj.players[i]);

				// 继续对游戏的恢复
				if(LobyManager.Instance.state == 4)
				{
					// 继续进入游戏的请求， 请求一次当时离开的房间的信息
					LobyNetManager.Instance.send(LobyNetManager.getTablePlayerInfo);
					//LobyManager.Instance.gamePoker.startup(obj);
					// 
					//LobyManager.Instance.changeState(2);
					//return true;
					//LobyManager.Instance.changeState(1);
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