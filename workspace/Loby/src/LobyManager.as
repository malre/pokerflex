package
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.events.ListEvent;

	// 用来控制和管理大厅的数据
	public class LobyManager
	{
		private static var instance:LobyManager =null;
		// 房间里面的桌子的描画控制
		private var tableStartX:int = 50;
		private var tableStartY:int = 60;
		private var intervalX:int = 110;
		private var intervalY:int = 110;
		private var roomTableMax:int = 20;
		private var roomTableRawMax:int = 4;
		private var roomTableColumnMax:int = 3;
		
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
			var obj:Object = FlexGlobals.topLevelApplication.GameListTree.selectedItem;
			if(obj != null)
			{
				if(obj.@label == "游戏大厅")
				{
					// do nothings
				}
				else if(obj.@label == "双扣")
				{
				 	var xmllist:XMLList = FlexGlobals.topLevelApplication.treeData.node.(@label == "双扣");
				 	if(xmllist.length() > 0)
				 	{
				 		for(var i:int=0;i<10;i++)
				 		{
				 			var newnode:XML = <node/>;
							newnode.@label = "房间"+(i+1).toString();
							newnode.@id = i;
				 			xmllist.appendChild(newnode);
				 		}
				 	}
				}
				else		
				{
					// 加入了一个房间，更新标签页
				 	// 增加标签页一个，内容是双扣，或者也可能是其他游戏
				 	TabBarChange(obj);
				}
			}
		}
		
		//
		public function TabBarChange(obj:Object):void
		{
			var id:int = obj.@id;
			var newCanvas:Canvas = new Canvas();
			newCanvas.label = "房间"+id.toString();
			FlexGlobals.topLevelApplication.gameViewStack.addChild(newCanvas);
			// send request
			LobyNetManager.Instance.send(LobyNetManager.roomInfo);					
//				var newCanvas:Canvas = new Canvas();
//				newCanvas.label = "Room 1";
//				gameViewStack.addChild(newCanvas);
//								<mx:Canvas width="100%" height="100%" label="双扣">
//					</mx:Canvas>
//					<mx:Canvas width="100%" height="100%" label="房间">
//					</mx:Canvas>

			}
		
		// 当在房间里面的时候，描画房间里面的桌子
		public function RoomTableDraw():void
		{
			var canvas:Canvas = FlexGlobals.topLevelApplication.gameRoomCanvas;
			for(var i:int =0; i<roomTableRawMax; i++)
			{
				for(var j:int =0; j<roomTableColumnMax; j++)
				{
					var img:Image = new Image();
					img.x = tableStartX + (intervalX+51)*j;
					img.y = tableStartY + (intervalY+52)*i;
					img.load(ResourceManager.imgTable);
					canvas.addChild(img);
					
					// 创建按钮需要和实际的房间信息结合起来
					// 如果该位置有玩家存在，则无按钮，否则有按钮
					var id:int = i*roomTableColumnMax +j;
					canvas.addChild(createRoomBtn(id.toString(), "up", img.x+10, img.y-40));

					canvas.addChild(createRoomBtn(id.toString(), "left", img.x-40, img.y+10));

					canvas.addChild(createRoomBtn(id.toString(), "down", img.x+10, img.y+52+10));
					
					canvas.addChild(createRoomBtn(id.toString(), "right", img.x+51+10, img.y+10));
				}
			}
		}
		private function createRoomBtn(id:String, name:String, x:int, y:int):Button
		{
			var btn:mx.controls.Button = new mx.controls.Button();
			btn.x = x;
			btn.y = y;
			btn.id = id;
			btn.name = name;
			btn.addEventListener(MouseEvent.CLICK, roomBtnHandler);
			btn.width = 30;
			btn.height = 30;
			btn.setStyle("cornerRadius", 13);
			btn.setStyle("borderColor", "#445c95");
			return btn;
		}
		
		private function roomBtnHandler(event:MouseEvent):void
		{
			if(event.target.id == 0 && event.target.name == "up")
			{
				Alert.show("id = 0","");
			}
		}
	}
}