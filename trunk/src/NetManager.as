package
{
	import flash.events.Event;
	
	import mx.core.Application;
	
	public class NetManager
	{
		//
		protected static var instance:NetManager = null;
		//定义了进行连接的服务器地址
		public var sendURL:String = "http://192.168.18.24/web/world/account/login";
		//传送的数据内容
		private var sendData:String = null;
		//
		private var netManager:NetManager=null;
		
		public function NetManager()
		{
		}
		
		public static function get Instance():NetManager
		{
			if(instance)
				return instance;
			else
				return instance = new NetManager();
		}

		public static function getSendData():String
		{
			//return sendData;
			return "1";
		}
		
		public function	send():void
		{
			Application.application.httpService.url = NetManager.Instance.sendURL;
			Application.application.httpService.send();
		}
		
		public function resultProcess(event:Event):void
		{
		}

		public function failProcess(event:Event):void
		{
		}
	}
}