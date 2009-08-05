package
{
	import mx.controls.LinkBar;
	import mx.core.FlexGlobals;
	import mx.events.ListEvent;

	// 用来控制和管理大厅的数据
	public class LobyManager
	{
		private static var instance:LobyManager =null;
		
		static public function get Instance():LobyManager
		{
			if(instance == null)
				instance = new LobyManager();

			return instance;	
		}
		
		public function LobyManager()
		{
		}
		
		// 控制树形结构内的显示
		public function LobyTreeCtrl():void
		{
			
		}
		public function LobyTreeItemClick(event:ListEvent):void
		{
			var newnode:XML = <node/>;
			newnode.@label = "room1";
		 	var xmllist:XMLList = FlexGlobals.topLevelApplication.treeData.node.(@label == "双扣");
		 	xmllist.appendChild(newnode);
		 	
		 	// 增加标签页一个，内容是双扣，或者也可能是其他游戏
		 	var link:LinkBar = FlexGlobals.topLevelApplication.GameHallLinkbar;
		 	//link.
		}
	}
}