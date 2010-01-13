package poker.gamestate
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;
	import poker.poker;
	import poker.timeoutDealwithGUI;
	import soundcontrol.SoundManager;
	
	public class StateGetScore extends NetRequestState
	{
		private static var instance:StateGetScore = null;
		private var timer:Timer = new Timer(1000);
		
		public function StateGetScore()
		{
			super();
			timer.addEventListener(TimerEvent.TIMER, animationOver);
		}
		public static function get Instance():StateGetScore
		{
			if(instance == null)
				instance = new StateGetScore();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.requestTimeout = 3000;
			NetManager.sender.request = {"getScore":"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				if(!obj.hasOwnProperty("score"))
					return false;
				//
				SoundManager.Instance().playSE("win");
				if(obj.score.hasOwnProperty("result"))
				{
					var pok:poker = poker(FlexGlobals.topLevelApplication.gamePoker);
					// 播放游戏结束动画
					if(obj.score.result == "0"){			// 平扣
						var es0:donghuapingkou = new donghuapingkou();
						es0.name = "endAnimation";
						es0.x = -191;
						es0.y = 244;
						pok.addElement(es0);
						es0.play();
						timer.start();
					}
					else if(obj.score.result == "1"){		// 单扣
						var es1:donghuadankou = new donghuadankou();
						es1.name = "endAnimation";
						es1.x = -180;
						es1.y = 247;
						pok.addElement(es1);
						es1.play();
						timer.start();
					}
					else if(obj.score.result == "2"){		// 双扣
						var es2:donghuashuangkou = new donghuashuangkou();
						es2.name = "endAnimation";
						es2.x = 175;
						es2.y = 237;
						pok.addElement(es2);
						es2.play();
						timer.start();
					}
					else
					{
						
					}
					
				}
				else	// 意外的结束，不显示动画
				{
					FlexGlobals.topLevelApplication.gamePoker.showPopupDlg(obj);
				}
				
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
			if(++timeoutCounter > timeoutCounterMax)
			{
				timeoutDealwithGUI.Instance.deal(timeoutDealwithGUI.getPlayerScore);
			}else{
				NetManager.Instance.send(NetManager.send_getScore);
			}
		}
		
		protected function animationOver(event:TimerEvent):void
		{
			var pok:poker = poker(FlexGlobals.topLevelApplication.gamePoker);
			if(lastSuccData.score.result == "0"){
				var es0:donghuapingkou = donghuapingkou(pok.getChildByName("endAnimation"));
				if(es0.currentFrame >= es0.totalFrames)
				{
					pok.removeElement(es0);
					pok.showPopupDlg(lastSuccData);
					timer.stop();
				}
			}
			else if(lastSuccData.score.result == "1"){
				var es1:donghuadankou = donghuadankou(pok.getChildByName("endAnimation"));
				if(es1.currentFrame >= es1.totalFrames)
				{
					pok.removeElement(es1);
					pok.showPopupDlg(lastSuccData);
					timer.stop();
				}
			}
			else if(lastSuccData.score.result == "2"){
				var es2:donghuashuangkou = donghuashuangkou(pok.getChildByName("endAnimation"));
				if(es2.currentFrame >= es2.totalFrames)
				{
					pok.removeElement(es2);
					pok.showPopupDlg(lastSuccData);
					timer.stop();
				}
			}
		}
	}
}