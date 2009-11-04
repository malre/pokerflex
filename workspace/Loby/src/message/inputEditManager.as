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
				var msg:Object;
				if(inputtype == 0)
				{
					// 首先查看发送的消息是不是有实际内容
					msg = FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg();
					if(msg.content.length <= 0){
						return;
					}
					else if(msg.content.length <= 1)	{
						if(msg.content[0].val == "")
							return;
					}
					// 如果是回车，将会清空自己的输入栏，然后发送send消息
					Messenger.Instance.send(msg, Messenger.sendLobby);
					FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
//					FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox.selectRange(int.MAX_VALUE,int.MAX_VALUE);
//					FlexGlobals.topLevelApplication.customcomponent31.lobbychatbox.scrollToRange(int.MAX_VALUE, int.MAX_VALUE);
				}else if(inputtype == 1){
					// 首先查看发送的消息是不是有实际内容
					msg = FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg();
					if(msg.content.length <= 0){
						return;
					}
					else if(msg.content.length <= 1)	{
						if(msg.content[0].val == "")
							return;
					}
					Messenger.Instance.send(msg, Messenger.sendRoom);
					FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
				}
				return;
			}
			super.keyDownHandler(event);
		}
		public function sendButtonPressed():void
		{
			var msg:Object;
			if(inputtype == 0)
			{
				// 首先查看发送的消息是不是有实际内容
				msg = FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg();
				if(msg.content.length <= 0){
					return;
				}
				else if(msg.content.length <= 1)	{
					if(msg.content[0].val == "")
						return;
				}
				// 如果是回车，将会清空自己的输入栏，然后发送send消息
				Messenger.Instance.send(FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputMsg(), Messenger.sendLobby);
				FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
			}else if(inputtype == 1){
				msg = FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg();
				if(msg.content.length <= 0){
					return;
				}
				else if(msg.content.length <= 1)	{
					if(msg.content[0].val == "")
						return;
				}
				Messenger.Instance.send(FlexGlobals.topLevelApplication.gamePoker.inputboxGame.getInputMsg(), Messenger.sendRoom);
				FlexGlobals.topLevelApplication.gamePoker.inputboxGame.clearInput();
			}
		}
		
		public function shoutButtonPress():void
		{
			var msg:Object;
			if(inputtype == 0)
			{
				// 首先查看发送的消息是不是有实际内容
				msg = FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputShoutMsg();
				if(msg.content.length <= 0){
					return;
				}
				else if(msg.content.length <= 1)	{
					if(msg.content[0].val == "")
						return;
				}
				Messenger.Instance.send(FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.getInputShoutMsg(), Messenger.sendShout);
				FlexGlobals.topLevelApplication.customcomponent31.inputboxLobby.clearInput();
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