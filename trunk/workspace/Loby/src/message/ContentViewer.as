package message
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;

	public class ContentViewer extends Sprite
	{
		// instance
		private static var instance:ContentViewer = null;
		// 输入框的文本流
		private var textinput:TextFlow;
		// 文字显示框的文本流
		private var textcontent:TextFlow;
		
		private var p:ParagraphElement = new ParagraphElement();

		public var img:InlineGraphicElement = new InlineGraphicElement();

		public static function get Instance():ContentViewer
		{
			if(instance == null)
				instance = new ContentViewer();
			
			return instance;
		}
		public function ContentViewer()
		{
			super();
			textinput = new TextFlow();
			createInputbox(14, 426, 188, 20);
			textcontent = new TextFlow();
			//createTextLine(15,199, 256, 207);
			createTextLine(14, 400, 188, 20);
		}
		public function createTextLine(x:int, y:int, width:int, height:int):void
		{
//			textcontent.interactionManager = new SelectionManager();
			
			var sprite:Sprite = new Sprite();
			sprite.x=x;
			sprite.y=y;		
			textcontent.fontFamily = "Arial";
			textcontent.fontSize = 12;
			textcontent.lineBreak = "explicit";
			
			textcontent.flowComposer.addController(new ContainerController(sprite, width, height));
			textcontent.flowComposer.updateAllControllers();
			
			// event sent when graphic is done loading
			//textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGED,graphicStatusChangeEvent);
		}
		public function graphicStatusChangeEvent(evt:Event):void
		{
//			textFlow.flowComposer.updateAllControllers();
//			img.width = 12;
//			img.height = 12;
		}
		private function createInputbox(x:Number, y:Number, width:Number, height:Number, text:String = ""):void
		{
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;
			g.beginFill(0xEEEEEE);
			g.drawRect(0, 0, width, height);
			g.endFill();
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
			
			sprite = new Sprite();
			sprite.x = x;
			sprite.y = y+5;
			addChild(sprite);
			
			textinput.addChild(p);
			textinput.interactionManager = new inputEditManager();
					
			textinput.fontFamily = "Arial";
			textinput.fontSize = 12;
			textinput.lineBreak = "explicit";
			
			textinput.flowComposer.addController(new ContainerController(sprite, width, height));
			textinput.flowComposer.updateAllControllers();
		}
		
		/**
		 * 向当前的话语的最后，加入指定id的表情符号
		 * @param id
		 * 	表情的编号
		 * @Notes
		 * 	每次的改动之后都需要进行一次update更新调用
		 */
		public function insertEmotion(id:int):void
		{
			var num:int = textinput.numChildren;
			var img:InlineGraphicElement = new InlineGraphicElement();
			img.width = 12;
			img.height = 12;
			img.source = ResEmotion.Emo000;
			img.id = "Emotion";
			p.addChild(img);
//			var edit:EditManager = EditManager(textinput.interactionManager);
//			edit.insertInlineGraphic(img, img.width, img.height);
			textinput.flowComposer.updateAllControllers();
//			textinput.flowComposer.setFocus(1);
		}
		public function getInputMsg():Object
		{
			var obj:Object = encode();
				return obj;
//			ChatNetManager.Instance.send(str, ChatNetManager.sendLobby);
		}
		private function encode():Object
		{
			var obj:Object;
			var num:int = p.numChildren;
			var output:Object = new Object(); 
			output.size = textinput.fontSize;
			if(textinput.color == null)
				output.color = 0;
			else
				output.color = textinput.color;
			output.content = new Array();
			for(var i:int;i<num;i++)
			{
				var ef:FlowElement = p.getChildAtIndex(i);
				if(ef.id == "Emotion")
				{
					obj = new Object();
					obj.type = "img";
					obj.val = ef.id;
					output.content.push(obj);
				}
				else
				{
					obj = new Object();
					obj.type = "text";
					obj.val = FlowLeafElement(ef).text;
					output.content.push(obj);
				}
			}
			return output;
		}
		/**
		 * 把得到的新的消息加入到显示 
		 * @param str
		 * 
		 */		
		public function addNewMsg(obj:Object, fontsize:int, color:int):void
		{
			var pp:ParagraphElement = new ParagraphElement();
			var span:SpanElement = new SpanElement();
			span.text = "hello world";
			pp.addChild(span);
			pp.fontSize = fontsize;
			//pp.color == color;
			textcontent.addChild(pp);
			textcontent.flowComposer.updateAllControllers();
		}
	}
}