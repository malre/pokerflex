package poker
{
	public final class LevelDefine
	{
		
//		1	蜗牛	<60
//		2	小马驹	60
//		3	三等马	140
//		4	二等马	300
//		5	一等马	720
//		6	千里马	1400
//		7	白鹤	2000
//		8	紫骍	3000
//		9	惊帆	4500
//		10	爪黄飞电	6200
//		11	乌云踏雪	8000
//		12	照夜玉狮子	12000
//		13	的卢	17000
//		14	绝影	22000
//		15	赤兔	28000
//		16	乌骓	40000
//		17	晨凫	60000
//		18	铜爵	90000
//		19	飞翩	140000
//		20	追电	300000
//		21	蹑景	450000
//		22	白兔	600000
//		23	追风	1000000
		public static var levelName:Array = new Array();
		
		public function LevelDefine()
		{
		}
		
		static public function getLevelName(score:int):String
		{
			if(score < 60)
				return "蜗牛";
			else if(score < 140)
				return "小马驹";
			else if(score < 300)
				return "三等马";
			else if(score < 720)
				return "二等马";
			else if(score < 1400)
				return "一等马";
			else if(score < 2000)
				return "千里马"
			else if(score < 3000)
				return "白鹤";
			else if(score < 4500)
				return "紫骍";
			else if(score < 6200)
				return "惊帆";
			else if(score < 8000)
				return "爪黄飞电";
			else if(score < 12000)
				return "乌云踏雪";
			else if(score < 17000)
				return "照夜玉狮子";
			else if(score < 22000)
				return "的卢";
			else if(score < 28000)
				return "绝影";
			else if(score < 40000)
				return "赤兔";
			else if(score < 60000)
				return "乌骓";
			else if(score < 90000)
				return "晨凫";
			else if(score < 140000)
				return "铜爵";
			else if(score < 300000)
				return "飞翩";
			else if(score < 450000)
				return "追电";
			else if(score < 600000)
				return "蹑景";
			else if(score < 1000000)
				return "白兔";
			else
				return "追风";

		}

	}
}