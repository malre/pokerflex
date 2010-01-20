package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import lobystate.StateGetSkin;
	
	import mx.core.FlexGlobals;
	import mx.events.FlexEvent;
	import mx.preloaders.DownloadProgressBar;
	
	public class GameLoadingbar extends DownloadProgressBar
	{
		include "ServerAddress.ini"

		[Embed(source="../res/preLodgingbar.swf")]
		private var loadingImg:Class;
		
		private var _preloader:Sprite; 
//		private var img:Image = new Image();
		private var loader:Loader = new Loader();

		public function GameLoadingbar()
		{
			super();
//			MINIMUM_DISPLAY_TIME = 3000;
			initializingLabel="程序正在初始化中，请稍候……";
			var urlrq:URLRequest = new URLRequest( ServerAddress + ServerPerfix + "/resources/game/preLodgingbar.swf");
//			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadover);
			loader.load(urlrq);
			// loader width:370, height:100
			loader.x = (760-370)/2;
			loader.y = (560-100-40)/2-50;
			this.addChild(loader);
		}
		public function loadSuccess():void
		{
			dispatchEvent(new Event(Event.COMPLETE));
//			FlexGlobals.topLevelApplication.currentState = "lobby";
			LobyNetManager.Instance.send(LobyNetManager.roomInfo);
			FlexGlobals.topLevelApplication.modifySkin();
		}
		
		protected function loadover(event:Event):void
		{
			var isn:int = 100;
//			this.addChild(loader.content);
		}
		
		override protected function get labelRect():Rectangle
		{
			return new Rectangle(14, 5, 150, 30);
		}
		
		override protected function progressHandler(event:ProgressEvent) : void
		{
			super.progressHandler(event);
			label = Math.round(event.bytesLoaded / 1000).toString() + "k/" + Math.round(event.bytesTotal/1000).toString()+"k";
		}
		
		override public function set preloader(value:Sprite):void
		{   
			_preloader = value   
			//四个侦听~分别是 加载进度 / 加载完毕 / 初始化进度 / 初始化完毕   
			_preloader.addEventListener(ProgressEvent.PROGRESS,load_progress);
			_preloader.addEventListener(Event.COMPLETE,load_complete);
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS,init_progress);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE,init_complete);
			
		}   
		private function remove():void
		{   
			_preloader.removeEventListener(ProgressEvent.PROGRESS,load_progress);   
			_preloader.removeEventListener(Event.COMPLETE,load_complete);   
			_preloader.removeEventListener(FlexEvent.INIT_PROGRESS,init_progress);   
			_preloader.removeEventListener(FlexEvent.INIT_COMPLETE,init_complete);   
		}   
		private function load_progress(e:ProgressEvent):void
		{   
//			txt.text = "正在加载..."+int(e.bytesLoaded/e.bytesTotal*100)+"%";   
		}   
		private function load_complete(e:Event):void
		{   
//			txt.text = "加载完毕!" 
		}   
		private function init_progress(e:FlexEvent):void
		{   
//			txt.text = "正在初始化..." 
		}   
		private function init_complete(e:FlexEvent):void
		{   
//			txt.text = "初始化完毕!" 
			remove();
			StateGetSkin.Instance.setLoadingBarObj(this);
			LobyNetManager.Instance.send(LobyNetManager.getskin);
			//最后这个地方需要dpe一个Event.COMPLETE事件..表示加载完毕让swf继续操作~   
//			dispatchEvent(new Event(Event.COMPLETE));
		}   

		
		override protected function showDisplayForDownloading(elapsedTime:int, event:ProgressEvent) : Boolean
		{
			return true;
		}
		
		override protected function showDisplayForInit(elapsedTime:int, count:int) : Boolean
		{
			return true;
		}
	}
}