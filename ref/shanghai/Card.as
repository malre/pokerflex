package
{
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import flash.events.MouseEvent;
	import Def.*;
		
	/**
	* ...
	* @author QuanYing (Tools -> Custom Arguments...)
	*/
	public class Card extends Sprite
	{
		private var m_number:Number;
		private var m_mark:Number;
		//private var m_btnmode:Boolean;
		private var m_bmw:Number;
		private var m_bmh:Number;
		private var m_bMDownFlag:Boolean;
		private var m_bmd:BitmapData;
		private var m_image:Bitmap;
		private var m_bOpened:Boolean;
		private var m_bActive:Boolean;
				
		public function Card() 
		{			
			//m_btnmode = btnmode;
			m_bMDownFlag = false;
			m_bmw = 79;
			m_bmh = 112;
			m_bActive = false;
		}			
		public function SetPosition(pos_x:Number, pos_y:Number):void
		{
			x = pos_x;
			y = pos_y;
		}
		private function SetNumber(number:Number):void
		{
			m_number = number;
		}
		private function SetMark(mark:Number):void
		{
			m_mark = mark;
		}
		public function Create(par:Sprite, image:Bitmap):void
		{
			par.addChild(this);			
			
			addEventListener(MouseEvent.CLICK, MClick);
						
			m_image = image;
			m_bmd = new BitmapData(m_bmw, m_bmh);
			Reset();
						
			Draw();			
		}
		public function Reset():void
		{
			m_number = CARD_NUMBER.BACK;
			m_mark = CARD_MARK.NONE;
			m_bOpened = false;
			
		}
		public function Draw():void
		{				
			
			var x:Number;
			var y:Number;
			x = m_number == CARD_NUMBER.BACK ? 928 : (m_mark * 109 + ((m_number >= CARD_NUMBER.THREE && m_number <= CARD_NUMBER.NINE) ? 15 : 451));
			y = m_number == CARD_NUMBER.BACK ? 834 : ((m_number - ((m_number >= CARD_NUMBER.THREE && m_number <= CARD_NUMBER.NINE) ? 3 : 10)) * 137 + 17);
			trace("Number:" + CARD_NUMBER.Name[m_number]);
			trace("Mask:" + CARD_MARK.Name[m_mark]);
			var rect:Rectangle = new Rectangle(x, y, m_bmw, m_bmh);
			var pt:Point = new Point(0, 0);
			m_bmd.copyPixels(m_image.bitmapData, rect, pt);
			
			graphics.clear();
			graphics.beginBitmapFill(m_bmd, null, false, false);			
			graphics.drawRect(0, 0, m_bmw, m_bmh);
		}
		public function MClick(event:MouseEvent):void
		{
			trace("MClick");
			if (!m_bOpened)
			{
				SetNumber(int(10 * Math.random()) % 14 + 3);
				//m_number = CARD_NUMBER.JOKER;
				SetMark(m_number == CARD_NUMBER.JOKER ? 1 : (int(10 * Math.random()) % CARD_MARK.MAX));
								
				Draw();
				
				m_bOpened = true;
			}
			
						
			
		}
		
	}
	
}