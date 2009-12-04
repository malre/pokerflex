package poker
{
	/**
	 * 
	 * @author Eric
	 * 用来处理当一次发送消息的请求失败的时候，而且该请求不可被恢复。
	 * 对当时的界面进行一定的恢复，比如出牌的请求失败了，那么就恢复出牌按钮为有效
	 * 
	 */	
	public class timeoutDealwithGUI
	{
		public static const ignoreFail:int = 0;
		public static const sendcardFail:int = 1;
		public static const discardFail:int = 2;
		public static const calccardsFail:int = 3;
		public static const notifyReadyFail:int = 4;
		public static const getPlayerLeftcards:int = 5;
		public static const getPlayerScore:int = 6;
		
		private var currentDealState:int = 0;
		
		private static var instance:timeoutDealwithGUI = null;
		
		public function timeoutDealwithGUI()
		{
		}
		
		public static function get Instance():timeoutDealwithGUI
		{
			if(instance == null)
				instance = new timeoutDealwithGUI();
			return instance;
		}
		
		public function deal(state:int):void
		{
			switch(state)
			{
				case ignoreFail:
					break;
				case sendcardFail:
					break;
				case discardFail:
					break;
				case calccardsFail:
					break;
				case notifyReadyFail:
					break;
			}
		}
	}
}