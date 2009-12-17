package poker.gamestate
{
	import flash.events.Event;
	
	import lobystate.NetRequestState;
	import lobystate.StateManager;
	
	import mx.core.FlexGlobals;
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
				PopUpManager.createPopUp(FlexGlobals.topLevelApplication.gameRoomCanvas, CardViewer, true);
//				var popup:CardViewer = CardViewer(PopUpManager.createPopUp(null, CardViewer, true)).setCardsData(obj.history);
//				popup.setCardsData(obj.history);
//				popup.visible = false;
				return true;
			}
			else{
				return false;
			}
			
		}
		override public function fault(event:Event):void
		{
		}
	}
}