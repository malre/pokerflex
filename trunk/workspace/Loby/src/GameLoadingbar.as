package
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	import mx.preloaders.DownloadProgressBar;
	
	public class GameLoadingbar extends DownloadProgressBar
	{
		[Embed(source="../res/preLodgingbar.swf")]
		private var loadingImg:Class;
		
//		private var img:Image = new Image();
		private var loader:Loader = new Loader();

		public function GameLoadingbar()
		{
			super();
//			MINIMUM_DISPLAY_TIME = 3000;
			initializingLabel="程序正在初始化中，请稍候……";
//			img.source = loadingImg;
//			this.addChild(img);
			var urlrq:URLRequest = new URLRequest("http://sns.zj.chinamobile.com/webgames/dxsk/resources/game/preLodgingbar.swf");
			loader.load(urlrq);
			// loader width:370, height:100
			loader.x = (760-370)/2;
			loader.y = (560-100-40)/2-50;
//			loader.addEventListener(Event.COMPLETE, loadover);
			this.addChild(loader);
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