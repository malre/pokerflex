package poker
{
	import flash.display.*;
	import flash.geom.*;
	
	import mx.collections.ArrayCollection;
	import mx.core.*;
	
	public final class ResourceManagerPoker
	{
		public static var CardsRes:ArrayCollection = new ArrayCollection();
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

		[Embed(source="../res/09.gif")]
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

//		[Embed(source="../res/54.png")]							// back of card
//		public static var Card54:Class;

		CardsRes.addItem(new GraphicsResource(new Card02()));		//3	方蝮需 	0
		CardsRes.addItem(new GraphicsResource(new Card15()));		//	草花		1
		CardsRes.addItem(new GraphicsResource(new Card28()));		//	 郤｢桃	2
		CardsRes.addItem(new GraphicsResource(new Card41()));		//  黑桃		3

		CardsRes.addItem(new GraphicsResource(new Card03()));		//4
		CardsRes.addItem(new GraphicsResource(new Card16()));
		CardsRes.addItem(new GraphicsResource(new Card29()));
		CardsRes.addItem(new GraphicsResource(new Card42()));

		CardsRes.addItem(new GraphicsResource(new Card04()));
		CardsRes.addItem(new GraphicsResource(new Card17()));
		CardsRes.addItem(new GraphicsResource(new Card30()));
		CardsRes.addItem(new GraphicsResource(new Card43()));

		CardsRes.addItem(new GraphicsResource(new Card05()));
		CardsRes.addItem(new GraphicsResource(new Card18()));
		CardsRes.addItem(new GraphicsResource(new Card31()));
		CardsRes.addItem(new GraphicsResource(new Card44()));

		CardsRes.addItem(new GraphicsResource(new Card06()));
		CardsRes.addItem(new GraphicsResource(new Card19()));
		CardsRes.addItem(new GraphicsResource(new Card32()));
		CardsRes.addItem(new GraphicsResource(new Card45()));

		CardsRes.addItem(new GraphicsResource(new Card07()));
		CardsRes.addItem(new GraphicsResource(new Card20()));
		CardsRes.addItem(new GraphicsResource(new Card33()));
		CardsRes.addItem(new GraphicsResource(new Card46()));

		CardsRes.addItem(new GraphicsResource(new Card08()));
		CardsRes.addItem(new GraphicsResource(new Card21()));
		CardsRes.addItem(new GraphicsResource(new Card34()));
		CardsRes.addItem(new GraphicsResource(new Card47()));

		CardsRes.addItem(new GraphicsResource(new Card09()));		// 10
		CardsRes.addItem(new GraphicsResource(new Card22()));
		CardsRes.addItem(new GraphicsResource(new Card35()));
		CardsRes.addItem(new GraphicsResource(new Card48()));

		CardsRes.addItem(new GraphicsResource(new Card10()));		// J
		CardsRes.addItem(new GraphicsResource(new Card23()));
		CardsRes.addItem(new GraphicsResource(new Card36()));
		CardsRes.addItem(new GraphicsResource(new Card49()));

		CardsRes.addItem(new GraphicsResource(new Card11()));		// Q
		CardsRes.addItem(new GraphicsResource(new Card24()));
		CardsRes.addItem(new GraphicsResource(new Card37()));
		CardsRes.addItem(new GraphicsResource(new Card50()));

		CardsRes.addItem(new GraphicsResource(new Card12()));		// K
		CardsRes.addItem(new GraphicsResource(new Card25()));
		CardsRes.addItem(new GraphicsResource(new Card38()));
		CardsRes.addItem(new GraphicsResource(new Card51()));

		CardsRes.addItem(new GraphicsResource(new Card00()));		// A
		CardsRes.addItem(new GraphicsResource(new Card13()));
		CardsRes.addItem(new GraphicsResource(new Card26()));
		CardsRes.addItem(new GraphicsResource(new Card39()));
		CardsRes.addItem(new GraphicsResource(new Card01()));		// 2
		CardsRes.addItem(new GraphicsResource(new Card14()));
		CardsRes.addItem(new GraphicsResource(new Card27()));
		CardsRes.addItem(new GraphicsResource(new Card40()));

		CardsRes.addItem(new GraphicsResource(new Card52()));
		CardsRes.addItem(new GraphicsResource(new Card53()));
		
		gameCardsRes.addItem(Card02);
		gameCardsRes.addItem(Card15);		//	草花		1
		gameCardsRes.addItem(Card28);		//	 郤｢桃	2
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


		
		[Embed(source="../res/BG.png")]							// background
		public static var BG00:Class;
		public static var BG00Res:GraphicsResource = new GraphicsResource(new BG00());

		[Embed(source="../res/cardback1.png")]
		public static var cardback1:Class;
		public static var CardBack1Res:GraphicsResource = new GraphicsResource(new cardback1());

		[Embed(source="../res/sound/start.mp3")]
		public static var sound01:Class;
		public static var SoundStart:SoundAsset = new sound01() as SoundAsset;	

		[Embed(source="../res/sound/baojing.mp3")]
		public static var sound02:Class;
		public static var SoundYizhang:SoundAsset = new sound02() as SoundAsset;	

		[Embed(source="../res/sound/buyao.mp3")]
		public static var sound03:Class;
		public static var SoundPass:SoundAsset = new sound03() as SoundAsset;	

		[Embed(source="../res/sound/dui.mp3")]
		public static var sound04:Class;
		public static var SoundDuizi:SoundAsset = new sound04() as SoundAsset;	

		[Embed(source="../res/sound/liandui.mp3")]
		public static var sound05:Class;
		public static var SoundLiandui:SoundAsset = new sound05() as SoundAsset;	

		[Embed(source="../res/sound/sange.mp3")]
		public static var sound06:Class;
		public static var SoundSange:SoundAsset = new sound06() as SoundAsset;	

		[Embed(source="../res/sound/shunzi.mp3")]
		public static var sound07:Class;
		public static var SoundShunzi:SoundAsset = new sound07() as SoundAsset;	

		[Embed(source="../res/sound/wangzha.mp3")]
		public static var sound08:Class;
		public static var SoundWangzha:SoundAsset = new sound08() as SoundAsset;	

		[Embed(source="../res/sound/win.mp3")]
		public static var sound09:Class;
		public static var SoundWin:SoundAsset = new sound09() as SoundAsset;	

		[Embed(source="../res/sound/zhadan.mp3")]
		public static var sound10:Class;
		public static var SoundZhadan:SoundAsset = new sound10() as SoundAsset;	
	}
}