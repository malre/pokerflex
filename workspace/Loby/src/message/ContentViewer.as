package message
{
/**
* 不可否认，在设计这个类的时候，我出现了偏差，事实上，这个类应该是包含了输入和显示的2个部分，
 * 但是在实际生成的时候， 因为在画面上显示输入的问题，所以实际上我是分开生成了2个类来处理。
 * 这是因为这个类中的2个部分需要在不同的容器下工作
*/
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.engine.TextBaseline;
	
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

		public var controller:ContainerController;
		// 玩家输入的字体的大小
		private const fontsizeMin:int = 12;
		private const fontsizeDef:int = 12;
		private const fontsizeMax:int = 26;
		public var fontsize:int = fontsizeDef;
		// 玩家选择的字的颜色
		public var fontcolor:int = 0xffffff;

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
			textcontent.color = 0xffffff;
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
//			textinput.alignmentBaseline = flash.text.engine.TextBaseline.ASCENT;
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;
			g.beginFill(0x02120b);
			g.drawRect(0, 0, width, height);
			g.endFill();
			sprite.x = x;
			sprite.y = y;
			addChild(sprite);
			
			sprite = new Sprite();
			sprite.x = x;
			sprite.y = y+3;
			addChild(sprite);
			
			textinput.addChild(p);
			var ie:inputEditManager = new inputEditManager();
			ie.settype(type);
			textinput.interactionManager = ie;
					
			textinput.fontFamily = "宋体";
			textinput.fontSize = 12;
			textinput.lineBreak = "explicit";
			textinput.color = 0xffffff;
			
			controller = new ContainerController(sprite, width, height);
			textinput.flowComposer.addController(controller);
			textinput.flowComposer.updateAllControllers();
			
			return this;
		}
		public function changeInputColor(color:int):void
		{
			textinput.color = color;
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
			img.width = 12+4;
			img.height = 12+4;
			img.source = ResEmotion.EmotionRes[id];
			img.alignmentBaseline = flash.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM;
			img.id = "Emotion"+id;
			p.addChild(img);
//			var edit:EditManager = EditManager(textinput.interactionManager);
//			edit.insertInlineGraphic(img, img.width, img.height);
			textinput.flowComposer.updateAllControllers();
//			textinput.flowComposer.setFocus(1);
		}
		public static function insertEmotion(id:int, tf:TextFlow):void
		{
			var img:InlineGraphicElement = new InlineGraphicElement();
			img.width = 12+4;
			img.height = 12+4;
			img.source = ResEmotion.EmotionRes[id];
//			img.alignmentBaseline = flash.text.engine.TextBaseline.IDEOGRAPHIC_BOTTOM;
			img.id = "Emotion"+id;
			tf.addChild(img);
		}
		public function clearInput():void
		{
			// 默认，选中所有的文字 
			textinput.interactionManager.selectAll();// .setSelection();
			// 删除所有选中的文字
			EditManager(textinput.interactionManager).deleteText();
			textinput.flowComposer.updateAllControllers();
		}
		public function clearContent():void
		{
			// 使用了替换来删除过往的记录，不知道会不会有问题，有待观察
			textcontent.replaceChildren(0, textcontent.numChildren);
			textcontent.flowComposer.updateAllControllers();
		}
		// 获得发送的普通数据
		public function getInputMsg():Object
		{
			var obj:Object = encode(0);
				return obj;
//			ChatNetManager.Instance.send(str, ChatNetManager.sendLobby);
		}
		// 获得喊叫的数据，过滤掉非文本信息
		public function getInputShoutMsg():Object
		{
			var obj:Object = encode(1);
			return obj;
		}
		/**
		 * @param type
		 * 	0->normal message, include graphics, 1->shout message, only text
		 * @return 
		 * 
		 */		
		private function encode(type:int):Object
		{
			var obj:Object;
			var num:int = p.numChildren;
			var output:Object = new Object(); 
			output.size = fontsize;
			if(textinput.color == null)
				output.color = 0xffffff;
			else
				output.color = textinput.color;
			output.content = new Array();
			for(var i:int;i<num;i++)
			{
				var ef:FlowElement = p.getChildAt(i);
				if(ef.id != null)
				{
					if(ef.id.substr(0,7) == "Emotion" && type != 1)
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
			var span:SpanElement;
			span = new SpanElement();
			span.text = "["+obj.name+"]:";
			span.color = 0xffff66;
			span.fontSize = 12;
			pp.addChild(span);
			for(var i:int=0; i<data.content.length; i++)
			{
				if(data.content[i].type == "text")
				{
					span = new SpanElement();
					span.text = data.content[i].val;
					pp.addChild(span);
				}
				else if(data.content[i].type == "img"){
					var img:InlineGraphicElement = new InlineGraphicElement();
					img.width = data.size+4;
					img.height = data.size+4;
					img.source = ResEmotion.EmotionRes[data.content[i].val];
					pp.addChild(img);
				}
			}
			
			pp.fontSize = data.size;
			if(data.color != null)
				pp.color = data.color;
			else
				pp.color = 0xffffff;
			textcontent.addChild(pp);
			textcontent.flowComposer.updateAllControllers();
		}
		public function setFontSize(size:int):void
		{
			
		}
		public function setColor(col:int):void
		{
			
		}
	}
}