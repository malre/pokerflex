package lobystate
{
	import mx.core.FlexGlobals;

	public class StateGetTableInfo extends NetRequestState
	{
		private static var instance:StateGetTableInfo = null;
		
		public function StateGetTableInfo()
		{
			super();
		}

		public static function get Instance():StateGetTableInfo
		{
			if(instance == null)
				instance = new StateGetTableInfo();
			return instance;
		}
		
		// override function
		override public function send(obj:StateManager):void
		{
			LobyNetManager.Instance.httpservice.url = FlexGlobals.topLevelApplication.gameTreeView.selectedItem.@address + LobyNetManager.URL_tableInfo;
			LobyNetManager.Instance.httpservice.send();
		}
		override public function receive(obj:Object):void
		{
			if(LobyManager.Instance.RoomTableDraw(obj))
			{
				// 对得到的table数据进行分析和描画，并跳转
				//FlexGlobals.topLevelApplication.currentState = "GameRoom";
				FlexGlobals.topLevelApplication.customcomponent21.currentState='State2';
				FlexGlobals.topLevelApplication.customcomponent31.currentState='State3';
				FlexGlobals.topLevelApplication.customcomponent0.currentState='State1';
				// make tree invisible
				FlexGlobals.topLevelApplication.gameTreeView.visible = false;
			}
		}
	}
}