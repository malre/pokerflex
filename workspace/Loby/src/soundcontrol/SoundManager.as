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
		public function playSEByCardtype(cardtype:int, cardvalue:int):void
		{
			if(!_SEEnable)
				return;
			
			var se:Class;
			if(cardtype == 0)
			{
				playSingleSE(cardvalue);
				return;
//				se = ResourceManagerPoker.sound_yizhang;
			}
			else if(cardtype == 1)
			{
				playDoubleSE(cardvalue);
				return;
//				se = ResourceManagerPoker.sound_dui;
			}
			else if(cardtype == 2)
			{
				se = ResourceManagerPoker.sound_sange;
			}
			else if(cardtype >= 3 && cardtype <= 7)
			{
				se = ResourceManagerPoker.sound_zhandan;
			}
			else if(cardtype >= 8 && cardtype <= 15)
			{
				se = ResourceManagerPoker.sound_shunzi;
			}
			else if(cardtype >= 16 && cardtype <= 35)
			{
				se = ResourceManagerPoker.sound_liandui;
			}
			else if(cardtype == 36)
			{
				se = ResourceManagerPoker.sound_wangzha;
			}
			var sa:SoundAsset = new se as SoundAsset;
			sa.play();
		}	
		public function playSingleSE(card:int):void
		{
			if(!_SEEnable)
				return;
			
			var se:Class;
			var val:int;
			if(card < 52){
				val = int(card/4);
			}
			else
				val = card;
			switch(val)
			{
				case 0:
					se = ResourceManagerPoker.sound_single_3;
					break;
				case 1:
					se = ResourceManagerPoker.sound_single_4;
					break;
				case 2:
					se = ResourceManagerPoker.sound_single_5;
					break;
				case 3:
					se = ResourceManagerPoker.sound_single_6;
					break;
				case 4:
					se = ResourceManagerPoker.sound_single_7;
					break;
				case 5:
					se = ResourceManagerPoker.sound_single_8;
					break;
				case 6:
					se = ResourceManagerPoker.sound_single_9;
					break;
				case 7:
					se = ResourceManagerPoker.sound_single_10;
					break;
				case 8:
					se = ResourceManagerPoker.sound_single_J;
					break;
				case 9:
					se = ResourceManagerPoker.sound_single_Q;
					break;
				case 10:
					se = ResourceManagerPoker.sound_single_K;
					break;
				case 11:
					se = ResourceManagerPoker.sound_single_A;
					break;
				case 12:
					se = ResourceManagerPoker.sound_single_2;
					break;
				case 52:
					se = ResourceManagerPoker.sound_single_52;
					break;
				case 53:
					se = ResourceManagerPoker.sound_single_53;
					break;
				default:
					return;
			}
			var sa:SoundAsset = new se as SoundAsset;
			sa.play();
		}
		public function playDoubleSE(card:int):void
		{
			if(!_SEEnable)
				return;
			
			var se:Class;
			var val:int;
			if(card < 52){
				val = int(card/4);
			}
			else
				val = card;
			switch(val)
			{
				case 0:
					se = ResourceManagerPoker.sound_double_3;
					break;
				case 1:
					se = ResourceManagerPoker.sound_double_4;
					break;
				case 2:
					se = ResourceManagerPoker.sound_double_5;
					break;
				case 3:
					se = ResourceManagerPoker.sound_double_6;
					break;
				case 4:
					se = ResourceManagerPoker.sound_double_7;
					break;
				case 5:
					se = ResourceManagerPoker.sound_double_8;
					break;
				case 6:
					se = ResourceManagerPoker.sound_double_9;
					break;
				case 7:
					se = ResourceManagerPoker.sound_double_10;
					break;
				case 8:
					se = ResourceManagerPoker.sound_double_J;
					break;
				case 9:
					se = ResourceManagerPoker.sound_double_Q;
					break;
				case 10:
					se = ResourceManagerPoker.sound_double_K;
					break;
				case 11:
					se = ResourceManagerPoker.sound_double_A;
					break;
				case 12:
					se = ResourceManagerPoker.sound_double_2;
					break;			
				case 52:
					se = ResourceManagerPoker.sound_single_52;
					break;
				case 53:
					se = ResourceManagerPoker.sound_single_53;
					break;
				default:
					return;
			}	
			var sa:SoundAsset = new se as SoundAsset;
			sa.play();
		}
		
		// 播放 开场，结束，放弃等音效
		public function playSE(name:String):void
		{
			if(!_SEEnable)
				return;

			var se:Class;
			if(name == "pass"){
				se = ResourceManagerPoker.sound_pass;
			}
			else if(name == "start"){
				se = ResourceManagerPoker.sound_start;
			}
			else if(name == "win"){
				se = ResourceManagerPoker.sound_win;
			}
			var sa:SoundAsset = new se as SoundAsset;
			sa.play();
		}
	}
}