package poker.gamestate
{
	import components.OptionWindow;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
	
	import poker.NetManager;
	
	public class StateGetTableSetting extends NetRequestState
	{
		private static var instance:StateGetTableSetting = null;
		private var _getSettingSuccess:Boolean = false;

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
		override public function fault():void
		{
		}
		
		// 对设置信息窗口进行信息填充，并且把它显示出来
		public function setData(obj:Object):void
		{
			var op:OptionWindow = FlexGlobals.topLevelApplication.gamePoker.optionWindow;
			op.visible = true;
			
			// 对所有的选项进行设置
			if(obj.hasOwnProperty("password")) {
				op.checkboxPassword.selected = true;
				op.inputboxPassword.text = "********";
			}else{
				op.checkboxPassword.selected = false;
			}
			op.checkboxPassword.enabled = false;
			op.inputboxPassword.enabled = false;
			
			if(obj.hasOwnProperty("lowerlevellimit")) {
				op.lowlevel.selectedIndex = obj.lowerlevellimit;
			}else{
				op.lowlevel.selectedIndex = 0;
			}
			op.lowlevel.enabled = false;
			
			if(obj.hasOwnProperty("upperlevellimit")) {
				op.highlevel.selectedIndex = obj.upperlevellimit;
			}else{
				op.highlevel.selectedIndex = 0;
			}
			op.highlevel.enabled = false;
			
			if(obj.hasOwnProperty("magnification")) {
				op.checkboxAllowGold.selected = true;
				op.goldplus.selectedIndex = obj.magnification;
			}else{
				op.checkboxAllowGold.selected = false;
				op.goldplus.selectedIndex = 0;
			}
			op.checkboxAllowGold.enabled = false;
			op.goldplus.enabled = false;
			
			if(obj.hasOwnProperty("allowchat")) {
				op.checkboxAllowChat.selected = obj.allowchat;
			}else{
				op.checkboxAllowChat.selected = false;
			}
			op.checkboxAllowChat.enabled = false;
			
			if(FlexGlobals.topLevelApplication.gamePoker.optionWindow.currentState != "State2")
				FlexGlobals.topLevelApplication.gamePoker.optionWindow.currentState = "State2";
		}
	}
}