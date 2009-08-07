package
{
	import flash.events.Event;
	
	import json.JSON;
	
	import mx.managers.CursorManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.mxml.HTTPService;

	// 对服务器发出连接和请求，并作出回应
	public class LobyNetManager
	{
		////////////// 常数定义	///////////////
		// 请求的地址定义
		static private var URL_lobyAddress:String = "http://192.168.18.24/web/world/";
		static private var URL_roomInfo:String = "game/list/list";
		static private var URL_playerInfo:String = "game/index/identity";
		// 各种请求定义
		static public var playerInfo:String = "request player info";
		static public var roomInfo:String = "request room info";
		
		//
		static private var instance:LobyNetManager = null;
		static private var httpser:HTTPService = new HTTPService();
		// 这里本来打算加入flex自己带的http用的一个数据格式化工具，但是使用失败了。具体的使用看各处的json format注释
		// json format
		//static private var serializer0:JSONSerializationFilter = new JSONSerializationFilter();
		
		private var result:Object = new Object();
		
		public function LobyNetManager()
		{
			httpser.method = "POST";
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
		// 向服务器发送请求
		public function send(type:String):void
		{
			if(type == playerInfo)
			{
				httpser.url = URL_lobyAddress+URL_playerInfo;
				httpser.send();
			}
			else if(type == roomInfo)
			{
				httpser.url = URL_lobyAddress+URL_roomInfo;
				httpser.send();
			}
		}
		
		public function httpResult(event:Event):void
		{
			result = JSON.decode(httpser.lastResult.toString());
			CursorManager.removeBusyCursor();
			var flag:Boolean = true;
			var index:int = 0;
			while(flag)
			{
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
			
		}
		
		public function httpFault(event:Event):void
		{
			CursorManager.removeBusyCursor();
		}
	}
}