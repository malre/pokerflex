package
{
	// 这个类用来记录所有的错误情况，并针对错误进行分类处理
	// 在网络类收到消息以后，可以对这个类进行设置，然后主流程会询问错误的情况，来决定后面的走向
	public class LobyErrorState
	{
		// 错误归类，
		// A严重错误  B一般性错误  C可忽略错误
		// A类指，该错误使程序无法正常进行下去的错误， B类值错误可以通过继续请求来改善 C类可以忽视，关系不大
		// 
		// error list
		// 1--100 A  
		public static const ERR_NOERROR:int = 0;
		public static const ERR_NOTLOGIN:int = 1;
		//public const var ERR_
		// 101-200 B  
		public static const ERR_JSONDECODE:int = 101;
		// 201-300 C
		//
		private var _errorId:int = 0; 
		
		private static var instance:LobyErrorState;
		
		public function LobyErrorState()
		{
		}
		
		static public function get Instance():LobyErrorState
		{
			if(instance == null)
				instance = new LobyErrorState();
			return instance;
		}
		
		public function get errorId():int
		{
			return _errorId;
		}

		public function set errorId(v:int):void
		{
			if(v < 0){
				trace("set error id wrong"+v);
			}
//			if(v >
			
			_errorId = v;
		}

	}
}