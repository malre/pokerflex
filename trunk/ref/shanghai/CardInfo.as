package  
{
	import Def.*;
	import flash.geom.Point;
	/**
	 * ...
	 * @author $(DefaultUser)
	 */
	public class CardInfo 
	{
		public var number:int;
		public var mark:int;
		public var target:int;// -2:打出去的牌 -1:余牌队列中 >=0:PlayerIndex
		public var state:int;// CARD_STATE
		public var position:Point, tarposition:Point;
		public var speed:Point;
		public var open:Boolean;
		
		public function CardInfo(number:int = CARD_NUMBER.NONE, mark:int = CARD_MARK.NONE, state:int = CARD_STATE.NONE, target:int = -1) 
		{
			this.number = number;
			this.mark = mark;
			this.state = state;
			this.target = target;
			position = new Point();
			tarposition = new Point();
			speed = new Point();
			open = false;
		}
		public function IsNull():Boolean
		{
			return number == CARD_NUMBER.NONE;
		}
		public function equals(card:CardInfo):Boolean
		{
			if (this.number == card.number &&
				this.mark == card.mark &&
				this.target == card.target && 
				this.state == card.state &&
				this.position.equals(card.position) && 
				this.tarposition.equals(card.tarposition) && 
				this.speed.equals(card.speed) && 
				this.open == card.open)
			{
				return true;
			}
			
			return false;
		}
	}
}