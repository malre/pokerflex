package poker
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.*;
	
	import mx.collections.*;
	import mx.core.*;
	
	import spark.components.Group;
	
	public class GameObjectManager
	{
		// double buffer
		public var backBuffer:BitmapData;
		// colour to use to clear backbuffer with 
		public var clearColor:uint = 0xFF849AA5;
		// static instance 
		protected static var instance:GameObjectManager = null;
		// the last frame time 
		protected var lastFrame:Date;
		// a collection of the BaseObjects 
		protected var baseObjects:ArrayCollection = new ArrayCollection();
		// a collection where new BaseObjects are placed, to avoid adding items 
		// to baseObjects while in the baseObjects collection while it is in a loop
		protected var newBaseObjects:ArrayCollection = new ArrayCollection();
		// a collection where removed BaseObjects are placed, to avoid removing items 
		// to baseObjects while in the baseObjects collection while it is in a loop
		protected var removedBaseObjects:ArrayCollection = new ArrayCollection();
		
		static public function get Instance():GameObjectManager
		{
			if ( instance == null )
			instance = new GameObjectManager();
			return instance;
		}
		
		public function GameObjectManager()
		{
			if ( instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" ); 
				
			backBuffer = new BitmapData(FlexGlobals.topLevelApplication.width, FlexGlobals.topLevelApplication.height, false);
		}
		
		public function startup():void
		{
			lastFrame = new Date();			
		}
		
		public function shutdown():void
		{
			shutdownAll();
		}
		
		public function enterFrame():void
		{
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrame.getTime())/1000.0;
	    	lastFrame = thisFrame;
	    	
	    	removeDeletedBaseObjects();
	    	insertNewBaseObjects();
	    	
	    	// now allow objects to update themselves
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.enterFrame(seconds);
			
			// 对所有集合中的元素按照Z值来进行排序
			var sort:Sort = new Sort()
			sort.compareFunction = sortFunction;
			baseObjects.sort = sort;
			baseObjects.refresh();
			sort = null;
	    	
	    	drawObjects();
		}
		public function sortFunction(a:GameObject, b:GameObject, fields:Array=null):int
		{
			var i:int = a.zOrder;
			var j:int = b.zOrder;
			if(i > j) return 1;
			else if(i == j) return 0;
			else return -1;
		}
		
		public function click(event:MouseEvent):void
		{
			// 检测 ZOrder，然后然找优先级来进行点击传递，一旦一个点击被处理了，就直接返回。
			for(var i:int=0;i<baseObjects.length;i++)
			{
				var gameObject:BaseObject = BaseObject(baseObjects.getItemAt(baseObjects.length-1-i)); 
				if (gameObject.inuse && gameObject.getVisible())
				{ 
					if(gameObject.click(event))
					{
						return;
					}
				}
			}
		}
		
		public function removeSendCards():void
		{
			for each(var gameObject:GameObject in baseObjects)
			{
				if (gameObject.selected)
				{ 
					gameObject.shutdown();
				}
			}
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseDown(event);
		}
		
		public function mouseUp(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseUp(event);
		}
		
		public function mouseMove(event:MouseEvent):void
		{
			for each (var gameObject:BaseObject in baseObjects)
				if (gameObject.inuse) 
					gameObject.mouseMove(event);
		}
		
		protected function drawObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, clearColor);
			
			// draw the objects
			for each (var baseObject:BaseObject in baseObjects)
				if (baseObject.inuse && baseObject.getVisible())
					baseObject.copyToBackBuffer(backBuffer);
		}
				
		public function addBaseObject(baseObject:BaseObject):void
		{
			newBaseObjects.addItem(baseObject);
		}
		
		public function removeBaseObject(baseObject:BaseObject):void
		{
			removedBaseObjects.addItem(baseObject);
		}
		
		protected function shutdownAll():void
		{
			for each (var baseObject:BaseObject in baseObjects)
			{
				baseObject.setVisible(false);
			}
			// don't dispose objects twice
/* 			for each (var baseObject:BaseObject in baseObjects)
			{
				var found:Boolean = false;
				for each (var removedObject:BaseObject in removedBaseObjects)
				{
					if (removedObject == baseObject)
					{
						found = true;
						break;
					}
				}
				
				if (!found)
					baseObject.shutdown();
			} */
		}
		
		protected function insertNewBaseObjects():void
		{
			for each (var baseObject:BaseObject in newBaseObjects)
			{
				for (var i:int = 0; i < baseObjects.length; ++i)
				{
					var otherBaseObject:BaseObject = baseObjects.getItemAt(i) as BaseObject;
					
					if (otherBaseObject.zOrder > baseObject.zOrder ||
						otherBaseObject.zOrder == -1)
						break;
				}

				baseObjects.addItemAt(baseObject, i);
			}
			
			newBaseObjects.removeAll();
		}
		
		// 检测所有的卡片，确定该次是否满足出牌条件
		public function checkCardtobePlayed(arr:Array):Boolean
		{
			var array:Array;// = new Array();
			array = getSelectedCards();
			if(array.length == 0)	//没有点击任何牌
				return false;
				
			if(arr.length == 0)
			{
				// 第一个出牌，只有基本限制
				if(CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) != -1)
				{
					return true;
				}
			}
			else
			{
				// 是否是炸弹
				if(CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) >=3 
					&& CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) <= 7)
				{
					if(CardPattern.Instance.patternCompare(array.sort(Array.NUMERIC), arr))
					{
						return true;
					}
					return false;
				}
				else
				{
					// 首先比较模式是否相同
					if(CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) == CardPattern.Instance.patternCheck(arr)
					 && CardPattern.Instance.patternCheck(array.sort(Array.NUMERIC)) != -1)
					{
						//然后比较大小
						if(CardPattern.Instance.patternCompare(array.sort(Array.NUMERIC), arr))
						{
							return true;
						}
						return false;
					}
				}
			}
			return false;
		}

		// 生成并返回当前被选中的纸牌的序列
		public function getSelectedCards():Array
		{
			var cards:Array = new Array();
			for each(var card:Card in Game.Instance.PlayerCardsObject)
			{
				if(card.selected){
					cards.push(card.cardid);
				}
			}
			return cards;
		}
		public function getSelectedCardsandMark():Array
		{
			var cards:Array = new Array();
			for each(var card:Card in Game.Instance.PlayerCardsObject)
			{
				if(card.selected){
					cards.push(card.cardid);
					card.isSelectedtoPost = true;
				}
			}
			return cards;
		}
		/**
		 * 对玩家的出牌进行一个提示
		 * @param arr
		 * 
		 */		
		public function showHintCards(arr:Array):Array
		{
			var selfcards:Array;
			var result:Array = new Array();
			selfcards = Game.Instance.PlayerCards.concat();
			selfcards.reverse();

			var pattern:int = CardPattern.Instance.patternCheck(arr.sort(Array.NUMERIC));
			// 前一个人出的不是炸弹
			if(pattern <3 || pattern >7)
			{
				// 对炸弹在后面单独处理， 这里处理所有的非炸弹的情况
				result = selectSameTypeCards(selfcards, arr);
			}
			result = result.concat(selectBomb(selfcards, arr, pattern));
			
			return result;
		}
		private function selectSameTypeCards(self:Array, arr:Array):Array
		{
			var minCard:int = arr[0];
			var hintcards:Array = new Array();
			var single:Array = new Array();
			var type:int = CardPattern.Instance.patternCheck(arr);
			var index:int = 0;
			var subidx:int = 0;
			for(;index<=self.length;index++)
			{
				if(arr[0] >= 52)
				{
					if(arr[0] == 52){
						var ti:int;
						if(arr.length == 1){
							ti = findSpecCardAfterItself(self, 0, 53);
							if(ti != -1){
								single.push(self[ti]);
							}						}
						else if(arr.length == 2){
							ti = findSpecCardAfterItself(self, 0, 53);
							if(ti != -1){
								single.push(self[ti]);
								ti = findSpecCardAfterItself(self, ti, 53);
								if(ti != -1){
									single.push(self[ti]);
								}
							}
						}
					}
					if(single.length != 0)
						hintcards.push(single.concat());
					return hintcards;
				}
				else
				{
					if( int(self[index]/4) > int(minCard/4))
					{
						if( index >= 1){
							if(int(self[index]/4) == int(self[index-1]/4))
								continue;
						} 
							
						
						single.push(self[index]);
						var cardvalue:int = self[index];
						var flag:Boolean = true;
						subidx = index;
						for(var i:int= 1;i<arr.length;i++){
							// 找和之前一样大的一张牌
							var rltid:int;
							if( int(arr[i]/4) == int(arr[i-1]/4)){
								rltid = findSpecCardAfterItself(self, subidx, cardvalue);
								if(rltid == -1){
									flag = false;
									break;;
								}
								else{
									subidx = rltid;
									single.push(self[rltid]);
								}
							}
							else{
								rltid = findSpecCardAfterItself(self, index, cardvalue+4);
								// 顺子，或者连对中，不可以出现2和司令
								if(rltid == -1 || self[rltid] >= 48/*方块2*/){
									flag = false;
									break;
								}
								else{
									subidx = rltid;
									single.push(self[rltid]);
									cardvalue += 4;
								}
							}
						}
						if(flag){
							// 成功得到需要的出牌数据
							hintcards.push(single.concat());
						}
						single.length = 0;
					}//if( int(self[index]/4) > int(minCard/4))
				}//if(arr[0] >= 52)
			}
			return hintcards;
		}
		/**
		 * 
		 * @param self		自己的牌的数据
		 * @param index		开始查找的序列号
		 * @param delta		要查找的牌的id值
		 * @return 
		 * 
		 */		
		private function findSpecCardAfterItself(self:Array, index:int, destid:int):int
		{
			var idx:int = -1;
			for(var i:int=index+1;i<self.length;i++)
			{
				if(int(self[i]/4) == int(destid/4))
				{
					// 司令的情况
					if(destid >= 52){
						if(self[i] == destid){
							idx = i;
							break;
						}
					}
					else{
						idx = i;
						break;
					}
				}else if(int(self[i]/4) > int(destid/4)){
					break;
				}
			}
			return idx;
		}
		public function deselectAllCards():void
		{
//			var tmpcards:Array = new Array();
//			for each(var go:GameObject in baseObjects)
//			{
//				if(go.getName() == "Card" && go.visible)
//				{
//					tmpcards.push(go.getId());
//					if(go.selected)
//					{
//						go.position.y += 15;
//						go.selected = false;
//					}
//				}
//			}
//			return tmpcards;
			for each(var card:Card in Game.Instance.PlayerCardsObject)
			{
				if(card.selected)
					card.beClick();
			}
		}
		public function selectCard(id:int):void
		{
			for(var i:int=0;i<Game.Instance.PlayerCardsObject.length;i++)
			{
				var card:Card = Card(Game.Instance.PlayerCardsObject[i]);
				if(card.cardid == id && !card.selected)
					card.beClick();
			}
		}
		public function selectCards(arr:Array):void
		{
			for each(var id:int in arr)
			{
//				for(var i:int=0;i<baseObjects.length;i++)
//				{
//					var go:GameObject = GameObject(baseObjects.getItemAt(baseObjects.length-1-i));
//					if(go.getName() == "Card" && go.visible)
//					{
//						if(go.getId() == id && !go.selected){
//							go.position.y -= 15;
//							go.selected = true;
//							break;
//						}
//					}
//				}
				for(var i:int=0;i<Game.Instance.PlayerCardsObject.length;i++)
				{
					var card:Card = Card(Game.Instance.PlayerCardsObject[i]);
					if(card.cardid == id && !card.selected)
					{
						card.beClick();
						break;
					}
				}
			}
		}
		private function selectBomb(self:Array, arr:Array, pattern:int):Array
		{
			var result:Array = new Array();
			var bombs:Array = new Array();
			var single:Array = new Array();
			var index:int = 0;
			var count:int;
			count = 1;
			index = 0;
			single.push(self[index]);
			for(index=1;index<=self.length;index++)
			{
				if(int(self[index]/4) == int(self[index-1]/4)){
					single.push(self[index]);
					count ++;
				}
				else{
					if(count >= 4){
						bombs.push(single.concat());
					}
					single.length = 0;
					count = 1;
					single.push(self[index]);
				}
			}
			// 考虑天皇炸
			if(self[length-1-3] == 52){
				single.length = 0;
				single.push(52);
				single.push(52);
				single.push(53);
				single.push(53);
				bombs.push(single.concat());
			}
			if(pattern <3 || pattern >7)
			{
				return bombs;
			}
			else{
				for(var k:int=0;k<bombs.length;k++)
				{
					if(CardPattern.Instance.patternCompare(bombs[k], arr))
					{
						result.push(bombs[k]);
					}
				}
			}
			
			return result;
		}
		
		// 将指定位置的打出的牌清空
		public function removePlayedCards(name:String):void
		{
			for each(var go:GameObject in baseObjects)
			{
				if(go.getName() == name)
					go.shutdown();
			}
		}

		protected function removeDeletedBaseObjects():void
		{
			// insert the object acording to it's z position
			for each (var removedObject:BaseObject in removedBaseObjects)
			{
				var i:int = 0;
				for (i = 0; i < baseObjects.length; ++i)
				{
					if (baseObjects.getItemAt(i) == removedObject)
					{
						baseObjects.removeItemAt(i);
						break;
					}
				}
				
			}
			
			removedBaseObjects.removeAll();
		}
		// 将所有的指定名字的牌置为不可见
		public function makeAllCardsInvisible():void
		{
			for each(var baseObject:BaseObject in baseObjects)
			{
				baseObject.setVisible(false);
			}
		} 
		
		public function setVisibleByName(name:String, visible:Boolean):void
		{
			for each(var go:GameObject in baseObjects)
			{
				if(go.setVisibleByName(name, visible))
					go.selected = false;
			}
		}
		public function setSpecCardVisible(id:int, name:String, pt:Point, zOrder:int, visible:Boolean):void
		{
			for each(var go:GameObject in baseObjects)
			{
				if(go.setSpecIdVisible(id, zOrder, visible))
				{
					go.position = pt;//.clone();
					go.setName(name);
					return;
				}
			}
		}
		
		/**
		 * 用来在游戏的主界面的 出牌容器中添加要出的牌
		 * @param id
		 *      要添加的牌的点数
		 * 注意：这个添加牌的过程是不排序的，要保证被排进来的牌是有序的才可以。
		 *      对总的牌局上来说，经过删除和重新添加以后的牌序会相当的不统一，
		 *      所以会出现不同的重叠情况，尽量保证牌之间不会出现重叠为好。
		 */		
		public function addCardtoScreen(id:int, name:String, pt:Point):Card
		{
			var card:Card = new Card();
			card.source = ResourceManagerPoker.gameCardsRes[id];
			card.x = pt.x;
			card.y = pt.y;
			card.cardid = id;
			card.name = name;
//			card.addEventListener(MouseEvent.CLICK, cardClick);
			// 加入
			var gp:Group;
			if(name == "Card")
			{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerDown as Group;
			}
			else if(name == "PlayedCardSelf"){
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerDown as Group;
			}
			else if(name == "PlayedCardUp")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerUp as Group;
			}
			else if(name == "PlayedCardLeft")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerLeft as Group;
			}
			else if(name == "PlayedCardRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerRight as Group;
			}
			else if(name == "HandCardUp")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerUp as Group;
			}
			else if(name == "HandCardLeft")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerLeft as Group;
			}
			else if(name == "HandCardRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerRight as Group;
			}
			
			return gp.addElement(card) as Card;
		}
		public function addOtherstoScreen(res:Class, name:String, pt:Point):void
		{
			var card:Card = new Card();
			card.source = res;
			card.x = pt.x;
			card.y = pt.y;
			card.cardid = -1;
			card.name = name;
			// 加入
			var gp:Group;
			if(name == "CardbackUp")
			{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerUp as Group;
			}
			else if(name == "CardbackLeft"){
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerLeft as Group;
			}
			else if(name == "CardbackRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerRight as Group;
			}
			
			gp.addElement(card);
		}		
		/**
		 * 从出牌容器中移除所有牌 
		 * @param name
		 *     要移除的牌的名字 name属性
		 * 注意：移除将会清空该容器
		 */		
		public function removeCardfromScreen(name:String):void
		{
			var gp:Group;
			if(name == "Card")
			{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerDown as Group;
			}
			else if(name == "PlayedCardSelf"){
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerDown as Group;
			}
			else if(name == "PlayedCardUp")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerUp as Group;
			}
			else if(name == "PlayedCardLeft")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerLeft as Group;
			}
			else if(name == "PlayedCardRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamePlayedcardLayerRight as Group;
			}
			else if(name == "HandCardUp")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerUp as Group;
			}
			else if(name == "HandCardLeft")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerLeft as Group;
			}
			else if(name == "HandCardRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerRight as Group;
			}

			gp.removeAllElements();
		}
		public function removeSingleCardfromScreen(card:Card, name:String):void
		{
			var gp:Group = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerDown as Group;
			gp.removeElement(card);
		}
		public function removeOthersfromScreen(name:String):void
		{
			var gp:Group;
			if(name == "CardbackLeft")
			{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerLeft as Group;
			}
			else if(name == "CardbackUp"){
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerUp as Group;
			}
			else if(name == "CardbackRight")	{
				gp = FlexGlobals.topLevelApplication.gamePoker.gamecardLayerRight as Group;
			}
			gp.removeAllElements();
		}
	}
}