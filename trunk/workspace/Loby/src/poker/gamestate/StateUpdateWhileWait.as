package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	
	import poker.Game;
	import poker.NetManager;
	import poker.poker;
	
	import soundcontrol.SoundManager;

	public class StateUpdateWhileWait extends NetRequestState
	{
		private static var instance:StateUpdateWhileWait = null;

		public function StateUpdateWhileWait()
		{
			super();
		}
		public static function get Instance():StateUpdateWhileWait
		{
			if(instance == null)
				instance = new StateUpdateWhileWait();
			return instance;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.updater.url = NetManager.sendURL_game;
			NetManager.updater.request = {getPlayers:"true"};
			NetManager.updater.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(obj.hasOwnProperty("success"))
			{
				if(!obj.success)
				{
					lastFlag = false;
					if(obj.hasOwnProperty("error"))
					{
//						if(obj.error.hasOwnProperty("message")){
//							LobyErrorState.Instance.showErrMsg(obj.error.message);
//						}
					}
				}
				else
				{
					lastSuccData = obj;
					lastFlag = true;
				}
			}
			if(lastFlag)
			{
				// 链接成功，但游戏尚未开始
				if(obj.status == 0)
				{
					// 进入游戏逻辑，先转到游戏之前的状态，来获得一帧牌的数据，然后再跳转到正式的游戏中
					NetManager.Instance.send(NetManager.send_updateWhileGameFirstframe);
					Game.Instance.gameState = 4;
					// 播放准备完成音效 
					SoundManager.Instance().playSE("start");
					
					// 将准备按钮隐藏
					FlexGlobals.topLevelApplication.gamePoker.btnReady.visible = false;
					// 消去对玩家操作的命令菜单
					var p:poker = FlexGlobals.topLevelApplication.gamePoker as poker;
					if(p.gameMenu != null)
					{
						p.removeElement(p.gameMenu);
						p.gameMenu = null;
					}
				}
				else
				{
					// 继续等待其他玩家
					Game.Instance.getSelfseat(obj);
					// 更新其他玩家的名字和状态
					Game.Instance.updatePlayerName(obj);
					Game.Instance.updatePlayerReadyState(obj);
					// 更新右侧其他玩家的数据表格
					Game.Instance.playersDatagridFill(obj);
				}
				return true;
			}
			else{
				// 判断自己有没有被踢
				if(obj.kicked)
				{
					// 使游戏本体不见，并回到游戏房间，刷新房间
					FlexGlobals.topLevelApplication.gamePoker.endup();
					// 回到游戏
					LobyManager.Instance.changeState(1);
					// 退出的时候同时清除房间的聊天信息
					FlexGlobals.topLevelApplication.gamePoker.gamechatbox.selectAll();
					FlexGlobals.topLevelApplication.gamePoker.gamechatbox.insertText("");
					// 重置房间设置获得标志位，下一次进房间需要重新去访问
					StateGetTableSetting.Instance.getSettingSuccess = false;
					// 关闭所有的窗口并置窗口互斥量为假
					FlexGlobals.topLevelApplication.gamePoker.optionWindow.closeOption();
					FlexGlobals.topLevelApplication.friendslist.toState(0);
					// 如果退出成功，回前一张桌子的按钮有效
					FlexGlobals.topLevelApplication.btn2LastTable.enabled = true;
					///
					Alert.show("","你被踢出了房间");
				}
				return false;
			}
		}
		override public function fault(event:Event):void
		{
			// 如果此次发送超时， 同样的内容将会被重发
			NetManager.Instance.send(NetManager.send_updateWhileWait);
		}
	}
}