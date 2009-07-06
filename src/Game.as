package
{
	public class Game
	{
		protected static var instance:Game = null;
		// 总牌数
		private static var cardsAmount:int = 54;

		public function Game()
		{
			//TODO: implement function
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
				GameObjectManager.Instance.addBaseObject(new GameObject());
			}
		}
		
		public function taskLoop():void
		{
    		GameObjectManager.Instance.enterFrame();
		} 
	}
}