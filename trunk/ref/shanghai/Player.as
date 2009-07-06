package  
{
	import flash.geom.Point;
	import Def.*;
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class Player 
	{
		public static const CARD_MAX:int = 5;
		
		private var m_name:String;
		private var m_bDead:Boolean = false;
		
		public var CardList:Array;
		
		private var m_index:int;
		
		public function Player(index:int, name:String) 
		{
			m_index = index;
			m_name = name;
			CardList = new Array();
			
		}
		public function ClearCards():void
		{
			CardList.splice(0, CardList.length);
			
		}
		public function GetIndex():int
		{
			return m_index;
		}
		public function GetName():String
		{
			return m_name;
		}
		public function AddCard(card_info:CardInfo):void
		{
			if (!IsCardFull())
			{
				var card:CardInfo = new CardInfo();
				card.number = card_info.number;
				card.mark = card_info.mark;
				card.open = card_info.open;
				card.position = card_info.position;
				card.speed = card_info.speed;
				card.state = card_info.state;
				card.target = card_info.target;
				card.tarposition = card_info.tarposition;
				
				CardList.push(card);
				
				
			}			
		}
		public function IsCardFull():Boolean
		{
			return CardList.length >= CARD_MAX;
		}
		
	}
	
}