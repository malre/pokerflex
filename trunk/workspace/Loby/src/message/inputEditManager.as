package message
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import flashx.textLayout.edit.EditManager;
	import flashx.undo.IUndoManager;
	
	public class inputEditManager extends EditManager
	{
		public function inputEditManager(arg0:IUndoManager=null)
		{
			super(arg0);
		}
		
		override public function keyDownHandler(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.NUMPAD_ENTER || event.keyCode == Keyboard.ENTER)
			{
				// 如果是回车，将会清空自己的输入栏，然后发送send消息
				//Messenger.Instance.send(ContentViewer.Instance.getInputMsg(), Messenger.sendLobby);
				ContentViewer.Instance.addNewMsg(event, 12, 0);
				return;
			}
			super.keyDownHandler(event);
		}
	}
}