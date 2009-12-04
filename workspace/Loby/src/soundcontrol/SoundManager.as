package soundcontrol
{
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	import mx.core.SoundAsset;
	
	import poker.ResourceManagerPoker;

	public class SoundManager
	{
		private static var instance:SoundManager = null;
		
		private var channel:SoundChannel;
		private var player:SoundAsset;
		private var isPlaying:Boolean = false;
		
		// SE
		private var _SEEnable:Boolean;
		
		//
		private var url:URLRequest;
		public var mp3url:String = "http://www.jl2sy.cn/xssq/yyyf/lmjq/gq/aizhimeng.mp3";
		
		public function SoundManager()
		{
			url = new URLRequest();
			player = new SoundAsset();
			SEEnable = true;
		}
		
		public function get SEEnable():Boolean
		{
			return _SEEnable;
		}

		public function set SEEnable(value:Boolean):void
		{
			_SEEnable = value;
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
		
		/**
		 * 播放声音
		 * @param obj
		 * 
		 */
		public function playSEByCardtype(cardtype:int):void
		{
			if(!_SEEnable)
				return;
			
			if(cardtype == 0)
			{
				ResourceManagerPoker.SoundYizhang.play();
			}
			else if(cardtype == 1)
			{
				ResourceManagerPoker.SoundDuizi.play();
			}
			else if(cardtype == 2)
			{
				ResourceManagerPoker.SoundSange.play();
			}
			else if(cardtype >= 3 && cardtype <= 7)
			{
				ResourceManagerPoker.SoundZhadan.play();
			}
			else if(cardtype >= 8 && cardtype <= 15)
			{
				ResourceManagerPoker.SoundShunzi.play();
			}
			else if(cardtype >= 16 && cardtype <= 35)
			{
				ResourceManagerPoker.SoundLiandui.play();
			}
			else if(cardtype == 36)
			{
				ResourceManagerPoker.SoundWangzha.play();
			}
		}	
		
		// 播放 开场，结束，放弃等音效
		public function playSE(name:String):void
		{
			if(!_SEEnable)
				return;

			if(name == "pass"){
				ResourceManagerPoker.SoundPass.play();
			}
			else if(name == "start"){
				ResourceManagerPoker.SoundStart.play();
			}
			else if(name == "win"){
				ResourceManagerPoker.SoundWin.play();
			}
		}
	}
}