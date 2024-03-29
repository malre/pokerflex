package
{
	public final class ruleIntroduce
	{
		public function ruleIntroduce()
		{
		}
		public static const ruleText:String = "<p fontWeight='bold'><span fontSize='16' color='#663300'>【双扣简介】</span></p>" + 
				"<p>双扣游戏主要流行于江浙一带，游戏规则类似\"跑得快\"。游戏打两副牌，对家两人为一队。一队的两人要相互配合尽快将手中的牌先出完。</p>" + 
				"<p fontSize='16' color='#663300'>【游戏规则】</p>\n" + 
				"<p>1． 基本规则</p>" + 
				"<p>玩家人数：4人</p>" + 
				"<p>组队：对家的两人为一队</p>" + 
				"<p>牌数：两幅牌共108张牌</p>" + 
				"<p>2． 出牌顺序</p>" + 
				"<p>如果上一局是单扣或平扣，则从上一局最先出完牌的玩家开始出牌。</p>" + 
				"<p>如果是第一局、新局、上局双扣结束或者上局非正常结束（逃跑）的情况，则随机选择一个玩家先出牌。</p>"+
				"<p>3． 牌型</p>" + 
				"<p>	单张：	任意一张单牌</p>" + 
				"<p>	顺子：	任意五张或者五张以上点数相连的牌，2和王不能出现在顺子中</p>" + 
				"<p>	对子：	任意两张点数相同的牌</p>" + 
				"<p>	连对：	三对或三对以上点数相连的牌，如：556677。2和王不能出现在连对中</p>" + 
				"<p>	三张：	任意三张点数相同的牌</p>" + 
				"<p>	连三张：	三个或三个以上点数相连的三张牌，如：555666777。2和王不能出现在连对中。</p>" + 
				"<p>	炸弹：	四张或四张以上点数相同的牌，如：66666。</p>" + 
				"<p>	天王炸弹：	四张王牌。</p>" + 
				"<p>4． 牌型的比较</p>" + 
				"<p>	点数的大小：	从大至小依次为：大王,小王,2,A,K,Q,J,10,9,8,7,6,5,4,3</p>" + 
				"<p>	牌型的大小：	单张、顺子、对子、连对、三张、连三张的牌型，直接根据牌型中最大牌的点数比较大小，但要求牌型和牌数量必须相同。</p>" + 
				"<p>	炸弹：	</p>"+
				"<p>炸弹大于任何其他非炸弹的牌型。</p>" + 
				"<p>同为炸弹的牌型，如果牌张数相同，则按牌点数确定大小，否则牌张数越多越大。</p>" + 
				"<p>天王炸弹最大。</p>" + 
				"<p>5． 接风</p>" + 
				"<p>	当某玩家出完手上的牌后，如果其他玩家都放弃。则下一轮的任意出牌权是他的对家。</p>" + 
				"<p fontSize='16' color='#663300'>【积分计算】</p>" + 
				"<p>名次的决定：</p>" + 
				"<p>按照出完牌的顺序决定名次，当双扣的情况按照出牌顺序排定第三名和第四名。</p>" + 
				"<p>当一队的两个玩家都先将牌出完，而另外一方的两家都没有出完，则为双扣。</p>" + 
				"<p>当一队有一个第一名出完，一个第三名出完，则为单扣。</p>" + 
				"<p>当一队有一个第一名，一个第四名，则为双方打和，为平扣。</p>" + 
				"<p>积分计算表：</p>" + 
				"<p>第一名 第二名 第三名 第四名</p>" + 
				"<p>  双扣    4          4         -4         -4</p>" + 
				"<p>  单扣    2         -2          2         -2</p>" + 
				"<p>  平扣    0          0          0          0</p>";

	}
}