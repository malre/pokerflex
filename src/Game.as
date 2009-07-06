package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.collections.ArrayCollection;
	
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		private static var cardsAmount:int = 54;
		// 定义所有的牌在整图中的位置
		// 所有的牌的定义，按照花色的顺序从 黑桃-》红桃-》梅花-》方块
		// 牌值从 A开始到K结束,因为我对arraycollection不熟悉，所以是AAAA，然后2222,然后3333的顺序
		// 最后的53，54是joker--司令。
		private static var cardsRect:ArrayCollection = new ArrayCollection();
		//
		public static var cardsWidth:int = 79;
		public static var cardsHeight:int = 109;
		public static var cardsIntervalX:int = 31;
		public static var cardsIntervalY:int = 28;

		public function Game()
		{
			//TODO: implement function
			var i:int;
			var j:int;
			for(i=0;i<2;i++)
			{
				for(j=0;j<4;j++)
				{
					cardsRect.addItem(new Rectangle(451+j*(cardsWidth+cardsIntervalX),
					19+4*(cardsHeight+cardsIntervalY)+i*(cardsHeight+cardsIntervalY),
					cardsWidth,cardsHeight));
//					j*13+i);
				}
			}
			for(i=0;i<7;i++)
			{
				for(j=0;j<4;j++)
				{
					cardsRect.addItem(new Rectangle(15+j*(cardsWidth+cardsIntervalX),
					19+i*(cardsHeight+cardsIntervalY),
					cardsWidth,cardsHeight));
//					2+j*13+i);
				}
			}
			for(i=0;i<4;i++)
			{
				for(j=0;j<4;j++)
				{
					cardsRect.addItem(new Rectangle(451+j*(cardsWidth+cardsIntervalX),
					19+i*(cardsHeight+cardsIntervalY),
					cardsWidth,cardsHeight)); 
//					9+j*13+i);
				}
			}
			cardsRect.addItemAt(new Rectangle(451,
			19+6*(cardsHeight+cardsIntervalY),
			cardsWidth,cardsHeight), 
			52);
			cardsRect.addItemAt(new Rectangle(451+(cardsWidth+cardsIntervalX),
			19+6*(cardsHeight+cardsIntervalY),
			cardsWidth,cardsHeight), 
			53);
		}
		static public function get Instance():Game
		{
			if ( instance == null )
				instance = new Game();
			return instance;
		}
		
		// 初始化所有的54张牌，如果是双扣，就是108张
		public function init():void
		{
			GameObjectManager.Instance.startup();

			for(var i:int=0; i<2/* cardsAmount*2 */; i++)
			{
				var go:GameObject = new GameObject();
				// 传入的是左上的位置坐标
				go.startupGameObject(ResourceManager.CardsRes, new Point(0, 0), Rectangle(cardsRect.getItemAt(8)));
				GameObjectManager.Instance.addBaseObject(go);
			}
		}
		
		public function taskLoop():void
		{
    		GameObjectManager.Instance.enterFrame();
		} 
	}
}