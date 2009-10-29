package soundcontrol
{
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import mx.core.SoundAsset;

	public class SoundManager
	{
		private static var instance:SoundManager = null;
		
		private var channel:SoundChannel;
		private var player:SoundAsset;
		private var isPlaying:Boolean = false;
		
		//
		private var url:URLRequest;
		public var mp3url:String = "http://www.jl2sy.cn/xssq/yyyf/lmjq/gq/aizhimeng.mp3";
		
		public function SoundManager()
		{
			url = new URLRequest();
			player = new SoundAsset();
		}
		
		public static function Instance():SoundManager
		{
			if(instance == null)
				instance = new SoundManager();
				
			return instance;
		}
		
		public function seturl(Url:String):void
		{
			this.url.url = Url;
		}
		
		public function play():void
		{
			if(!isPlaying)
			{
				player.load(url);
				channel = player.play(0, 10000);
				isPlaying = true;
			}
		}
		
		public function stop():void
		{
			//channel.stop();
			player.close();
		}
	}
}