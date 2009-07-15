package
{
	import mx.utils.ArrayUtil;
	
	public class CardPattern
	{
		protected static var instance:CardPattern = null;

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
			var i:int;
			for(i=0;i<8;i++)
			{
				var ary:Array = new Array();
				for(var j:int=0;j<i+1;j++)
				{
					ary.push(0);			// 3，33，333，3333，33333，333333，3333333，33333333
				}
				pattern.push(ary);
			}
			for(i=0;i<8;i++)			// 34567, 345678,3-9,3-10,3-J,3-Q,3-K,3-A
			{
				ary = new Array();
				for(j=0;j<i+5;j++)
				{
					ary.push(j);
				}
				pattern.push(ary);
			}
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
		
		// 返回传入牌的牌型
		// 返回值是该牌型在数组中的位置，也就等于是id值
		public function patternCheck(arr:Array):int
		{
			if(arr.length == 0)	// 没有数据的情况下
			{
				return -1;
			}
			// 新数组赋值
			var data:Array = arr.concat();
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
					return pattern.indexOf(tmp);
			}
			return -1;
		}

		// 传入比较的2个数组必须是相同的类别才有效
		// 为真表示,第一个值要比第二个大,否则的话,第一个比第二个小或者相等.
		public function patternCompare(data1:Array, data2:Array):Boolean
		{
			// 是否是炸弹
			if(patternCheck(data1) >=3 && patternCheck(data1) <=7)
			{
				// 上一副牌是不是炸弹
				if(patternCheck(data2) >=3 && patternCheck(data2) <=7)
				{
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
				if(int(data1[0]/4) > int(data2[0]/4))
					return true;
				else
					return false;
			}
		}
	}
}