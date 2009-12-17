package lobystate
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.core.FlexGlobals;
	
	import poker.LevelDefine;
	
	public class StateUpdateRoomPlayerlist extends NetRequestState
	{
		private static var instance:StateUpdateRoomPlayerlist = null;
		
		public function StateUpdateRoomPlayerlist()
		{
			super();
		}
		
		public static function get Instance():StateUpdateRoomPlayerlist
		{
			if(instance == null)
				instance = new StateUpdateRoomPlayerlist();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.lobbyUpdater.url = LobyNetManager.URL_lobysonAddress + LobyNetManager.URL_roomPlayerlist;
			LobyNetManager.Instance.lobbyUpdater.request = {};
			LobyNetManager.Instance.lobbyUpdater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				// 获得与大厅房间列表绑定的数据表
				var roomlist:ArrayCollection = StateGetRoomPlayerlist.Instance.roomlist;
				// 获得得分序列中，本大厅游戏的正确位置
				var gid:int = StateGetTableInfo.Instance.gameRoomGid;
				for(var m:int=0;m<roomlist.length;m++)
				{
					var player:Object = roomlist[m];
					var flag:Boolean = false;
					for(var i:int=0;i<obj.players.length;i++){
						if(player.name == obj.players[i].name){
							flag = true;
							player.money = obj.players[i].money;
							for(var j:int=0; j<obj.players[i].score.length; j++){
								if(obj.players[i].score[j].id == gid){
									player.score = obj.players[i].score[j].score;
									break;
								}
							}
							player.level = LevelDefine.getLevelName(player.score);
							// destory this player
							obj.players[i].name = "";
							break;
						}
					}
					if(flag)
					{
						
					}else {
//						roomlist.removeItemAt(roomlist.getItemIndex(player));
						roomlist.removeItemAt(m);
						m--;
					}
				}
				for each(var leftplayer:Object in obj.players)
				{
					if(leftplayer.name != "")
					{
						var playerdata:Object = new Object();
						playerdata.name = leftplayer.name;
						for(var k:int=0; k<leftplayer.score.length; k++){
							if(leftplayer.score[k].id == gid){
								playerdata.score = leftplayer.score[k].score;
								break;
							}
						}
						playerdata.money = leftplayer.money;
						playerdata.level = LevelDefine.getLevelName(playerdata.score);
						roomlist.addItem(playerdata);
					}
				}
				// 更新大厅的玩家数据列表
				FlexGlobals.topLevelApplication.functionpanel.lobbyplayerlist.invalidateList();
				
				// 继续进入游戏的请求， 请求一次当时离开的房间的信息
				LobyNetManager.Instance.update(LobyNetManager.updateInvitelist);
				
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