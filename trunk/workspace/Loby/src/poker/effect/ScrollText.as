package poker.effect
{
	import flash.text.engine.FontWeight;
	
	import mx.controls.Label;

	public class ScrollText extends Label
	{
		// 
		private var startX:int = 0;
		private var startY:int = 0;
		private var endX:int = 0;
		private var endY:int = 0;
		
		private var autoAlignCenter:Boolean = false;
		
		public function ScrollText()
		{
		}
		
		public function start(sx:int, sy:int, ex:int, ey:int, size:int, align:Boolean=false):void
		{
			startX = sx;
			startY = sy;
			endX = ex;
			endY = ey;
			FontWeight = size;
		}
	}
}