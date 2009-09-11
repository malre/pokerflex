package poker.gamestate
{
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.managers.PopUpManager;
	
	import poker.CardViewer;
	import poker.NetManager;
	
	public class StateItemGetPlayedCards extends NetRequestState
	{
		private static var instance:StateItemGetPlayedCards = null;

		public function StateItemGetPlayedCards()
		{
			super();
		}
		public static function get Instance():StateItemGetPlayedCards
		{
			if(instance == null)
				instance = new StateItemGetPlayedCards();
			return instance;
		}
		
		override public function send(obj:StateManager):void
		{
			NetManager.sender.url = NetManager.sendURL_game;
			NetManager.sender.request = {"getHistory":"true"};
			NetManager.sender.send();
		}
		override public function receive(obj:Object):Boolean
		{
			if(super.receive(obj))
			{
				//var popup:CardViewer = CardViewer(PopUpManager.createPopUp(this, CardViewer, true));
				//popup.setCards();
				//popup.visible = false;
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault():void
		{
		}
	}
}