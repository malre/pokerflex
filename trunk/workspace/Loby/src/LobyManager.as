package
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	import json.JSON;
	
	import lobystate.StateGetPlayerInfo;
	import lobystate.StateGetTableInfo;
	import lobystate.StateJoinLoby;
	
	import message.Messenger;
	
	import mx.containers.Canvas;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;
	import mx.events.ListEvent;
	
	import poker.*;

	// 用来控制和管理大厅的数据
	public class LobyManager
	{
		private static var instance:LobyManager =null;
		// 房间里面的桌子的描画控制
		private const tableStartX:int = 45;
		private const tableStartY:int = 55;
		private const intervalX:int = 100;
		private const intervalY:int = 80;
		private const roomTableMax:int = 20;
		private const roomTableRowMax:int = 7;
		private const roomTableColumnMax:int = 3;
		private const tableAvatarSize:int = 29;
		
		// 房间里面桌子的总数
		private var tableTotal:int = 0;
		
		// 主状态，用来控制大厅的运作
		// STATE  0 空状态
		// 1 大厅正常
		// 2 游戏中
		// 3 restore 当上次是意外中断的时候，该状态用来恢复上次的，自动运行到最后的指定状态，
		// 回到指定的大厅
		// 4 restore
		// 回到指定的游戏 
		// 5 前往收到邀请的大厅房间
		// 6 大厅的转换
		private var _state:int = 0;
			// 恢复用记录玩家信息
			public var playerInfo:Object = new Object();
		// 大厅更新时间
		private var freshTime:int = 10;		
		private var freshCount:int = 0;
		private var lastFrameTime:Date = new Date();
		// 公告显示部分的参数
		private const looptimesdefine:int = 2;
		private var looptimes:int = looptimesdefine;
		private var curAnnounce:String;
		public var isAnnouncePlaying:Boolean = false;
		
		////////////// 主画面显示元素用数据
		[Bindable]
		private var treeData:XML = <node name="游戏大厅" lid="-1" parent="-1" address="" type="0"/>
		public function get TreeData():XML
		{
			return treeData;
		}
		
		// 双扣游戏的本体
//		public var gamePoker:poker;
		// 游戏主界面上的窗口的mutex，用来控制所有的窗口不能同时打开，或者部分的可以共存
		// 本来是可以用popup来完成这个要求，但是考虑到玩家可以一边创建一边进行聊天，所以采用手动的控制
		public var windowMutex:Boolean = false;
		
		//////////////////////////////////////////
		//子flash， game部分的被载入flash的管理
		public var isGameLoaded:Boolean = false;
		
		public function get state():int
		{
			return _state;
		}

		public function set state(v:int):void
		{
			_state = v;
		}

		static public function get Instance():LobyManager
		{
			if(instance == null)
				instance = new LobyManager();

			return instance;	
		}
		
		public function LobyManager()
		{
//			FlexGlobals.topLevelApplication.gameTreeView.labelField = "@name";
//			FlexGlobals.topLevelApplication.gameTreeView.dataProvider = treeData;
		}
		
		public function enterFrame():void
		{
			switch(state)
			{
				case 0:	// null
				break;
				case 1:	// normal
					// 进行间隔一定时间一次的大厅数据刷新
					var thisFrame:Date = new Date();
					var seconds:Number = (thisFrame.getTime() - lastFrameTime.getTime())/1000.0;
					if(seconds > freshTime)
					{
//						if(LobyNetManager.Instance.RequestEnable)
						{
							if(LobyErrorState.Instance.errorId > 0 && LobyErrorState.Instance.errorId <= 100)
								break;
								 
							// 当能请求的情况下，进行请求
							if(StateGetPlayerInfo.Instance.lastSuccData.player.lid != "null")
							{
								// 当有前台窗口在显示的时候，不进行请求
//								if(!LobyManager.Instance.windowMutex){
									LobyNetManager.Instance.update(LobyNetManager.updateRoomtable);
//								}
							}
//							else{
//								LobyNetManager.Instance.send(LobyNetManager.roomInfo);
//							}
							
			    			lastFrameTime = thisFrame;
			   			}
					}
					animateAnouncement();
				break;
				case 2:	// game
					animateAnouncement();
				break;
					// restore state
				case 3:
					// 请求房间信息，并自动进入房间
				break;
				case 4:
				break;
			}
		}
		public function changeState(state:int):void
		{
			if(state == 0)
			{
				_state = 0;
			}
			else if(state == 1)
			{
				if(_state == 3 || _state == 4)
				{
				}
				else{
					// 进行一次桌子数据的请求
					LobyNetManager.Instance.send(LobyNetManager.tableInfo);
				}
				_state = 1;
				// 在这里改变聊天消息
				Messenger.Instance.stopGame();
				Messenger.Instance.startLobby();
			}
			else if(state == 2)
			{
				_state = 2;
				// 在这里改变聊天消息，不再接收大厅的消息，改成桌子的消息
				Messenger.Instance.stopLobby();
				Messenger.Instance.startGame();
			}
			else if(state == 3)
			{
				_state = 3;
			}
			else if(state == 4)
			{
				_state = 4;
			}
			else if(state == 5)
			{
				_state = 5;
			}
		}
		
		// 控制树形结构内的显示
		public function LobyTreeCtrl(obj:Object):void
		{
			delete treeData.node;
			arr2xml(obj);
		}
		
		// 把数组数据变成xml数据，供tree结构使用
		private function arr2xml(obj:Object):void
		{
			for(var i:int=0;i<obj.length;i++)
			{
				var xml:XML = <node/>;
				xml.@name = obj[i].name;
				xml.@lid = obj[i].lid;
				xml.@parent = obj[i].parent;
				xml.@address = "http://"+obj[i].address;
				xml.@type = obj[i].type;
				
				// 根节点是否是要连接的点
				if(treeData.@lid == obj[i].parent)
				{
					treeData.appendChild(xml);
				}
				else{
					var node:XMLList = treeData..*.(@lid == obj[i].parent);
					// 这个地方是一个bug点，如果返回超过1个数据，会出错。
					node.appendChild(xml);
				}
import flash.display.Shape;

import spark.primitives.Graphic;

			}
		}
		
		// 当结构树被点击的时候，进行子节点的构造
		public function LobyTreeItemClick(event:ListEvent):void
		{
			FlexGlobals.topLevelApplication.gameTreeView.expandItem(FlexGlobals.topLevelApplication.gameTreeView.selectedItem, 
			!FlexGlobals.topLevelApplication.gameTreeView.isItemOpen(FlexGlobals.topLevelApplication.gameTreeView.selectedItem), true);
			
			// 如果这次请求是点开数，才处理，关闭树不进行处理
//			if(FlexGlobals.topLevelApplication.gameTreeView.isItemOpen(FlexGlobals.topLevelApplication.gameTreeView.selectedItem))
//				return;
				
			// 只有正常情况下的大厅登录点击才有效
			if(LobyManager.instance.state != 1)
				return;
			// 点击台面的标签以后，对该页面的内容进行请求，并清空之前的内容
			if(windowMutex && LobyNetManager.Instance.RequestEnable)
				return;
			
			var obj:Object = FlexGlobals.topLevelApplication.gameTreeView.selectedItem;
			if(obj != null)
			{
				if(obj.@type == "1")
				{
					//判断原来是否在房间中
					var rlt:int = ifPlayerInRoom(obj); 
					if( rlt == 0)
					{
						StateJoinLoby.Instance.setLobyAddress(obj.@address);
						StateJoinLoby.Instance.setLobyid(obj.@lid);
						LobyNetManager.Instance.send(LobyNetManager.addloby);
					}
					else if(rlt == 1){
						Alert.show("你已经在这个房间中了", "");					
					}
					else if(rlt == 2){
						// 首先讯问是否要离开房间
						Alert.show("加入一个新房间会退出您原来所在的房间，确定吗？", "", Alert.YES|Alert.NO, null/*Application(FlexGlobals.topLevelApplication)*/, alertClickHandler);
					}
				}
/*				else if(obj.@label == "")
				{
					// 加入了一个房间，更新标签页
				 	// 增加标签页一个，内容是双扣，或者也可能是其他游戏
				 	TabBarChange(obj);
				}
*/			}
		}
		private function alertClickHandler(event:CloseEvent):void{
			if(event.detail == Alert.YES){
				StateJoinLoby.Instance.setLobyAddress(FlexGlobals.topLevelApplication.gameTreeView.selectedItem.@address);
				StateJoinLoby.Instance.setLobyid(FlexGlobals.topLevelApplication.gameTreeView.selectedItem.@lid);
				LobyNetManager.Instance.send(LobyNetManager.leaveloby);
			}
			else{
			}
		}
		
		// 判断玩家是否在房间中，如果在
		private function ifPlayerInRoom(selRoom:Object):int
		{
			//var xmllist:XMLList = treeData..*.(@lid == playerInfo.player.lid);
			if(StateGetPlayerInfo.Instance.lastSuccData.player.lid == "null" || StateGetPlayerInfo.Instance.lastSuccData.player.lid == 0)
			{
				return 0;
			}
			else if(StateGetPlayerInfo.Instance.lastSuccData.player.lid == selRoom.@lid)
			{
				return 1;
			}
			else
				return 2;
		}
		
		// 成功加入游戏区，增加标签
		public function joinShuangkou():void
		{
			var newCanvas:Canvas = new Canvas();
			newCanvas.label = "双扣";
			FlexGlobals.topLevelApplication.gameViewStack.addChild(newCanvas);
			FlexGlobals.topLevelApplication.gameViewStack2.addChild(newCanvas);
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
		
		// 进入房间并更新房间内信息
		public function getintoRoom(obj:Object):void
		{
			// 对得到的table数据进行分析和描画，并跳转
			// 关闭左边的选择界面
			FlexGlobals.topLevelApplication.lobbypanel.currentState='State2';
			FlexGlobals.topLevelApplication.gameTreeView.visible = false;
			// 显示右边的信息和聊天面板
			FlexGlobals.topLevelApplication.functionpanel.currentState='State3';
			// 将说明文字关闭
			FlexGlobals.topLevelApplication.introduceText.visible = false;
			FlexGlobals.topLevelApplication.btn2lobby.visible = true;
			FlexGlobals.topLevelApplication.btn2room.visible = false;
			FlexGlobals.topLevelApplication.currentState = "room";
			RoomTableDraw(obj);
		}
		public function refreshRoom(obj:Object):void
		{
			RoomTableDraw(obj);
		}

		// 当在房间里面的时候，描画房间里面的桌子
		public function RoomTableDraw(obj:Object):Boolean
		{
			var canvas:Canvas = FlexGlobals.topLevelApplication.gameRoomCanvas;
			// 如果这个数组没有成员，直接返回
			if(obj.length <= 0)
			{
				canvas.removeAllChildren();
				return false;
			}
			
			canvas.removeAllChildren();
			var i:int,j:int;
			// 本次更新得到的数据比上一次的要少，要删除部分显示的桌子
/*			if(obj.length <= tableTotal)
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
					canvas.removeChild(canvas.getChildByName("avatarup"+i.toString()));
					canvas.removeChild(canvas.getChildByName("avatarleft"+i.toString()));
					canvas.removeChild(canvas.getChildByName("avatardown"+i.toString()));
					canvas.removeChild(canvas.getChildByName("avatarright"+i.toString()));
					canvas.removeChild(canvas.getChildByName("nameup"+i.toString()));
					canvas.removeChild(canvas.getChildByName("nameleft"+i.toString()));
					canvas.removeChild(canvas.getChildByName("namedown"+i.toString()));
					canvas.removeChild(canvas.getChildByName("nameright"+i.toString()));
				}
				tableTotal = obj.length;
			}
			else	// 这次的数据比上次的多，也包括了第一次的情况，需要动态的增加桌子的数量
			{*/
				for(i =0; i<roomTableRowMax; i++)
				{
					for(j =0; j<roomTableColumnMax; j++)
					{
						// 如果超出了界限，直接返回
						if(i*roomTableColumnMax+j >= obj.length)
						{
							tableTotal = obj.length;
							return true;
						}
							
						var id:int = i*roomTableColumnMax +j;
						// 如果是非可显示游戏桌，不显示
						if(obj[id].gid == -1)
							continue;
						var roomid:int = obj[id].rid;
						// 桌子的图
						var img:Image = new Image();
						img.x = tableStartX + (intervalX+51)*j;
						img.y = tableStartY + (intervalY+52)*i;
						img.load(ResourceManager.imgTable);
						{
							// 为了达到一个重叠的效果，把上面的椅子在桌子之前描画
							canvas.addChild(createTableBtn(id.toString(), "up"+id.toString(), img.x+12, img.y-28, 0));
						}
						img.name = "table"+id.toString();
						img.toolTip = "游戏桌名："+obj[id].name +"\n";
						if(obj[id].hasOwnProperty("password"))
							img.toolTip += "该游戏桌设置有密码\n";
						if(obj[id].hasOwnProperty("lowerlevellimit"))		
							img.toolTip += "游戏等级下限为：" + LevelDefine.levelName[obj[id].lowerlevellimit]+"\n";
						else
							img.toolTip += "游戏无等级下限\n";
						if(obj[id].hasOwnProperty("upperlevellimit"))
							img.toolTip += "游戏等级上限为：" + LevelDefine.levelName[obj[id].upperlevellimit]+"\n";
						else
							img.toolTip += "游戏无等级上限\n";
						if(obj[id].hasOwnProperty("magnification"))
							img.toolTip += "金币倍率为："+ FlexGlobals.topLevelApplication.createTable.goldplusrate[obj[id].magnification]+"\n";
						else
							img.toolTip += "无金币倍率\n";
						if(obj[id].hasOwnProperty("allowchat"))	{
							if(obj[id].allowchat)
								img.toolTip += "该游戏桌允许聊天\n"
							else
								img.toolTip += "该游戏桌禁止聊天\n"
						}
						else
							img.toolTip += "该游戏桌禁止聊天\n"
						canvas.addChild(img);
						
						// 桌子上的桌号
						var label:Label = new Label();
						label.x = img.x -38;
						label.y = img.y - 44 ;
						// 为了保证换行以后的文字能够都显示出来
						label.width = 50;
						label.height = 45;
						label.text = String(obj[id].name).replace("台", "台\n");;//(id+1).toString();
//						label.setStyle("fontSize", 14);
//						label.setStyle("color","#ffcc33"); 
						label.name = "tag"+id.toString();
						canvas.addChild(label);
						
						// 创建按钮需要和实际的房间信息结合起来
						// 如果该位置有玩家存在，则无按钮，否则有按钮
						canvas.addChild(createTableBtn(id.toString(), "left"+id.toString(), img.x-40, img.y+16, 1));
						canvas.addChild(createTableBtn(id.toString(), "down"+id.toString(), img.x+12, img.y+40, 2));
						canvas.addChild(createTableBtn(id.toString(), "right"+id.toString(), img.x+52+15, img.y+16, 3));
						// 描画桌子上的人的信息
//						var farr:Array = new Array(0,0,0,0);
						for(var n:int=0;n<4;n++)
						{
							if(obj[id].players.hasOwnProperty(n.toString()))
							{
								if(obj[id].players[n].pos == 0)
								{
									createAvatarAndName(obj[id].players[n], "up"+id.toString(), img.x+17, img.y-40);
//									farr[0] = 1;
								}
								else if(obj[id].players[n].pos == 1)
								{
									createAvatarAndName(obj[id].players[n], "left"+id.toString(), img.x-33, img.y+6);
//									farr[1] = 1;
								}
								else if(obj[id].players[n].pos == 2)
								{
									createAvatarAndName(obj[id].players[n], "down"+id.toString(), img.x+17, img.y+30);
//									farr[2] = 1;
								}
								else if(obj[id].players[n].pos == 3)
								{
									createAvatarAndName(obj[id].players[n], "right"+id.toString(), img.x+51+21, img.y+6);
//									farr[3] = 1;
								}
							}
						}
//						if(farr[0] == 0)
//							createAvatarAndName(null, "up"+id.toString(), img.x+10, img.y-40);
//						if(farr[1] == 0)
//							createAvatarAndName(null, "left"+id.toString(), img.x+10, img.y-40);
//						if(farr[2] == 0)
//							createAvatarAndName(null, "down"+id.toString(), img.x+10, img.y-40);
//						if(farr[3] == 0)
//							createAvatarAndName(null, "right"+id.toString(), img.x+10, img.y-40);
					}
				}
			//}
			tableTotal = obj.length;
			return true;
		}
		
		public function RoomTableDrawII(obj:Object):Boolean
		{
			var canvas:Canvas = FlexGlobals.topLevelApplication.gameRoomCanvas;
			// 如果这个数组没有成员，直接返回
			if(obj.length <= 0)
			{
				canvas.removeAllChildren();
				return false;
			}
			
			canvas.removeAllChildren();
			var i:int,j:int;

			for(i =0; i<roomTableRowMax; i++)
			{
				for(j =0; j<roomTableColumnMax; j++)
				{
					// 如果超出了界限，直接返回
					if(i*roomTableColumnMax+j >= obj.length)
					{
						tableTotal = obj.length;
						return true;
					}
					
					var id:int = i*roomTableColumnMax +j;
					// 如果是非可显示游戏桌，不显示
					if(obj[id].gid == -1)
						continue;
					var roomid:int = obj[id].rid;
					// 桌子的图
					var img:Image = new Image();
					img.x = tableStartX + (intervalX+51)*j;
					img.y = tableStartY + (intervalY+52)*i;
					img.load(ResourceManager.imgTable);
					{
						// 为了达到一个重叠的效果，把上面的椅子在桌子之前描画
						canvas.addChild(createTableBtn(id.toString(), "up"+id.toString(), img.x+12, img.y-28, 0));
					}
					img.name = "table"+id.toString();
					img.toolTip = "游戏桌名："+obj[id].name +"\n";
					if(obj[id].hasOwnProperty("password"))
						img.toolTip += "该游戏桌设置有密码\n";
					if(obj[id].hasOwnProperty("lowerlevellimit"))		
						img.toolTip += "游戏等级下限为：" + LevelDefine.levelName[obj[id].lowerlevellimit]+"\n";
					else
						img.toolTip += "游戏无等级下限\n";
					if(obj[id].hasOwnProperty("upperlevellimit"))
						img.toolTip += "游戏等级上限为：" + LevelDefine.levelName[obj[id].upperlevellimit]+"\n";
					else
						img.toolTip += "游戏无等级上限\n";
					if(obj[id].hasOwnProperty("magnification"))
						img.toolTip += "金币倍率为："+ FlexGlobals.topLevelApplication.createTable.goldplusrate[obj[id].magnification]+"\n";
					else
						img.toolTip += "无金币倍率\n";
					if(obj[id].hasOwnProperty("allowchat"))	{
						if(obj[id].allowchat)
							img.toolTip += "该游戏桌允许聊天\n"
						else
							img.toolTip += "该游戏桌禁止聊天\n"
					}
					else
						img.toolTip += "该游戏桌禁止聊天\n"
					canvas.addChild(img);
					
					// 桌子上的桌号
					var label:Label = new Label();
					label.x = img.x -38;
					label.y = img.y - 44 ;
					// 为了保证换行以后的文字能够都显示出来
					label.width = 50;
					label.height = 45;
					label.text = String(obj[id].name).replace("台", "台\n");;//(id+1).toString();
					//						label.setStyle("fontSize", 14);
					//						label.setStyle("color","#ffcc33"); 
					label.name = "tag"+id.toString();
					canvas.addChild(label);
					
					// 创建按钮需要和实际的房间信息结合起来
					// 如果该位置有玩家存在，则无按钮，否则有按钮
					canvas.addChild(createTableBtn(id.toString(), "left"+id.toString(), img.x-40, img.y+16, 1));
					canvas.addChild(createTableBtn(id.toString(), "down"+id.toString(), img.x+12, img.y+40, 2));
					canvas.addChild(createTableBtn(id.toString(), "right"+id.toString(), img.x+52+15, img.y+16, 3));
					// 描画桌子上的人的信息
					//						var farr:Array = new Array(0,0,0,0);
					for(var n:int=0;n<4;n++)
					{
						if(obj[id].players.hasOwnProperty(n.toString()))
						{
							if(obj[id].players[n].pos == 0)
							{
								createAvatarAndName(obj[id].players[n], "up"+id.toString(), img.x+17, img.y-40);
								//									farr[0] = 1;
							}
							else if(obj[id].players[n].pos == 1)
							{
								createAvatarAndName(obj[id].players[n], "left"+id.toString(), img.x-33, img.y+6);
								//									farr[1] = 1;
							}
							else if(obj[id].players[n].pos == 2)
							{
								createAvatarAndName(obj[id].players[n], "down"+id.toString(), img.x+17, img.y+30);
								//									farr[2] = 1;
							}
							else if(obj[id].players[n].pos == 3)
							{
								createAvatarAndName(obj[id].players[n], "right"+id.toString(), img.x+51+21, img.y+6);
								//									farr[3] = 1;
							}
						}
					}
					//						if(farr[0] == 0)
					//							createAvatarAndName(null, "up"+id.toString(), img.x+10, img.y-40);
					//						if(farr[1] == 0)
					//							createAvatarAndName(null, "left"+id.toString(), img.x+10, img.y-40);
					//						if(farr[2] == 0)
					//							createAvatarAndName(null, "down"+id.toString(), img.x+10, img.y-40);
					//						if(farr[3] == 0)
					//							createAvatarAndName(null, "right"+id.toString(), img.x+10, img.y-40);
				}
			}
			//}
			tableTotal = obj.length;
			return true;
		}
		
		private function createTableBtn(id:String, name:String, x:int, y:int, pos:int):Image
		{
			// 进行一定的修改，不再使用按钮，而是直接的椅子的图
			//var btn:mx.controls.Button = new mx.controls.Button();、
			var btn:Image = new Image();
			btn.source = ResourceManager.imgChair;
			btn.x = x;
			btn.y = y;
			btn.id = id;
			btn.name = name;
			btn.addEventListener(MouseEvent.CLICK, tableBtnHandler);
//			btn.width = 30;
//			btn.height = 30;
//			btn.setStyle("cornerRadius", 13);
//			btn.setStyle("borderColor", "#445c95");
			return btn;
		}
		private function createAvatarAndName(obj:Object, name:String, x:int, y:int):Image
		{
			// 增加头像的2个框
			var rt1:Shape = new Shape();
			rt1.graphics.beginFill(0xeeeeee, 1);
			rt1.graphics.moveTo(x+tableAvatarSize+1, y-1);
			rt1.graphics.lineTo(x-1, y-1);
			rt1.graphics.lineTo(x-1, y+tableAvatarSize+1);
			rt1.graphics.lineTo(x+tableAvatarSize+1, y+tableAvatarSize+1);
			rt1.graphics.lineTo(x+tableAvatarSize+1, y-1);
			rt1.graphics.endFill();
			var rt2:Shape = new Shape();
			rt2.graphics.beginFill(0x0, 1);
			rt2.graphics.moveTo(x+tableAvatarSize+2, y-2);
			rt2.graphics.lineTo(x-2, y-2);
			rt2.graphics.lineTo(x-2, y+tableAvatarSize+2);
			rt2.graphics.lineTo(x+tableAvatarSize+2, y+tableAvatarSize+2);
			rt2.graphics.lineTo(x+tableAvatarSize+2, y-2);
			rt2.graphics.endFill();
			var ui:UIComponent = new UIComponent();
			ui.addChild(rt2);
			ui.addChild(rt1);
			FlexGlobals.topLevelApplication.gameRoomCanvas.addChild(ui);
			
			var img:Image = new Image();
			var lbl:Label = new Label();
			img.name = "avatar"+name;
			lbl.name = "name"+name;
//			lbl.setStyle("color", 0xFFFFFF);
			lbl.width = 44;
//			if(obj == null)
//			{
//				img.visible = false;
//				FlexGlobals.topLevelApplication.gameRoomCanvas.addChild(img);
//				lbl.visible = false;
//				FlexGlobals.topLevelApplication.gameRoomCanvas.addChild(lbl);
//				return null;
//			}
			img.x = x;
			img.y = y;
			img.scaleX = 0.6;
			img.scaleY = 0.6;
			if(img.source != obj.avatar)
				img.source = obj.avatar;
			FlexGlobals.topLevelApplication.gameRoomCanvas.addChild(img);
			if(obj.ready)
				lbl.text = obj.name +"(o)";
			else
				lbl.text = obj.name +"(x)";

			var describe:String = "";
			describe += obj.score;
			describe += "分 ";
			describe += LevelDefine.getLevelName(int(obj.score));
			describe += "\n";
//			for each(var scoreobj:Object in obj.score)//StateGetPlayerInfo.Instance.lastSuccData.player.score)
//			{
//				describe += scoreobj.name;
//				describe += " ";
//				describe += scoreobj.score;
//				describe += "分 ";
//				describe += LevelDefine.getLevelName(int(scoreobj.score));
//				describe += "\n";
//			}

			describe += obj.money + " 金币";//StateGetPlayerInfo.Instance.lastSuccData.player.money+" 金币";
			lbl.toolTip = lbl.text + "\n" + describe;
			
			lbl.x = x - 4;
			lbl.y = y - 18;
			FlexGlobals.topLevelApplication.gameRoomCanvas.addChild(lbl);
			return null;
		}
		
		// 当桌子上的座位被点击了以后，会发出加入游戏的请求。
		private function tableBtnHandler(event:MouseEvent):void
		{
			// 点击台面的标签以后，对该页面的内容进行请求，并清空之前的内容
			if(windowMutex && LobyNetManager.Instance.RequestEnable)
				return;
			// 首先对该房间有没有密码进行判断，如果该房间有密码
			if(StateGetTableInfo.Instance.lastSuccData[event.currentTarget.id].hasOwnProperty("password"))
			{
				// 显示密码输入框
				FlexGlobals.topLevelApplication.pwInput.visible = true;
				FlexGlobals.topLevelApplication.pwInput.clearInput();
				windowMutex = true;
				FlexGlobals.topLevelApplication.pwInput.saveJoinInfo(event.currentTarget.id, event.currentTarget.name);
			}else{
				//没有密码
				// 向服务器发出加入一张桌子的请求
				LobyNetManager.Instance.send(LobyNetManager.joinTable, event.currentTarget.id, event.currentTarget.name);
			}
		}
		
		public function closeGame():void
		{
			FlexGlobals.topLevelApplication.gameFlash.visible = false;
		}
		
		/**
		 * 用来控制公告的文字的显示
		 */		
		public function animateAnouncement():void
		{
			// 当前是否在演示中
			if(isAnnouncePlaying)
			{
				// 对当前的公告进行动画显示
				var txt:Label = FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText;
				if(txt.x < (-txt.textWidth))
				{
					looptimes--;
					if(looptimes <= 0)
					{
						// 结束这个条目，换下一个内容显示
						isAnnouncePlaying = false;
						looptimes = looptimesdefine;
						
						FlexGlobals.topLevelApplication.lobbyAnnounce.visible = false;
					}
					txt.x = FlexGlobals.topLevelApplication.lobbyAnnounce.width;
				}
				else{
					txt.x --;
				}
			}
			else{
				var data:Object;
				// 获得一个新的公告内容
				curAnnounce =  Messenger.Instance.shoutRec.getSystemmsg();
				if(curAnnounce != null)
				{
					FlexGlobals.topLevelApplication.lobbyAnnounce.visible = true;
					isAnnouncePlaying = true;
					// 解释得到的消息文字
					data = JSON.decode(curAnnounce);
//					FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.setStyle("color", "#efefef");
					FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.text = data.content[0].val;
					FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.x = FlexGlobals.topLevelApplication.lobbyAnnounce.width;
				}
				// 在没有公告的情况下，查看是否有喊话
				else{
					curAnnounce =  Messenger.Instance.shoutRec.getShoutmsg();
					if(curAnnounce != null)
					{
						FlexGlobals.topLevelApplication.lobbyAnnounce.visible = true;
						isAnnouncePlaying = true;
						// 解释得到的消息文字
						data = JSON.decode(curAnnounce);
//						FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.setStyle("color", "#308060");
						FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.text = data.content[0].val;
						FlexGlobals.topLevelApplication.lobbyAnnounce.lobbyancText.x = FlexGlobals.topLevelApplication.lobbyAnnounce.width;
					}
				}
			}
		}
	}
}