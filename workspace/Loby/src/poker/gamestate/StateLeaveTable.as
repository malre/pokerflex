package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
	import mx.rpc.events.FaultEvent;
	
	import poker.Game;
	import poker.NetManager;
	
	public class StateLeaveTable extends NetRequestState
	{
		private static var instance:StateLeaveTable = null;
		private var param:Boolean;

		public function StateLeaveTable()
		{
			super();
		}

		public static function get Instance():StateLeaveTable
		{
			if(instance == null)
				instance = new StateLeaveTable();
			return instance;
		}
		public function exitWithoutConfirm(val:Boolean):void
		{
			param = val;
		}
		// override function
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_leave;
			if(param)
			{
				NetManager.sender.request = {"confirmed":true};
			}
			else{
				NetManager.sender.request = {};
			}
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("success"))
			{
				if(!obj.success)
				{
					lastFlag = false;
				}
				else{
					lastSuccData = obj;
					lastFlag = true;
				}
			}

			if(lastFlag)
			{
				param = false;

    			// 使游戏本体不见，并回到游戏房间，刷新房间
    			FlexGlobals.topLevelApplication.gamePoker.endup();
    			// 回到游戏
    			LobyManager.Instance.changeState(1);
    			// 退出的时候同时清除房间的聊天信息
    			FlexGlobals.topLevelApplication.gamePoker.gamechatbox.selectAll();
				FlexGlobals.topLevelApplication.gamePoker.gamechatbox.insertText("");
//				// 退出时清空玩家数据表
//				Game.Instance.tablelist.removeAll();
				// 重置房间设置获得标志位，下一次进房间需要重新去访问
				StateGetTableSetting.Instance.getSettingSuccess = false;
				// 关闭所有的窗口并置窗口互斥量为假
				FlexGlobals.topLevelApplication.gamePoker.optionWindow.closeOption();
				FlexGlobals.topLevelApplication.friendslist.toState(0);
				// 如果退出成功，回前一张桌子的按钮有效
				FlexGlobals.topLevelApplication.btn2LastTable.enabled = true;
				return true;
			}
			else{
				if(obj.error.code == "25")	// 游戏已经开始，需要确认
				{
					Alert.show("请确认","游戏已经开始，确认退出吗？游戏中退出会被扣分。",Alert.YES|Alert.NO, null, alertClickHandler);
				}
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			var fe:FaultEvent = FaultEvent(event);
			NetManager.Instance.send(NetManager.send_leave);
		}
		
		private function alertClickHandler(event:CloseEvent):void
		{
			if(event.detail == Alert.YES){
				exitWithoutConfirm(true);
				NetManager.Instance.send(NetManager.send_leave);            
			}
			else{
				
			}
		}
	}
}