package  
{
	import Def.*;
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class Type 
	{
		public var cardtype:int;
		public var start:int;
		public var length:int;
		
		public function Type() 
		{
			Reset();
		}
		public function Reset():void
		{
			cardtype = CARD_TYPE.NONE;
			start = CARD_NUMBER.NONE;
			length = 0;
		}
		
	}
	
}