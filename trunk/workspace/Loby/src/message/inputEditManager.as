package message
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.elements.TextFlow;
	import flashx.undo.IUndoManager;
	
	import mx.core.FlexGlobals;
	
	public class inputEditManager extends EditManager
	{
		private var inputtype:int = 0;
		public function inputEditManager(arg0:IUndoManager=null)
		{
			super(arg0);
		}
		/**
		 * 用来指定输入的框在哪个界面中
		 * @param type
		 * 0 lobby, 1 game
		 */
		public function settype(type:int):void
		{
			inputtype = type;
		}
		
		public function shoutButtonPress():void
		{
			var msg:Object;
			if(inputtype == 0)
			{
				// 首先查看发送的消息是不是有实际内容
				msg = FlexGlobals.topLevelApplication.functionpanel.inputboxLobby.getInputShoutMsg();
				if(msg.content.length <= 0){
					return;
				}
				else if(msg.content.length <= 1)	{
					if(msg.content[0].val == "")
						return;
				}
				Messenger.Instance.send(FlexGlobals.topLevelApplication.functionpanel.inputboxLobby.getInputShoutMsg(), Messenger.sendShout);
				FlexGlobals.topLevelApplication.functionpanel.inputboxLobby.clearInput();
			}
			else if(inputtype == 1){
				// 首先查看发送的消息是不是有实际内容
				msg = FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputShoutMsg();
				if(msg.content.length <= 0){
					return;
				}
				else if(msg.content.length <= 1)	{
					if(msg.content[0].val == "")
						return;
				}
				Messenger.Instance.send(FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputShoutMsg(), Messenger.sendShout);
				FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
			}
		}
	}
}