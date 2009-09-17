package message
{
/**
* 不可否认，在设计这个类的时候，我出现了偏差，事实上，这个类应该是包含了输入和显示的2个部分，
 * 但是在实际生成的时候， 因为在画面上显示输入的问题，所以实际上我是分开生成了2个类来处理。
*/
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.edit.EditManager;
	import flashx.textLayout.edit.SelectionManager;
	import flashx.textLayout.elements.FlowElement;
	import flashx.textLayout.elements.FlowLeafElement;
	import flashx.textLayout.elements.InlineGraphicElement;
	import flashx.textLayout.elements.ParagraphElement;
	import flashx.textLayout.elements.SpanElement;
	import flashx.textLayout.elements.TextFlow;
	
	import json.JSON;

	public class ContentViewer extends Sprite
	{
		// instance
		private static var instance:ContentViewer = null;
		// 输入框的文本流
		public var textinput:TextFlow;
		// 文字显示框的文本流
		public var textcontent:TextFlow;
		
		private var p:ParagraphElement = new ParagraphElement();

		public var img:InlineGraphicElement = new InlineGraphicElement();
		
		public var controller:ContainerController;

		public static function get Instance():ContentViewer
		{
			if(instance == null)
				instance = new ContentViewer();
			
			return instance;
		}
		public function ContentViewer()
		{
			super();
		}
		public function createTextLine(x:int, y:int, width:int, height:int):Sprite
		{
			textcontent = new TextFlow();
			textcontent.interactionManager = new SelectionManager();
			
			var sprite:Sprite = new Sprite();
			sprite.x=x;
			sprite.y=y;		
			addChild(sprite);
			textcontent.fontFamily = "Arial";
			textcontent.fontSize = 12;
			//textcontent.lineBreak = "explicit";
			
			controller = new ContainerController(sprite, width, height);
			textcontent.flowComposer.addController(controller);
			textcontent.flowComposer.updateAllControllers();
			
			// event sent when graphic is done loading
			//textFlow.addEventListener(StatusChangeEvent.INLINE_GRAPHIC_STATUS_CHANGED,graphicStatusChangeEvent);
			return this;
		}
		public function graphicStatusChangeEvent(evt:Event):void
		{
//			textFlow.flowComposer.updateAllControllers();
//			img.width = 12;
//			img.height = 12;
		}
		public function createInputbox(x:Number, y:Number, width:Number, height:Number, type:int, text:String = ""):Sprite
		{
			textinput = new TextFlow();
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
			var ie:inputEditManager = new inputEditManager();
			ie.settype(type);
			textinput.interactionManager = ie;
					
			textinput.fontFamily = "Arial";
			textinput.fontSize = 12;
			textinput.lineBreak = "explicit";
			
			controller = new ContainerController(sprite, width, height);
			textinput.flowComposer.addController(controller);
			textinput.flowComposer.updateAllControllers();
			
			return this;
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
			img.source = ResEmotion.EmotionRes[id];
			img.id = "Emotion"+id;
			p.addChild(img);
//			var edit:EditManager = EditManager(textinput.interactionManager);
//			edit.insertInlineGraphic(img, img.width, img.height);
			textinput.flowComposer.updateAllControllers();
//			textinput.flowComposer.setFocus(1);
		}
		public function clearInput():void
		{
			var pt:ParagraphElement = ParagraphElement(textinput.getChildAtIndex(0));
			// 默认，选中所有的文字 
			textinput.interactionManager.setSelection();
			// 删除所有选中的文字
			EditManager(textinput.interactionManager).deleteText();
			textinput.flowComposer.updateAllControllers();
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
				if(ef.id != null)
				{
					if(ef.id.substr(0,7) == "Emotion")
					{
						obj = new Object();
						obj.type = "img";
						obj.val = ef.id.substr(7);
						output.content.push(obj);
					}
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
		public function addNewMsg(obj:Object):void
		{
			var pp:ParagraphElement = new ParagraphElement();
			var data:Object = JSON.decode(obj.message);
			for(var i:int=0; i<data.content.length; i++)
			{
				if(data.content[i].type == "text")
				{
					var span:SpanElement = new SpanElement();
					if(i == 0)
						span.text = "["+obj.name+"]:"+ data.content[i].val;
					else
						span.text = data.content[i].val;
					pp.addChild(span);
				}
				else if(data.content[i].type == "img"){
					var img:InlineGraphicElement = new InlineGraphicElement();
					img.width = data.size;
					img.height = data.size;
					img.source = ResEmotion.EmotionRes[data.content[i].val];
					pp.addChild(img);
				}
			}
			
			pp.fontSize = data.size;
			if(pp.color != null)
				pp.color = data.color;
			textcontent.addChild(pp);
			textcontent.flowComposer.updateAllControllers();
		}
	}
}