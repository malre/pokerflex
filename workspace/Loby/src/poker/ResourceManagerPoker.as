package poker
{
	import flash.display.*;
	import flash.geom.*;
	
	import mx.collections.ArrayCollection;
	import mx.core.*;
	
	public final class ResourceManagerPoker
	{
//		public static var CardsRes:ArrayCollection = new ArrayCollection();
		public static var gameCardsRes:ArrayCollection = new ArrayCollection();
		
		[Embed(source="../res/00.png")]
		public static var Card00:Class;
		
		[Embed(source="../res/01.png")]
		public static var Card01:Class;

		[Embed(source="../res/02.png")]
		public static var Card02:Class;

		[Embed(source="../res/03.png")]
		public static var Card03:Class;

		[Embed(source="../res/04.png")]
		public static var Card04:Class;

		[Embed(source="../res/05.png")]
		public static var Card05:Class;

		[Embed(source="../res/06.png")]
		public static var Card06:Class;

		[Embed(source="../res/07.png")]
		public static var Card07:Class;

		[Embed(source="../res/08.png")]
		public static var Card08:Class;

		[Embed(source="../res/09.png")]
		public static var Card09:Class;

		[Embed(source="../res/10.png")]
		public static var Card10:Class;

		[Embed(source="../res/11.png")]
		public static var Card11:Class;

		[Embed(source="../res/12.png")]
		public static var Card12:Class;

		[Embed(source="../res/13.png")]
		public static var Card13:Class;

		[Embed(source="../res/14.png")]
		public static var Card14:Class;

		[Embed(source="../res/15.png")]
		public static var Card15:Class;

		[Embed(source="../res/16.png")]
		public static var Card16:Class;

		[Embed(source="../res/17.png")]
		public static var Card17:Class;

		[Embed(source="../res/18.png")]
		public static var Card18:Class;

		[Embed(source="../res/19.png")]
		public static var Card19:Class;

		[Embed(source="../res/20.png")]
		public static var Card20:Class;

		[Embed(source="../res/21.png")]
		public static var Card21:Class;

		[Embed(source="../res/22.png")]
		public static var Card22:Class;

		[Embed(source="../res/23.png")]
		public static var Card23:Class;

		[Embed(source="../res/24.png")]
		public static var Card24:Class;

		[Embed(source="../res/25.png")]
		public static var Card25:Class;

		[Embed(source="../res/26.png")]
		public static var Card26:Class;

		[Embed(source="../res/27.png")]
		public static var Card27:Class;

		[Embed(source="../res/28.png")]
		public static var Card28:Class;

		[Embed(source="../res/29.png")]
		public static var Card29:Class;

		[Embed(source="../res/30.png")]
		public static var Card30:Class;

		[Embed(source="../res/31.png")]
		public static var Card31:Class;

		[Embed(source="../res/32.png")]
		public static var Card32:Class;

		[Embed(source="../res/33.png")]
		public static var Card33:Class;

		[Embed(source="../res/34.png")]
		public static var Card34:Class;

		[Embed(source="../res/35.png")]
		public static var Card35:Class;

		[Embed(source="../res/36.png")]
		public static var Card36:Class;

		[Embed(source="../res/37.png")]
		public static var Card37:Class;

		[Embed(source="../res/38.png")]
		public static var Card38:Class;

		[Embed(source="../res/39.png")]
		public static var Card39:Class;

		[Embed(source="../res/40.png")]
		public static var Card40:Class;

		[Embed(source="../res/41.png")]
		public static var Card41:Class;

		[Embed(source="../res/42.png")]
		public static var Card42:Class;

		[Embed(source="../res/43.png")]
		public static var Card43:Class;

		[Embed(source="../res/44.png")]
		public static var Card44:Class;

		[Embed(source="../res/45.png")]
		public static var Card45:Class;

		[Embed(source="../res/46.png")]
		public static var Card46:Class;

		[Embed(source="../res/47.png")]
		public static var Card47:Class;

		[Embed(source="../res/48.png")]
		public static var Card48:Class;

		[Embed(source="../res/49.png")]
		public static var Card49:Class;

		[Embed(source="../res/50.png")]
		public static var Card50:Class;

		[Embed(source="../res/51.png")]
		public static var Card51:Class;

		[Embed(source="../res/52.png")]
		public static var Card52:Class;

		[Embed(source="../res/53.png")]
		public static var Card53:Class;
		
		gameCardsRes.addItem(Card02);
		gameCardsRes.addItem(Card15);		//	草花		1
		gameCardsRes.addItem(Card28);		//	 红桃	2
		gameCardsRes.addItem(Card41);		//  黑桃		3

		gameCardsRes.addItem(Card03);		//4
		gameCardsRes.addItem(Card16);
		gameCardsRes.addItem(Card29);
		gameCardsRes.addItem(Card42);

		gameCardsRes.addItem(Card04);
		gameCardsRes.addItem(Card17);
		gameCardsRes.addItem(Card30);
		gameCardsRes.addItem(Card43);

		gameCardsRes.addItem(Card05);
		gameCardsRes.addItem(Card18);
		gameCardsRes.addItem(Card31);
		gameCardsRes.addItem(Card44);

		gameCardsRes.addItem(Card06);
		gameCardsRes.addItem(Card19);
		gameCardsRes.addItem(Card32);
		gameCardsRes.addItem(Card45);

		gameCardsRes.addItem(Card07);
		gameCardsRes.addItem(Card20);
		gameCardsRes.addItem(Card33);
		gameCardsRes.addItem(Card46);

		gameCardsRes.addItem(Card08);
		gameCardsRes.addItem(Card21);
		gameCardsRes.addItem(Card34);
		gameCardsRes.addItem(Card47);

		gameCardsRes.addItem(Card09);		// 10
		gameCardsRes.addItem(Card22);
		gameCardsRes.addItem(Card35);
		gameCardsRes.addItem(Card48);

		gameCardsRes.addItem(Card10);		// J
		gameCardsRes.addItem(Card23);
		gameCardsRes.addItem(Card36);
		gameCardsRes.addItem(Card49);

		gameCardsRes.addItem(Card11);		// Q
		gameCardsRes.addItem(Card24);
		gameCardsRes.addItem(Card37);
		gameCardsRes.addItem(Card50);

		gameCardsRes.addItem(Card12);		// K
		gameCardsRes.addItem(Card25);
		gameCardsRes.addItem(Card38);
		gameCardsRes.addItem(Card51);

		gameCardsRes.addItem(Card00);		// A
		gameCardsRes.addItem(Card13);
		gameCardsRes.addItem(Card26);
		gameCardsRes.addItem(Card39);
		gameCardsRes.addItem(Card01);		// 2
		gameCardsRes.addItem(Card14);
		gameCardsRes.addItem(Card27);
		gameCardsRes.addItem(Card40);

		gameCardsRes.addItem(Card52);
		gameCardsRes.addItem(Card53);


		
		[Embed(source="../res/cardback1.png")]
		public static var cardback1:Class;
		
		[Embed(source="../res/sandglass.swf")]
		public static var sandglass_skin1:Class;
		[Embed(source="../res/skin2/sandglass.swf")]
		public static var sandglass_skin2:Class;
		[Embed(source="../res/skin3/sandglass.swf")]
		public static var sandglass_skin3:Class;
		
		[Embed(source="../res/pass.swf")]
		public static var pass_skin1:Class;
		[Embed(source="../res/skin2/pass.swf")]
		public static var pass_skin2:Class;
		[Embed(source="../res/skin3/pass.swf")]
		public static var pass_skin3:Class;

		[Embed(source="../res/CPUAI.swf")]
		public static var CPUAI_skin1:Class;
		[Embed(source="../res/skin2/CPUAI.swf")]
		public static var CPUAI_skin2:Class;
		[Embed(source="../res/skin3/CPUAI.swf")]
		public static var CPUAI_skin3:Class;

		
		// sound
		[Embed(source="../res/sound/start.mp3")]
		public static var sound_start:Class;

		[Embed(source="../res/sound/baojing.mp3")]
		public static var sound_yizhang:Class;

		[Embed(source="../res/sound/buyao.mp3")]
		public static var sound_pass:Class;

		[Embed(source="../res/sound/dui.mp3")]
		public static var sound_dui:Class;

		[Embed(source="../res/sound/liandui.mp3")]
		public static var sound_liandui:Class;

		[Embed(source="../res/sound/sange.mp3")]
		public static var sound_sange:Class;

		[Embed(source="../res/sound/shunzi.mp3")]
		public static var sound_shunzi:Class;

		[Embed(source="../res/sound/wangzha.mp3")]
		public static var sound_wangzha:Class;

		[Embed(source="../res/sound/win.mp3")]
		public static var sound_win:Class;

		[Embed(source="../res/sound/zhadan.mp3")]
		public static var sound_zhandan:Class;
		
		// 追加的新的音效，单张的发音和对子的发音都根据牌念出来
		[Embed(source="../res/sound/1.mp3")]
		public static var sound_single_A:Class;
		
		[Embed(source="../res/sound/2.mp3")]
		public static var sound_single_2:Class;
		
		[Embed(source="../res/sound/3.mp3")]
		public static var sound_single_3:Class;
		
		[Embed(source="../res/sound/4.mp3")]
		public static var sound_single_4:Class;
		
		[Embed(source="../res/sound/5.mp3")]
		public static var sound_single_5:Class;
		
		[Embed(source="../res/sound/6.mp3")]
		public static var sound_single_6:Class;
		
		[Embed(source="../res/sound/7.mp3")]
		public static var sound_single_7:Class;
		
		[Embed(source="../res/sound/8.mp3")]
		public static var sound_single_8:Class;
		
		[Embed(source="../res/sound/9.mp3")]
		public static var sound_single_9:Class;
		
		[Embed(source="../res/sound/10.mp3")]
		public static var sound_single_10:Class;
		
		[Embed(source="../res/sound/11.mp3")]
		public static var sound_single_J:Class;
		
		[Embed(source="../res/sound/12.mp3")]
		public static var sound_single_Q:Class;
		
		[Embed(source="../res/sound/13.mp3")]
		public static var sound_single_K:Class;

		[Embed(source="../res/sound/14.mp3")]
		public static var sound_single_52:Class;

		[Embed(source="../res/sound/15.mp3")]
		public static var sound_single_53:Class;
		
		[Embed(source="../res/sound/dui1.mp3")]
		public static var sound_double_A:Class;
		
		[Embed(source="../res/sound/dui2.mp3")]
		public static var sound_double_2:Class;
		
		[Embed(source="../res/sound/dui3.mp3")]
		public static var sound_double_3:Class;
		
		[Embed(source="../res/sound/dui4.mp3")]
		public static var sound_double_4:Class;
		
		[Embed(source="../res/sound/dui5.mp3")]
		public static var sound_double_5:Class;
		
		[Embed(source="../res/sound/dui6.mp3")]
		public static var sound_double_6:Class;
		
		[Embed(source="../res/sound/dui7.mp3")]
		public static var sound_double_7:Class;
		
		[Embed(source="../res/sound/dui8.mp3")]
		public static var sound_double_8:Class;
		
		[Embed(source="../res/sound/dui9.mp3")]
		public static var sound_double_9:Class;
		
		[Embed(source="../res/sound/dui10.mp3")]
		public static var sound_double_10:Class;
		
		[Embed(source="../res/sound/dui11.mp3")]
		public static var sound_double_J:Class;
		
		[Embed(source="../res/sound/dui12.mp3")]
		public static var sound_double_Q:Class;
		
		[Embed(source="../res/sound/dui13.mp3")]
		public static var sound_double_K:Class;
	}
}