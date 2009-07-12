package
{
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
		public function patternCheck(data:Array):int
		{
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
				if(tmp == data)
					return pattern.indexOf(tmp);
			}
			return -1;
		}

		// 传入比较的2个数组必须是相同的类别才有效
		public function patternCompare(data1:Array, data2:Array):Boolean
		{
			return false;
		}
	}
}