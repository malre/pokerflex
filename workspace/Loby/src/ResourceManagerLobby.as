package
{
	public final class ResourceManagerLobby
	{
		private static var instance:ResourceManagerLobby = null;
		
		public function ResourceManagerLobby()
		{
		}
		
		public static function get Instance():ResourceManagerLobby
		{
			if(instance == null)
				instance = new ResourceManagerLobby();
			return instance;
		}
	
		[Embed(source="assets/lobbyTable.swf")]
		public var imgTable1:Class;
		[Embed(source="assets/skin2/lobbyTable.swf")]
		public var imgTable2:Class;
		[Embed(source="assets/skin3/lobbyTable.swf")]
		public var imgTable3:Class;
		
		[Embed(source="assets/lobbyChair.swf")]
		public var imgChair1:Class;
		[Embed(source="assets/skin2/lobbyChair.swf")]
		public var imgChair2:Class;
		[Embed(source="assets/skin3/lobbyChair.swf")]
		public var imgChair3:Class;
		
		// 以下是多套皮肤系统使用的图
		[Embed(source="assets/gameBg.jpg")]
		public var Bg_DT_skin1:Class;
		[Embed(source="assets/skin2/gameBg.jpg")]
		public var Bg_DT_skin2:Class;
		[Embed(source="assets/skin3/gameBg.jpg")]
		public var Bg_DT_skin3:Class;

		[Embed(source="assets/tableIdPanel.swf")]
		public var tableIdPanel_skin1:Class;
		[Embed(source="assets/skin2/tableIdPanel.swf")]
		public var tableIdPanel_skin2:Class;
		[Embed(source="assets/skin3/tableIdPanel.swf")]
		public var tableIdPanel_skin3:Class;

		[Embed(source="assets/lobbyPanel.swf")]
		public var lobbyPanel_skin1:Class;
		[Embed(source="assets/skin2/lobbyPanel.swf")]
		public var lobbyPanel_skin2:Class;
		[Embed(source="assets/skin3/lobbyPanel.swf")]
		public var lobbyPanel_skin3:Class;
		
		[Embed(source="assets/text_gamelist.swf")]
		public var text_gamelist_skin1:Class;
		[Embed(source="assets/skin2/text_gamelist.swf")]
		public var text_gamelist_skin2:Class;
		[Embed(source="assets/skin3/text_gamelist.swf")]
		public var text_gamelist_skin3:Class;
		
		[Embed(source="assets/text_gamelobby.swf")]
		public var text_gamelobby_skin1:Class;
		[Embed(source="assets/skin2/text_gamelobby.swf")]
		public var text_gamelobby_skin2:Class;
		[Embed(source="assets/skin3/text_gamelobby.swf")]
		public var text_gamelobby_skin3:Class;

		[Embed(source="assets/bg_5.swf")]
		public var bg_5_skin1:Class;
		[Embed(source="assets/skin2/bg_5.swf")]
		public var bg_5_skin2:Class;
		[Embed(source="assets/skin3/bg_5.swf")]
		public var bg_5_skin3:Class;

		[Embed(source="assets/bg_4.swf")]
		public var bg_4_skin1:Class;
		[Embed(source="assets/skin2/bg_4.swf")]
		public var bg_4_skin2:Class;
		[Embed(source="assets/skin3/bg_4.swf")]
		public var bg_4_skin3:Class;
		
		[Embed(source="assets/Bg_shop.swf")]
		public var Bg_shop_skin1:Class;
		[Embed(source="assets/skin2/Bg_shop.swf")]
		public var Bg_shop_skin2:Class;
		[Embed(source="assets/skin3/Bg_shop.swf")]
		public var Bg_shop_skin3:Class;
		
		[Embed(source="assets/shop_text.swf")]
		public var shop_text_skin1:Class;
		[Embed(source="assets/skin2/shop_text.swf")]
		public var shop_text_skin2:Class;
		[Embed(source="assets/skin3/shop_text.swf")]
		public var shop_text_skin3:Class;

		[Embed(source="assets/item_text.swf")]
		public var item_text_skin1:Class;
		[Embed(source="assets/skin2/item_text.swf")]
		public var item_text_skin2:Class;
		[Embed(source="assets/skin3/item_text.swf")]
		public var item_text_skin3:Class;

		[Embed(source="assets/systemBG.swf")]
		public var systemBG_skin1:Class;
		[Embed(source="assets/skin2/systemBG.swf")]
		public var systemBG_skin2:Class;
		[Embed(source="assets/skin3/systemBG.swf")]
		public var systemBG_skin3:Class;

		[Embed(source="assets/playerinfo_panel.swf")]
		public var playerinfo_panel_skin1:Class;
		[Embed(source="assets/skin2/playerinfo_panel.swf")]
		public var playerinfo_panel_skin2:Class;
		[Embed(source="assets/skin3/playerinfo_panel.swf")]
		public var playerinfo_panel_skin3:Class;
	
		[Embed(source="assets/text_createroom.swf")]
		public var text_createroom_skin1:Class;
		[Embed(source="assets/skin2/text_createroom.swf")]
		public var text_createroom_skin2:Class;
		[Embed(source="assets/skin3/text_createroom.swf")]
		public var text_createroom_skin3:Class;
	
		[Embed(source="assets/text_optionWnd.swf")]
		public var text_optionWnd_skin1:Class;
		[Embed(source="assets/skin2/text_optionWnd.swf")]
		public var text_optionWnd_skin2:Class;
		[Embed(source="assets/skin3/text_optionWnd.swf")]
		public var text_optionWnd_skin3:Class;

		[Embed(source="assets/optionWindow_text.swf")]
		public var optionWindow_text_skin1:Class;
		[Embed(source="assets/skin2/optionWindow_text.swf")]
		public var optionWindow_text_skin2:Class;
		[Embed(source="assets/skin3/optionWindow_text.swf")]
		public var optionWindow_text_skin3:Class;

		[Embed(source="assets/friendslist_title.swf")]
		public var friendslist_title_skin1:Class;
		[Embed(source="assets/skin2/friendslist_title.swf")]
		public var friendslist_title_skin2:Class;
		[Embed(source="assets/skin3/friendslist_title.swf")]
		public var friendslist_title_skin3:Class;

		[Embed(source="assets/text_changeSkin.swf")]
		public var text_changeSkin_skin1:Class;
		[Embed(source="assets/skin2/text_changeSkin.swf")]
		public var text_changeSkin_skin2:Class;
		[Embed(source="assets/skin3/text_changeSkin.swf")]
		public var text_changeSkin_skin3:Class;

		[Embed(source="assets/gameLogo.swf")]
		public var gameLogo_skin1:Class;
		[Embed(source="assets/skin2/gameLogo.swf")]
		public var gameLogo_skin2:Class;
		[Embed(source="assets/skin3/gameLogo.swf")]
		public var gameLogo_skin3:Class;
		
		[Embed(source="assets/gamePanel.swf")]
		public var gamePanel_skin1:Class;
		[Embed(source="assets/skin2/gamePanel.swf")]
		public var gamePanel_skin2:Class;
		[Embed(source="assets/skin3/gamePanel.swf")]
		public var gamePanel_skin3:Class;
		
		[Embed(source="assets/ButtonBg.swf")]
		public var ButtonBg_skin1:Class;
		[Embed(source="assets/skin2/ButtonBg.swf")]
		public var ButtonBg_skin2:Class;
		[Embed(source="assets/skin3/ButtonBg.swf")]
		public var ButtonBg_skin3:Class;

	
	}
}