package
{
	/**
	 * 
	 * @author Eric
	 * 构造函数中初始化牌的类型
	 * 判断牌组的类型，并比较大小
	 */	
	public class CardPattern
	{
		protected static var instance:CardPattern = null;
		//
		private var initFunc:Function = null;
		private var checkFunc:Function = null;
		private var compareFunc:Function = null;

		static public function get Instance():CardPattern
		{
			if ( instance == null )
				instance = new CardPattern();
			return instance;
		}

		// 定义所有的卡牌的模式
		// 记录所有的牌的可能性，并进行判断
		private var pattern:Array = new Array();
		
		public function CardPattern()
		{
			initShuangkou();
		}
		
		// 返回传入牌的牌型
		// 返回值是该牌型在数组中的位置，也就等于是id值
		// 如果该类型不存在，返回-1
		public function patternCheck(arr:Array):int
		{
			return getTypeShuangkou(arr);
		}

		// 传入比较的2个数组必须是相同的类别才有效
		// 为真表示,第一个值要比第二个大,否则的话,第一个比第二个小或者相等.
		public function patternCompare(data1:Array, data2:Array):Boolean
		{
			return compareShuangkou(data1, data2);
		}

		/**
		* 以下是各种牌组的具体实现，在选取时，可以自行的对牌组进行组合
		* 
		*/
		//////////////////////双扣////////////////////////////
		private function initShuangkou():void
		{
			var i:int;
			// index 0-7
			for(i=0;i<8;i++)		
			{
				var ary:Array = new Array();
				for(var j:int=0;j<i+1;j++)
				{
					ary.push(0);			// 3，33，333，3333，33333，333333，3333333，33333333
				}
				pattern.push(ary);
			}
			// index 8-15
			for(i=0;i<8;i++)			// 34567, 345678,3-9,3-10,3-J,3-Q,3-K,3-A
			{
				ary = new Array();
				for(j=0;j<i+5;j++)
				{
					ary.push(j);
				}
				pattern.push(ary);
			}
			// index 16-25
			for(i=0;i<10;i++)			// 334455, 33-66,3-7,3-8,3-9,3-10,3-J,3-Q,3-K,3-A
			{
				ary = new Array();
				for(j=0;j<i+3;j++)
				{
					ary.push(j);
					ary.push(j);
				}
				pattern.push(ary);
			}
			// index 26-35
			for(i=0;i<10;i++)			// 333444555, 333-666,3-7,3-8,3-9,3-10,3-J,3-Q,3-K,3-A
			{
				ary = new Array();
				for(j=0;j<i+3;j++)
				{
					ary.push(j);
					ary.push(j);
					ary.push(j);
				}
				pattern.push(ary);
			}			
		}
		private function getTypeShuangkou(arr:Array):int
		{
			if(arr.length == 0)	// 没有数据的情况下
			{
				return -1;
			}
			// 新数组赋值
			var data:Array = arr.concat();
			// 对司令特别处理
			if(data[0] >= 52)	// 副司令
			{
				if(data.length == 2)
				{
					if(data[0] == data[1])
						return 1;		// 33 模式
				}
				else if(data.length == 4)
				{
					return 7;		// 33333333 模式
				}
				else if(data.length == 1)
				{
				}
				else
					return -1;
			}
			// 所有的牌值除以4
			for(card=0;card<data.length;card++)
			{
				data[card]=int(data[card]/4);
			}
			if(data[0] != 0)
			{
				var base:int = data[0];
				for(var card:int=0;card<data.length;card++)
				{
					data[card]-=base;
				}
			}
			
			for each(var tmp:Array in pattern)
			{
				if(tmp.length != data.length)
					continue;
				var flag:Boolean = false;
				for(var m:int=0;m<tmp.length;m++)
				{
					if(tmp[m] != data[m])
					{
						flag = true;
						break;
					}
				}
				if(!flag)
				{
					// 2 和 司令不能出现在顺子或者连对中
					if(pattern.indexOf(tmp) >= 8 && arr[arr.length-1] >= 46/*方块2*/)
					{
						return -1;
					}
					else
						return pattern.indexOf(tmp);
				}
			}
			return -1;
		}
		private function compareShuangkou(data1:Array, data2:Array):Boolean
		{
			// 是否是炸弹
			if(patternCheck(data1) >=3 && patternCheck(data1) <=7)
			{
				// 上一副牌是不是炸弹
				if(patternCheck(data2) >=3 && patternCheck(data2) <=7)
				{
					// 天王炸的处理
						// 打出的是天王炸
					if(data1.length == 4 && data1[0] >= 52)
					{
						return true;
					}
					if(data2.length == 4 && data2[0] >= 52)
					{
						// 上一副出的是天王炸
						return false;
					}
					
					if(data1.length > data2.length)
						return true;
					else if(data1.length == data2.length)
					{
						if(int(data1[0]/4) > int(data2[0]/4))
							return true;
						else
							return false;
					}
					else
						return false;
				}
				else
				{
					return true;
				}
			}
			else
			{
				// 如果是司令
				if(data1[0] >= 52)
				{
					if(int(data1[0]) > int(data2[0]))
						return true;
					else
						return false;
				}
				else
				{
					if(int(data1[0]/4) > int(data2[0]/4))
						return true;
					else
						return false;
				}
			}
		}
	}
}