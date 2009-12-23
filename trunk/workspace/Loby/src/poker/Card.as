package poker
{
	import flash.events.MouseEvent;
	
	import mx.controls.Image;
	import mx.core.FlexGlobals;

	public class Card extends Image
	{
		// 该张卡牌的代表数字
		private var _cardid:int;
		// 卡牌是否被选中
		private var _selected:Boolean;
		//
		private var _isSelectedtoPost:Boolean;
		
		public function Card()
		{
			super();
			_selected = false;
			_isSelectedtoPost = false;
		}

		public function get isSelectedtoPost():Boolean
		{
			return _isSelectedtoPost;
		}

		public function set isSelectedtoPost(value:Boolean):void
		{
			_isSelectedtoPost = value;
		}

		public function get selected():Boolean
		{
			return _selected;
		}

		public function set selected(value:Boolean):void
		{
			_selected = value;
		}

		public function get cardid():int
		{
			return _cardid;
		}

		public function set cardid(value:int):void
		{
			_cardid = value;
		}
		
		override protected function clickHandler(event:MouseEvent) : void
		{
			if(name == "Card"){
				_selected = !_selected;
				if(_selected){
					y -= 15;
				}
				else
					y += 15;
				
				if(Game.Instance.gameState == 2)
				{
//					GameObjectManager.Instance.click(event);
					FlexGlobals.topLevelApplication.gamePoker.commandbar.btnSendCards.enabled = Game.Instance.isSendBtnEnable();
				}
			}
		}
	}
}