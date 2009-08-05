package
{
	import mx.containers.Canvas;
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
			newnode.@label = "双扣";
		 	//var xmllist:XMLList = FlexGlobals.topLevelApplication.treeData.node.(@label == "游戏大厅");
		 	//if(xmllist.length() > 0)
		 	//{
		 	//	xmllist.appendChild(newnode);
		 	//}
		 	
		 	// 增加标签页一个，内容是双扣，或者也可能是其他游戏
		 	TabBarChange();

		}
		
		public function TabBarChange():void
		{
			var obj:Object = FlexGlobals.topLevelApplication.GameListTree.selectedItem;
			if(obj != null)
			{
				if(obj.@label == "游戏大厅")
				{
				}
				else if(obj.@label == "双扣")
				{
					var newCanvas:Canvas = new Canvas();
					newCanvas.label = "room1";
					FlexGlobals.topLevelApplication.gameViewStack.addChild(newCanvas);					
				}
//				var newCanvas:Canvas = new Canvas();
//				newCanvas.label = "Room 1";
//				gameViewStack.addChild(newCanvas);
//								<mx:Canvas width="100%" height="100%" label="双扣">
//					</mx:Canvas>
//					<mx:Canvas width="100%" height="100%" label="房间">
//					</mx:Canvas>

			}
		}
	}
}