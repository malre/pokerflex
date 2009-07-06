package
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	
	/**
	* ...
	* @author QuanYing (Tools -> Custom Arguments...)
	*/
	public class Key extends EventDispatcher
	{
		public static const UP:int = 38;
		public static const DOWN:int = 40;
		public static const LEFT:int = 37;
		public static const RIGHT:int = 39;
		public static const SHIFT:int = 16;
		public static const ESC:int = 27;
		public static const ENTER:int = 13;
		public static const A:int = 65;
		public static const a:int = 97;
		public static const B:int = 66;
		public static const b:int = 98;
		public static const G:int = 71;
		public static const g:int = 103;
		public static const H:int = 72;
		public static const h:int = 104;
		public static const P:int = 80;
		public static const p:int = 112;
		public static const ZERO:int = 48;
		public static const NUMPAD_ZERO:int = 96;
		
		/**
		 * 初始化 Key, 传入 stage 对象, 否则无法开始侦听, 在首次使用 Key 前记得跑一下这个函数
		 * @param stage Stage
		 * 
		 */
		public static function init (stage:Stage):void 
		{
			key = new Key(stage);
		}
		
		
		/**
		 * 检测键是否按下
		 * 
		 * // 检测左上键是否同时按下, 结果存放在 result 中
		 * var result:Boolean = Key.isDown(Key.UP, Key.LEFT);
		 * @param keyCodes 键码
		 * @return 如果按下返回 true, 否则 false
		 * 
		 */		
		public static function isDown ( ... keyCodes:Array):Boolean 
		{
			
			return key.isDown(keyCodes);
		}
		/**
		 * 检测键是否弹起
		 * 
		 * // 检测左上键是否同时按下, 结果存放在 result 中
		 * var result:Boolean = Key.isDown(Key.UP);
		 * @param keyCode 键码
		 * @return 如果弹起返回 true, 否则 false
		 * 
		 */		
		public static function isUp (keyCode:int):Boolean 
		{			
			return key.isUp(keyCode);
		}
		public static function Reset():void 
		{			
			key.upKey = 0;
			key.pressedKeys.splice(0, key.pressedKeys.length);
		}
		
		public static function registerKeyActions (action:Function, ... keyCodes:Array /* of uint */):void 
		{
			
		}
		
		
		/**
		* 存放 Key 实例
		*/
		private static var key:Key;
		
		
		/**
		* 存放已经按下的键
		*/
		private var pressedKeys:Array = new Array(0xFF);
		private var upKey:int = 0;
		
		
		/**
		* 存放最后一个按下的键
		*/
		private var lastPressedKey:uint;
		
		
		/**
		* 存放 stage 引用
		*/
		private var stage:Stage;
		
		
		/**
		 * 静态类, 这辈子不需要实例化
		 * @return 
		 * 
		 */
		public function Key (stage:Stage) 
		{
			this.stage = stage;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, downHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, upHandler);
		}
		
		
		/**
		 * 检测键是否同时按下
		 * @param keyCodes 键码
		 * @return 
		 * 
		 */
		private function isDown (keyCodes:Array):Boolean 
		{
			var len:int = keyCodes.length;
			for (var i:int; i < len; i++) 
			{
				if (! (pressedKeys[keyCodes[i]] as Boolean) )
					return false;
			}
			return true;	
		}
		private function isUp (keyCode:int):Boolean 
		{
			if (upKey != keyCode)
			{
				return false;
			}
			
			upKey = 0;
			return true;	
		}
		
		
		private function downHandler(e:KeyboardEvent):void 
		{
			pressedKeys[e.keyCode] = true;
		}
		
		private function upHandler (e:KeyboardEvent):void 
		{
			delete pressedKeys[e.keyCode];
			upKey = e.keyCode;
		}
		
		
		/**
		 * 移除针对 stage 的侦听
		 * 
		 */
		private function dispose ():void 
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, downHandler);
			stage.removeEventListener(KeyboardEvent.KEY_UP, upHandler);
		}
		
	}
	
}