package
{
	import flash.events.Event;
	
	import json.JSON;
	
	import lobystate.*;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	// 对服务器发出连接和请求，并作出回应
	public class LobyNetManager
	{
		////////////// 常数定义	///////////////
		// 请求的地址定义
		// 连接地址的规范
		// 首先向一个统一的地址请求房间信息，我们称这个地址为固定loby地址，对这个地址的请求我们会得到一个
		// 新的loby地址
		static public var URL_lobyAddress:String = "http://192.168.18.199/web/world/";
		//static private var URL_lobyAddress:String = "http://192.168.18.199/web/world/";
		// 我们将这个loby地址保存下来，这个被我们称为动态loby地址，它可能会有变化
		static public var URL_lobysonAddress:String = "http://192.168.18.24/web/world/";
		//private var URL_lobysonAddress:String = "http://192.168.18.199/web/world/";
		// 然后我们都通过这个地址来进行房间和桌子的信息请求
		static public var URL_roomInfo:String = "lobby/info/list";
		static public var URL_playerInfo:String = "game/index/identity";
		static public var URL_tableInfo:String = "game/list/list";
		static public var URL_joinTable:String = "game/room/add";
		static public var URL_leaveTable:String = "game/room/remove";
		//private var URL_
		// 各种请求定义
		static public var getlobyaddress:String = "request loby";
		static public var playerInfo:String = "request player info";
		static public var roomInfo:String = "request room info";
		static public var tableInfo:String = "request table info";
		static public var joinTable:String = "join table game";
		static public var leaveTable:String = "leave table";
		
		//
		static private var instance:LobyNetManager = null;
		static private var httpser:HTTPService = new HTTPService();
		// 这里本来打算加入flex自己带的http用的一个数据格式化工具，但是使用失败了。具体的使用看各处的json format注释
		// 经过考虑实际上是可行的，具体如下
		// 使用这个类就可以了com.adobe.serializers.json.JSONDecoder;
		// json format
		//static private var serializer0:JSONSerializationFilter = new JSONSerializationFilter();
		
		// 本次请求连接开始以后，不能够再进行请求
		private var requestEnable:Boolean = true;
		private var request_lobyaddress:Boolean = false;
		private var request_playerinfo:Boolean = false;
		private var request_roominfo:Boolean = false;
		private var request_tableinfo:Boolean = false;
		private var request_jointable:Boolean = false;
		
		private var result:Object = new Object();
		private var lastRlt:Object = new Object();
		
		public function LobyNetManager()
		{
			httpser.method = "POST";
			httpser.showBusyCursor = true;
			httpser.addEventListener(ResultEvent.RESULT, httpResult);
			httpser.addEventListener(FaultEvent.FAULT, httpFault);
			
			// json format
			//httpser.serializationFilter = serializer0;
			//httpser.resultFormat = "json";
			
		}
		
		static public function get Instance():LobyNetManager
		{
			if(instance == null)
				instance = new LobyNetManager();
			return instance;
		}
		public function get httpservice():HTTPService
		{
			return httpser;
		}
		
		public function set RequestEnable(val:Boolean):void
		{
			requestEnable = val; 
		}
		public function get RequestEnable():Boolean
		{
			return requestEnable;
		}
		// 向服务器发送请求
		public function send(type:String, param1:String=null, param2:String=null):void
		{
			// reset flag
			request_lobyaddress = false;
			request_playerinfo = false;
			request_roominfo = false;
			request_tableinfo = false;
			request_jointable = false;
			// 请求保护，如果上次的请求还没有返回，不能开始下一次请求。
			if(!requestEnable)
				return;
			else
				requestEnable = false;
				
			if(type == getlobyaddress)
			{
				StateManager.Instance.changeState(StateGetLobyAddress.Instance);
			}
			else if(type == playerInfo)
			{
				StateManager.Instance.changeState(StateGetPlayerInfo.Instance);
			}
			else if(type == roomInfo)
			{
				StateManager.Instance.changeState(StateUpdateRoomInfo.Instance);
			}
			else if(type == tableInfo)
			{
				StateManager.Instance.changeState(StateGetTableInfo.Instance);
			}
			else if(type == joinTable)
			{
				// 使用了参数1，该参数传递的是这张桌子的编号,  参数2 ，传递是桌子的位置
				httpser.url = URL_lobysonAddress+URL_joinTable;
				var p:int = -1;
				if(param2 == "up"+param1)
				{
					p = 0;
				}
				else if(param2 == "left"+param1)
				{
					p = 1;
				}
				else if(param2 == "down"+param1)
				{
					p = 2;
				}
				else if(param2 == "right"+param1)
				{
					p = 3;
				}
				StateManager.Instance.changeState(StateLobyJoinTable.Instance);
				var rq:Object = {roomid:lastRlt[param1].rid.toString(),pos:p};
				StateLobyJoinTable.Instance.setRequest(rq);
			}
			else if(type == leaveTable)
			{
				StateManager.Instance.changeState(StateLeaveTable.Instance);
			}
			StateManager.Instance.send();
		}
		
		public function httpResult(event:Event):void
		{
			// 恢复请求许可
			requestEnable = true;
			CursorManager.removeBusyCursor();

			try{
 			result = JSON.decode(httpser.lastResult.toString());
 			}catch(error:ArgumentError){
 				trace("json decode error");
 			}
			if(result.hasOwnProperty("success"))
			{
				if(!result.success)
				{
					if(result.hasOwnProperty("error"))
					{
						Alert.show(result.error.message);
					}
					return;
				}
			}
			
			StateManager.Instance.receive(result);
			lastRlt = result;
		}
		private function initlisten(event:Event):void
		{

            // Initialize variables with information from
            // the loaded application.
			FlexGlobals.topLevelApplication.gameFlash.visible = true;
			//
			LobyManager.Instance.isGameLoaded = true;
		}
		public function httpFault(event:Event):void
		{
			// 恢复请求许可
			requestEnable = true;
			
			CursorManager.removeBusyCursor();
		}
		
		// 对得到的房间数据进行分析，并进行设置
		private function roomdataParse(obj:Object):void
		{
			var flag:Boolean = true;
			var index:int = 0;
			while(flag)
			{
				// 是否有这个索引号的房间
				if(result.hasOwnProperty(index.toString()))
				{
					
					index++;
				}
				else
				{
					index = 0;
					flag = false;
				}
			}				
/*					var xmllist:XMLList = FlexGlobals.topLevelApplication.treeData.node.(@label == "双扣");
					if(xmllist.length() > 0)
					{
						for(var i:int=0;i<10;i++)
						{
							var newnode:XML = <node/>;
							newnode.@label = "房间"+(i+1).toString();
							newnode.@id = i;
							xmllist.appendChild(newnode);
						}
					}*/			
		}
		
		private function tabledataParse(obj:Object):void
		{
			
		}
	}
}