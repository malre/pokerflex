package message.httpController
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	/**
	 * 
	 * @author Eric
	 * 用来控制收发http消息的原型
	 */
	public class httpModelBase
	{
		protected var httpservice:HTTPService;
		protected var timer:Timer;
		public var lastSuccObj:Object;
		protected var requestMutex:Boolean;
		
		public function httpModelBase()
		{
			httpservice = new HTTPService();
			httpservice.resultFormat = HTTPService.RESULT_FORMAT_TEXT; 
			httpservice.addEventListener(ResultEvent.RESULT, result);
			httpservice.addEventListener(FaultEvent.FAULT, fault);
			lastSuccObj = new Object();
			
			requestMutex = false;
		}
		/**
		 * 发送http请求 
		 * 
		 */		
		public function send(val:Object = null):void
		{
			httpservice.send();
		}
		/**
		 * 
		 * @param event
		 * 处理成功情况下得到的http请求返回
		 */
		public function result(event:Event):void
		{
			
		}
		/**
		 * @param event
		 * 处理失败情况 
		 * 
		 */		
		public function fault(event:Event):void
		{
			
		}
		public function setmethod(method:String):void
		{
			httpservice.method = method;
		}
		
		// timer setting
		public function setTimerDelay(delay:int):void
		{
			timer.delay = delay;
		}
		/**
		 * 在开始定时器之前，请确保http service都已经设置好了
		 * 
		 */		
		public function startTimer(delay:int):void
		{
			if(timer == null)
			{
				timer = new Timer(delay);
				timer.addEventListener(TimerEvent.TIMER, timeout);
			}
			timer.start();
		}
		public function stopTimer():void
		{
			if(timer != null)
				timer.stop();
		}
		/**
		 * 当指定的时间间隔到了以后， 定时器会调用这个函数
		 * 这个函数内会自动发出http请求
		 * @param event
		 * 
		 */		
		public function timeout(event:TimerEvent):void
		{
			send();
		}
	}
}