package
{
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Button;
	import mx.controls.Image;
	import mx.controls.Label;
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
		private var roomTableRowMax:int = 4;
		private var roomTableColumnMax:int = 3;
		
		// 房间里面桌子的总数
		private var tableTotal:int = 0;
		
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
		
		// 当结构树被点击的时候，进行子节点的构造
		public function LobyTreeItemClick(event:ListEvent):void
		{
			// 如果这次请求是点开数，才处理，关闭树不进行处理
			if(FlexGlobals.topLevelApplication.GameListTree.isItemOpen(FlexGlobals.topLevelApplication.GameListTree.selectedItem))
				return;
				
			var obj:Object = FlexGlobals.topLevelApplication.GameListTree.selectedItem;
			if(obj != null)
			{
				if(obj.@label == "游戏大厅")
				{
					// do nothings
				}
				else if(obj.@label == "双扣")
				{
					// 首先请求实际连接的大厅的地址,成功以后才能继续请求房间的信息
					LobyNetManager.Instance.send(LobyNetManager.getlobyaddress);
				}
				else if(obj.@label == "")
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
		public function RoomTableDraw(obj:Object):Boolean
		{
			// 如果这个数组没有成员，直接返回
			if(obj.length <= 0)
				return false;
			
			var canvas:Canvas = FlexGlobals.topLevelApplication.gameRoomCanvas;
			var i:int,j:int;
			// 本次更新得到的数据比上一次的要少，要删除部分显示的桌子
			if(obj.length <= tableTotal)
			{
				// 删除多余的桌子
				for(i=obj.length;i<tableTotal;i++)
				{
					canvas.removeChild(canvas.getChildByName("table"+i.toString()));
					canvas.removeChild(canvas.getChildByName("tag"+i.toString()));
					canvas.removeChild(canvas.getChildByName("up"+i.toString()));
					canvas.removeChild(canvas.getChildByName("left"+i.toString()));
					canvas.removeChild(canvas.getChildByName("down"+i.toString()));
					canvas.removeChild(canvas.getChildByName("right"+i.toString()));
				}
				tableTotal = obj.length;
			}
			else	// 这次的数据比上次的多，也包括了第一次的情况，需要动态的增加桌子的数量
			{
				for(i =tableTotal/roomTableColumnMax; i<roomTableRowMax; i++)
				{
					for(j =tableTotal%roomTableRowMax; j<roomTableColumnMax; j++)
					{
						// 如果超出了界限，直接返回
						if(i*roomTableColumnMax+j >= obj.length)
						{
							tableTotal = obj.length;
							return true;
						}
							
						var id:int = i*roomTableColumnMax +j;
						var roomid:int = obj[id].rid;
						var img:Image = new Image();
						img.x = tableStartX + (intervalX+51)*j;
						img.y = tableStartY + (intervalY+52)*i;
						img.load(ResourceManager.imgTable);
						img.name = "table"+id.toString();
						canvas.addChild(img);
						
						// 桌子上的桌号
						var label:Label = new Label();
						if((id+1) >= 10)
						{
							label.x = img.x+1;
						}
						else
						{
							label.x = img.x +12;
						}
						label.y = img.y ;
						label.text = (id+1).toString();
						label.setStyle("fontSize", 40);
						label.setStyle("fontWeight", "bold");
						label.setStyle("color","#333333"); 
						label.name = "tag"+id.toString();
						canvas.addChild(label);
						
						// 创建按钮需要和实际的房间信息结合起来
						// 如果该位置有玩家存在，则无按钮，否则有按钮
						canvas.addChild(createTableBtn(id.toString(), "up"+id.toString(), img.x+10, img.y-40));
	
						canvas.addChild(createTableBtn(id.toString(), "left"+id.toString(), img.x-40, img.y+10));
	
						canvas.addChild(createTableBtn(id.toString(), "down"+id.toString(), img.x+10, img.y+52+10));
						
						canvas.addChild(createTableBtn(id.toString(), "right"+id.toString(), img.x+51+10, img.y+10));
					}
				}
			}
			tableTotal = obj.length;
			return true;
		}
		
		private function createTableBtn(id:String, name:String, x:int, y:int):Button
		{
			var btn:mx.controls.Button = new mx.controls.Button();
			btn.x = x;
			btn.y = y;
			btn.id = id;
			btn.name = name;
//			btn.u
			btn.addEventListener(MouseEvent.CLICK, tableBtnHandler);
			btn.width = 30;
			btn.height = 30;
			btn.setStyle("cornerRadius", 13);
			btn.setStyle("borderColor", "#445c95");
			return btn;
		}
		
		// 当桌子上的座位被点击了以后，会发出加入游戏的请求。
		private function tableBtnHandler(event:MouseEvent):void
		{
			if(event.target.id == 0 && event.target.name == "up")
			{
				Alert.show("id = 0","");
			}
			// 向服务器发出加入一张桌子的请求
			LobyNetManager.Instance.send(LobyNetManager.joinTable, event.target.id, event.target.name);
		}
	}
}