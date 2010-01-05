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
//		public static const levelName:Array = ["不限","蜗牛","小马驹","三等马","二等马","一等马","千里马",
//		"白鹤","紫骍","惊帆","爪黄飞电","乌云踏雪","照夜玉狮子","的卢","绝影","赤兔","乌骓","晨凫",
//		"铜爵","飞翩","追电","蹑景","白兔","追风"];
		public static const levelName:Array = ["不限","1","2","3","4","5","6",
		"7","8","9","10","11","12","13","14","15","16","17",
		"18","19","20","21","22","23"];
		
		public function LevelDefine()
		{
		}
		
//		static public function getLevelName(score:int):String
//		{
//			if(score < 60)
//				return "蜗牛";
//			else if(score < 140)
//				return "小马驹";
//			else if(score < 300)
//				return "三等马";
//			else if(score < 720)
//				return "二等马";
//			else if(score < 1400)
//				return "一等马";
//			else if(score < 2000)
//				return "千里马"
//			else if(score < 3000)
//				return "白鹤";
//			else if(score < 4500)
//				return "紫骍";
//			else if(score < 6200)
//				return "惊帆";
//			else if(score < 8000)
//				return "爪黄飞电";
//			else if(score < 12000)
//				return "乌云踏雪";
//			else if(score < 17000)
//				return "照夜玉狮子";
//			else if(score < 22000)
//				return "的卢";
//			else if(score < 28000)
//				return "绝影";
//			else if(score < 40000)
//				return "赤兔";
//			else if(score < 60000)
//				return "乌骓";
//			else if(score < 90000)
//				return "晨凫";
//			else if(score < 140000)
//				return "铜爵";
//			else if(score < 300000)
//				return "飞翩";
//			else if(score < 450000)
//				return "追电";
//			else if(score < 600000)
//				return "蹑景";
//			else if(score < 1000000)
//				return "白兔";
//			else
//				return "追风";
//		}
		static public function getLevelName(score:int):String
		{
			if(score < 60)
				return "1";
			else if(score < 140)
				return "2";
			else if(score < 300)
				return "3";
			else if(score < 720)
				return "4";
			else if(score < 1400)
				return "5";
			else if(score < 2000)
				return "6"
			else if(score < 3000)
				return "7";
			else if(score < 4500)
				return "8";
			else if(score < 6200)
				return "9";
			else if(score < 8000)
				return "10";
			else if(score < 12000)
				return "11";
			else if(score < 17000)
				return "12";
			else if(score < 22000)
				return "13";
			else if(score < 28000)
				return "14";
			else if(score < 40000)
				return "15";
			else if(score < 60000)
				return "16";
			else if(score < 90000)
				return "17";
			else if(score < 140000)
				return "18";
			else if(score < 300000)
				return "19";
			else if(score < 450000)
				return "20";
			else if(score < 600000)
				return "21";
			else if(score < 1000000)
				return "22";
			else
				return "23";
		}
	}
}