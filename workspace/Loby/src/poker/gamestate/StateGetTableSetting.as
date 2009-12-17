package poker.gamestate
{
	import components.OptionWindow;
	
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;
	
	public class StateGetTableSetting extends NetRequestState
	{
		private static var instance:StateGetTableSetting = null;
		private var _getSettingSuccess:Boolean = false;

		public function set getSettingSuccess(val:Boolean):void
		{
			_getSettingSuccess = val;
		}

		public function get getSettingSuccess():Boolean
		{
			return _getSettingSuccess;
		}

		public static function get Instance():StateGetTableSetting
		{
			if(instance == null)
				instance = new StateGetTableSetting();
			return instance;
		}

		public function StateGetTableSetting()
		{
			super();
			_getSettingSuccess = false;
		}

		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_tableSetting;
			NetManager.sender.request = {};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				setData(obj);
				_getSettingSuccess = true;
				return true;
			}
			else{
				_getSettingSuccess = false;
				return false;
			}
		}
		override public function fault(event:Event):void
		{
		}
		
		// 对设置信息窗口进行信息填充，并且把它显示出来
		public function setData(obj:Object):void
		{
			var op:OptionWindow = FlexGlobals.topLevelApplication.gamePoker.optionWindow;
			op.visible = true;
			op.inGameSetting(obj);
			
			// mutex
			LobyManager.Instance.windowMutex = true;
		}
	}
}