package message
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.edit.EditManager;
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
		override public function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.NUMPAD_ENTER || event.keyCode == Keyboard.ENTER)
			{
				if(inputtype == 0)
				{
					// 如果是回车，将会清空自己的输入栏，然后发送send消息
					Messenger.Instance.send(FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg(), Messenger.sendLobby);
					FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
				}else if(inputtype == 1){
					Messenger.Instance.send(FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg(), Messenger.sendRoom);
					FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
				}
				return;
			}
			super.keyDownHandler(event);
		}
		public function sendButtonPressed():void
		{
			if(inputtype == 0)
			{
				// 如果是回车，将会清空自己的输入栏，然后发送send消息
				Messenger.Instance.send(FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg(), Messenger.sendLobby);
				FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
			}else if(inputtype == 1){
				Messenger.Instance.send(FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg(), Messenger.sendRoom);
				FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
			}
		}
		
		public function shoutButtonPress():void
		{
			if(inputtype == 0)
			{
				Messenger.Instance.send(FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg(), Messenger.sendShout);
				FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
			}
			else if(inputtype == 1){
				Messenger.Instance.send(FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg(), Messenger.sendShout);
				FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
			}
		}
	}
}