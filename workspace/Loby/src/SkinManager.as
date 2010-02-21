package 
{
	import components.skin1.*;
	import components.skin2.*;
	import components.skin3.*;
	
	import mx.controls.Image;
	
	public class SkinManager
	{
		public function SkinManager()
		{
		}
		
		private static const X:int = 0;
		private static const Y:int = 1;
		private static const W:int = 2;
		private static const H:int = 3;
		
		public static function setSkinImage(target:Image,id:int,type:Object):void
		{
			target.source = skins[id][type];
			target.x += skinPos[id][type][X];
			target.y += skinPos[id][type][Y];
			//target.width = skinPos[id][type][W];
			//target.height =skinPos[id][type][H];
		}
		public static function setStyle(target:Object,id:int,type:Object):void
		{
			target.setStyle("skinClass",skins[id][type]);
			target.x += skinPos[id][type][X];
			target.y += skinPos[id][type][Y];
		}
		//------------------------------------------------------
		[Embed(source="assets/skin1/lobbyTable.swf")]
		public static var imgTable1:Class;
		[Embed(source="assets/skin2/lobbyTable.swf")]
		public static var imgTable2:Class;
		[Embed(source="assets/skin3/lobbyTable.png")]
		public static var imgTable3:Class;
		
		[Embed(source="assets/skin1/lobbyChair.swf")]
		public static var imgChair1:Class;
		[Embed(source="assets/skin2/lobbyChair.swf")]
		public static var imgChair2:Class;
		[Embed(source="assets/skin3/lobbyChair.png")]
		public static var imgChair3:Class;
		//------------------------------------------------------
		// 以下是多套皮肤系统使用的图
		[Embed(source="assets/skin1/gameBg.jpg")]
		public static var Bg_DT_skin1:Class;
		[Embed(source="assets/skin2/gameBg.jpg")]
		public static var Bg_DT_skin2:Class;
		[Embed(source="assets/skin3/gameBg.png")]
		public static var Bg_DT_skin3:Class;
		
		[Embed(source="assets/skin1/tableIdPanel.swf")]
		public static var tableIdPanel_skin1:Class;
		[Embed(source="assets/skin2/tableIdPanel.swf")]
		public static var tableIdPanel_skin2:Class;
		[Embed(source="assets/skin3/tableIdPanel.png")]
		public static var tableIdPanel_skin3:Class;
		
		[Embed(source="assets/skin1/lobbyPanel.swf")]
		public static var lobbyPanel_skin1:Class;
		[Embed(source="assets/skin2/lobbyPanel.swf")]
		public static var lobbyPanel_skin2:Class;
		[Embed(source="assets/skin3/lobbyPanel.png")]
		public static var lobbyPanel_skin3:Class;
		
		[Embed(source="assets/skin1/text_gamelist.swf")]
		public static var text_gamelist_skin1:Class;
		[Embed(source="assets/skin2/text_gamelist.swf")]
		public static var text_gamelist_skin2:Class;
		[Embed(source="assets/skin3/text_gamelist.png")]
		public static var text_gamelist_skin3:Class;
		
		[Embed(source="assets/skin1/text_gamelobby.swf")]
		public static var text_gamelobby_skin1:Class;
		[Embed(source="assets/skin2/text_gamelobby.swf")]
		public static var text_gamelobby_skin2:Class;
		[Embed(source="assets/skin3/text_gamelobby.png")]
		public static var text_gamelobby_skin3:Class;
		
		[Embed(source="assets/skin1/bg_5.swf")]
		public static var bg_5_skin1:Class;
		[Embed(source="assets/skin2/bg_5.swf")]
		public static var bg_5_skin2:Class;
		[Embed(source="assets/skin3/bg_5.png")]
		public static var bg_5_skin3:Class;
		
		[Embed(source="assets/skin1/bg_4.swf")]
		public static var bg_4_skin1:Class;
		[Embed(source="assets/skin2/bg_4.swf")]
		public static var bg_4_skin2:Class;
		[Embed(source="assets/skin3/bg_4.png")]
		public static var bg_4_skin3:Class;
		
		[Embed(source="assets/skin1/Bg_shop.swf")]
		public static var Bg_shop_skin1:Class;
		[Embed(source="assets/skin2/Bg_shop.swf")]
		public static var Bg_shop_skin2:Class;
		[Embed(source="assets/skin3/Bg_shop.png")]
		public static var Bg_shop_skin3:Class;
		
		[Embed(source="assets/skin1/shop_text.swf")]
		public static var shop_text_skin1:Class;
		[Embed(source="assets/skin2/shop_text.swf")]
		public static var shop_text_skin2:Class;
		[Embed(source="assets/skin3/shop_text.png")]
		public static var shop_text_skin3:Class;
		
		[Embed(source="assets/skin1/item_text.swf")]
		public static var item_text_skin1:Class;
		[Embed(source="assets/skin2/item_text.swf")]
		public static var item_text_skin2:Class;
		[Embed(source="assets/skin3/item_text.png")]
		public static var item_text_skin3:Class;
		
		[Embed(source="assets/skin1/systemBG.swf")]
		public static var systemBG_skin1:Class;
		[Embed(source="assets/skin2/systemBG.swf")]
		public static var systemBG_skin2:Class;
		[Embed(source="assets/skin3/systemBG.png")]
		public static var systemBG_skin3:Class;
		
		[Embed(source="assets/skin1/playerinfo_panel.swf")]
		public static var playerinfo_panel_skin1:Class;
		[Embed(source="assets/skin2/playerinfo_panel.swf")]
		public static var playerinfo_panel_skin2:Class;
		[Embed(source="assets/skin3/playerinfo_panel.png")]
		public static var playerinfo_panel_skin3:Class;
		
		[Embed(source="assets/skin1/text_createroom.swf")]
		public static var text_createroom_skin1:Class;
		[Embed(source="assets/skin2/text_createroom.swf")]
		public static var text_createroom_skin2:Class;
		[Embed(source="assets/skin3/text_createroom.png")]
		public static var text_createroom_skin3:Class;
		
		[Embed(source="assets/skin1/text_optionWnd.swf")]
		public static var text_optionWnd_skin1:Class;
		[Embed(source="assets/skin2/text_optionWnd.swf")]
		public static var text_optionWnd_skin2:Class;
		[Embed(source="assets/skin3/text_optionWnd.png")]
		public static var text_optionWnd_skin3:Class;
		
		[Embed(source="assets/skin1/optionWindow_text.swf")]
		public static var optionWindow_text_skin1:Class;
		[Embed(source="assets/skin2/optionWindow_text.swf")]
		public static var optionWindow_text_skin2:Class;
		[Embed(source="assets/skin3/optionWindow_text.png")]
		public static var optionWindow_text_skin3:Class;
		
		[Embed(source="assets/skin1/friendslist_title.swf")]
		public static var friendslist_title_skin1:Class;
		[Embed(source="assets/skin2/friendslist_title.swf")]
		public static var friendslist_title_skin2:Class;
		[Embed(source="assets/skin3/friendslist_title.png")]
		public static var friendslist_title_skin3:Class;
		
		[Embed(source="assets/skin1/text_changeSkin.swf")]
		public static var text_changeSkin_skin1:Class;
		[Embed(source="assets/skin2/text_changeSkin.swf")]
		public static var text_changeSkin_skin2:Class;
		[Embed(source="assets/skin3/text_changeSkin.png")]
		public static var text_changeSkin_skin3:Class;
		
		[Embed(source="assets/skin1/gameLogo.swf")]
		public static var gameLogo_skin1:Class;
		[Embed(source="assets/skin2/gameLogo.swf")]
		public static var gameLogo_skin2:Class;
		[Embed(source="assets/skin3/gameLogo.png")]
		public static var gameLogo_skin3:Class;
		
		[Embed(source="assets/skin1/gamePanel.swf")]
		public static var gamePanel_skin1:Class;
		[Embed(source="assets/skin2/gamePanel.swf")]
		public static var gamePanel_skin2:Class;
		[Embed(source="assets/skin3/gamePanel.png")]
		public static var gamePanel_skin3:Class;
		
		[Embed(source="assets/skin1/ButtonBg.swf")]
		public static var ButtonBg_skin1:Class;
		[Embed(source="assets/skin2/ButtonBg.swf")]
		public static var ButtonBg_skin2:Class;
		[Embed(source="assets/skin3/ButtonBg.png")]
		public static var ButtonBg_skin3:Class;
		
		//------------------------------------------------------
		[Embed(source="res/skin1/sandglass.swf")]
		public static var sandglass_skin1:Class;
		[Embed(source="res/skin2/sandglass.swf")]
		public static var sandglass_skin2:Class;
		[Embed(source="res/skin3/sandglass.swf")]
		public static var sandglass_skin3:Class;
		
		[Embed(source="res/skin1/pass.swf")]
		public static var pass_skin1:Class;
		[Embed(source="res/skin2/pass.swf")]
		public static var pass_skin2:Class;
		[Embed(source="res/skin3/pass.swf")]
		public static var pass_skin3:Class;
		
		[Embed(source="res/skin1/CPUAI.swf")]
		public static var CPUAI_skin1:Class;
		[Embed(source="res/skin2/CPUAI.swf")]
		public static var CPUAI_skin2:Class;
		[Embed(source="res/skin3/CPUAI.swf")]
		public static var CPUAI_skin3:Class;
		
		[Embed(source="res/skin1/ready.swf")]
		public static var ready_skin1:Class;
		[Embed(source="res/skin2/ready.swf")]
		public static var ready_skin2:Class;
		[Embed(source="res/skin3/ready.swf")]
		public static var ready_skin3:Class;
		//------------------------------------------------------

		public static const Button_AutoJoinTable:int		= 0;
		public static const Button_CalcCards:int			= 1;
		public static const Button_Chupai:int				= 2;
		public static const Button_Confirm:int			= 3;
		public static const Button_CpuPlay:int			= 4;
		public static const Button_CpuPlayCancel:int		= 5;
		public static const Button_CreateTable:int		= 6;
		public static const Button_Exit:int				= 7;
		public static const Button_Friends:int			= 8;
		public static const Button_GameTalk:int			= 9;
		public static const Button_Item:int				= 10;
		public static const Button_ItemUse:int			= 11;
		public static const Button_MsgEmotion:int			= 12;
		public static const Button_MsgOption:int			= 13;
		public static const Button_Page:int				= 14;
		public static const Button_Ready:int				= 15;
		public static const Button_SendGift:int			= 16;
		public static const Button_Setup:int				= 17;
		public static const Button_Shop:int				= 18;
		public static const Button_ShopBuy:int			= 19;
		public static const Button_ShopNoBuy:int			= 20;
		public static const Button_ToLastTable:int		= 21;
		public static const Button_ToLobbyFace:int		= 22;
		public static const Button_ToRoom:int				= 23;
		public static const Button_Vita:int				= 24;
		public static const OptionWindow_CloseButton:int	= 25;
		
		public static const imgTable:int					=0+26;
		public static const imgChair:int					=1+26;
		public static const Bg_DT_skin:int				=2+26;
		public static const tableIdPanel_skin:int			=3+26;
		public static const lobbyPanel_skin:int			=4+26;
		public static const text_gamelist_skin:int		=5+26;
		public static const text_gamelobby_skin:int		=6+26;
		public static const bg_5_skin:int					=7+26;
		public static const bg_4_skin:int					=8+26;
		public static const Bg_shop_skin:int				=9+26;
		public static const shop_text_skin:int			=10+26;
		public static const item_text_skin:int			=11+26;
		public static const systemBG_skin:int				=12+26;
		public static const playerinfo_panel_skin:int		=13+26;
		public static const text_createroom_skin:int		=14+26;
		public static const text_optionWnd_skin:int		=15+26;
		public static const optionWindow_text_skin:int	=16+26;
		public static const friendslist_title_skin:int	=17+26;
		public static const text_changeSkin_skin:int		=18+26;
		public static const gameLogo_skin:int				=19+26;
		public static const gamePanel_skin:int			=20+26;
		public static const ButtonBg_skin:int				=21+26;
		
		public static const sandglass_skin:int			=22+26;
		public static const pass_skin:int					=23+26;
		public static const CPUAI_skin:int				=24+26;
		public static const ready_skin:int				=25+26;
		
		public static const Button_GameFriends:int		= 52;
		
		public static var skins:Array =
		[
			[
				components.skin1.Button_AutoJoinTable,
				components.skin1.Button_CalcCards,
				components.skin1.Button_Chupai,
				components.skin1.Button_Confirm,
				components.skin1.Button_CpuPlay,
				components.skin1.Button_CpuPlayCancel,
				components.skin1.Button_CreateTable,
				components.skin1.Button_Exit,
				components.skin1.Button_Friends,
				components.skin1.Button_GameTalk,
				components.skin1.Button_Item,
				components.skin1.Button_ItemUse,
				components.skin1.Button_MsgEmotion,
				components.skin1.Button_MsgOption,
				components.skin1.Button_Page,
				components.skin1.Button_Ready,
				components.skin1.Button_SendGift,
				components.skin1.Button_Setup,
				components.skin1.Button_Shop,
				components.skin1.Button_ShopBuy,
				components.skin1.Button_ShopNoBuy,
				components.skin1.Button_ToLastTable,
				components.skin1.Button_ToLobbyFace,
				components.skin1.Button_ToRoom,
				components.skin1.Button_Vita,
				components.skin1.OptionWindow_CloseButton,
				imgTable1,imgChair1,Bg_DT_skin1,tableIdPanel_skin1,lobbyPanel_skin1,
				text_gamelist_skin1,text_gamelobby_skin1,bg_5_skin1,bg_4_skin1,
				Bg_shop_skin1,shop_text_skin1,item_text_skin1,systemBG_skin1,
				playerinfo_panel_skin1,text_createroom_skin1,text_optionWnd_skin1,
				optionWindow_text_skin1,friendslist_title_skin1,text_changeSkin_skin1,
				gameLogo_skin1,gamePanel_skin1,ButtonBg_skin1,
				sandglass_skin1,
				pass_skin1,
				CPUAI_skin1,
				ready_skin1,
				components.skin1.Button_Friends,
			],
			[
				components.skin2.Button_AutoJoinTable,
				components.skin2.Button_CalcCards,
				components.skin2.Button_Chupai,
				components.skin2.Button_Confirm,
				components.skin2.Button_CpuPlay,
				components.skin2.Button_CpuPlayCancel,
				components.skin2.Button_CreateTable,
				components.skin2.Button_Exit,
				components.skin2.Button_Friends,
				components.skin2.Button_GameTalk,
				components.skin2.Button_Item,
				components.skin2.Button_ItemUse,
				components.skin2.Button_MsgEmotion,
				components.skin2.Button_MsgOption,
				components.skin2.Button_Page,
				components.skin2.Button_Ready,
				components.skin2.Button_SendGift,
				components.skin2.Button_Setup,
				components.skin2.Button_Shop,
				components.skin2.Button_ShopBuy,
				components.skin2.Button_ShopNoBuy,
				components.skin2.Button_ToLastTable,
				components.skin2.Button_ToLobbyFace,
				components.skin2.Button_ToRoom,
				components.skin2.Button_Vita,
				components.skin2.OptionWindow_CloseButton,
				imgTable2,imgChair2,Bg_DT_skin2,tableIdPanel_skin2,lobbyPanel_skin2,
				text_gamelist_skin2,text_gamelobby_skin2,bg_5_skin2,bg_4_skin2,
				Bg_shop_skin2,shop_text_skin2,item_text_skin2,systemBG_skin2,
				playerinfo_panel_skin2,text_createroom_skin2,text_optionWnd_skin2,
				optionWindow_text_skin2,friendslist_title_skin2,text_changeSkin_skin2,
				gameLogo_skin2,gamePanel_skin2,ButtonBg_skin2,
				sandglass_skin2,
				pass_skin2,
				CPUAI_skin2,
				ready_skin2,
				components.skin2.Button_Friends,
			],
			[
				components.skin3.Button_AutoJoinTable,
				components.skin3.Button_CalcCards,
				components.skin3.Button_Chupai,
				components.skin3.Button_Confirm,
				components.skin3.Button_CpuPlay,
				components.skin3.Button_CpuPlayCancel,
				components.skin3.Button_CreateTable,
				components.skin3.Button_Exit,
				components.skin3.Button_Friends,
				components.skin3.Button_GameTalk,
				components.skin3.Button_Item,
				components.skin3.Button_ItemUse,
				components.skin3.Button_MsgEmotion,
				components.skin3.Button_MsgOption,
				components.skin3.Button_Page,
				components.skin3.Button_Ready,
				components.skin3.Button_SendGift,
				components.skin3.Button_Setup,
				components.skin3.Button_Shop,
				components.skin3.Button_ShopBuy,
				components.skin3.Button_ShopNoBuy,
				components.skin3.Button_ToLastTable,
				components.skin3.Button_ToLobbyFace,
				components.skin3.Button_ToRoom,
				components.skin3.Button_Vita,
				components.skin3.OptionWindow_CloseButton,
				imgTable3,imgChair3,Bg_DT_skin3,tableIdPanel_skin3,lobbyPanel_skin3,
				text_gamelist_skin3,text_gamelobby_skin3,bg_5_skin3,bg_4_skin3,
				Bg_shop_skin3,shop_text_skin3,item_text_skin3,systemBG_skin3,
				playerinfo_panel_skin3,text_createroom_skin3,text_optionWnd_skin3,
				optionWindow_text_skin3,friendslist_title_skin3,text_changeSkin_skin3,
				gameLogo_skin3,gamePanel_skin3,ButtonBg_skin3,
				sandglass_skin3,
				pass_skin3,
				CPUAI_skin3,
				ready_skin3,
				components.skin3.Button_Friends,
			],
		];
		
		public static var skinPos:Array =
		[
			[//----------------------------------------------------------------
				//skin1
				[0,0,0,0],//Button_AutoJoinTable,
				[0,0,0,0],//Button_CalcCards,
				[0,0,0,0],//Button_Chupai,
				[0,0,0,0],//Button_Confirm,
				[0,0,0,0],//Button_CpuPlay,
				[0,0,0,0],//Button_CpuPlayCancel,
				[0,0,0,0],//Button_CreateTable,
				[0,0,0,0],//Button_Exit,
				[0,0,0,0],//Button_Friends,
				[0,0,0,0],//Button_GameTalk,
				[0,0,0,0],//Button_Item,
				[0,0,0,0],//Button_ItemUse,
				[0,0,0,0],//Button_MsgEmotion,
				[0,0,0,0],//Button_MsgOption,
				[0,0,0,0],//Button_Page,
				[0,0,0,0],//Button_Ready,
				[0,0,0,0],//Button_SendGift,
				[0,0,0,0],//Button_Setup,
				[0,0,0,0],//Button_Shop,
				[0,0,0,0],//Button_ShopBuy,
				[0,0,0,0],//Button_ShopNoBuy,
				[0,0,0,0],//Button_ToLastTable,
				[0,0,0,0],//Button_ToLobbyFace,
				[0,0,0,0],//Button_ToRoom,
				[0,0,0,0],//Button_Vita,
				[0,0,0,0],//OptionWindow_CloseButton,
				
				[0,0,0,0],//imgTable
				[0,0,0,0],//imgChair
				[0,0,0,0],//Bg_DT_skin
				[0,0,0,0],//tableIdPanel_skin
				[0,0,0,0],//lobbyPanel_skin
				[0,0,0,0],//text_gamelist_skin
				[0,0,0,0],//text_gamelobby_skin
				[0,0,0,0],//bg_5_skin
				[0,0,0,0],//bg_4_skin
				[0,0,0,0],//Bg_shop_skin
				[0,0,0,0],//shop_text_skin
				[0,0,0,0],//item_text_skin
				[0,0,0,0],//systemBG_skin
				[0,0,0,0],//playerinfo_panel_skin
				[0,0,0,0],//text_createroom_skin
				[0,0,0,0],//text_optionWnd_skin
				[0,0,0,0],//optionWindow_text_skin
				[0,0,0,0],//friendslist_title_skin
				[0,0,0,0],//text_changeSkin_skin
				[0,0,0,0],//gameLogo_skin
				[0,0,0,0],//gamePanel_skin
				[0,0,0,0],//ButtonBg_skin
				
				[0,0,0,0],//sandglass_skin
				[0,0,0,0],//pass_skin
				[0,0,0,0],//CPUAI_skin
				[0,0,0,0],//ready_skin
				
				[0,0,0,0],//Button_GameFriends,
			],
			[//-------------------------------------------------------------
				//skin2
				[0,0,0,0],//Button_AutoJoinTable,
				[0,0,0,0],//Button_CalcCards,
				[0,0,0,0],//Button_Chupai,
				[25,0,0,0],//Button_Confirm,
				[0,0,0,0],//Button_CpuPlay,
				[0,0,0,0],//Button_CpuPlayCancel,
				[0,0,0,0],//Button_CreateTable,
				[0,0,0,0],//Button_Exit,
				[0,0,0,0],//Button_Friends,
				[0,-5,0,0],//Button_GameTalk,
				[0,0,0,0],//Button_Item,
				[25,0,0,0],//Button_ItemUse,
				[0,-5,0,0],//Button_MsgEmotion,
				[0,-5,0,0],//Button_MsgOption,
				[0,0,0,0],//Button_Page,
				[0,0,0,0],//Button_Ready,
				[0,0,0,0],//Button_SendGift,
				[0,0,0,0],//Button_Setup,
				[0,0,0,0],//Button_Shop,
				[25,0,0,0],//Button_ShopBuy,
				[25,0,0,0],//Button_ShopNoBuy,
				[0,0,0,0],//Button_ToLastTable,
				[0,0,0,0],//Button_ToLobbyFace,
				[0,0,0,0],//Button_ToRoom,
				[0,0,0,0],//Button_Vita,
				[0,0,0,0],//OptionWindow_CloseButton,
				
				[0,0,0,0],//imgTable
				[0,0,0,0],//imgChair
				[0,0,0,0],//Bg_DT_skin
				[0,0,0,0],//tableIdPanel_skin
				[0,5,0,0],//lobbyPanel_skin
				[0,0,0,0],//text_gamelist_skin
				[0,0,0,0],//text_gamelobby_skin
				[0,0,0,0],//bg_5_skin
				[0,0,0,0],//bg_4_skin
				[0,0,0,0],//Bg_shop_skin
				[0,12,0,0],//shop_text_skin
				[0,12,0,0],//item_text_skin
				[0,0,0,0],//systemBG_skin
				[0,0,0,0],//playerinfo_panel_skin
				[10,12,0,0],//text_createroom_skin
				[0,0,0,0],//text_optionWnd_skin
				[0,0,0,0],//optionWindow_text_skin
				[0,12,0,0],//friendslist_title_skin
				[10,12,0,0],//text_changeSkin_skin
				[0,0,0,0],//gameLogo_skin
				[-37,7,0,0],//gamePanel_skin
				[0,0,0,0],//ButtonBg_skin
				
				[0,0,0,0],//sandglass_skin
				[0,0,0,0],//pass_skin
				[0,0,0,0],//CPUAI_skin
				[0,0,0,0],//ready_skin
				
				[0,0,0,0],//Button_GameFriends,
			],
			[//-------------------------------------------------------------
				//skin3
				[-4,-2,0,0],//Button_AutoJoinTable,
				[0,0,0,0],//Button_CalcCards,
				[0,0,0,0],//Button_Chupai,
				[0,0,0,0],//Button_Confirm,
				[0,0,0,0],//Button_CpuPlay,
				[0,0,0,0],//Button_CpuPlayCancel,
				[-8,-3,0,0],//Button_CreateTable,
				[0,0,0,0],//Button_Exit,
				[4,-2,0,0],//Button_Friends,
				[0,-5,0,0],//Button_GameTalk,
				[6,-3,0,0],//Button_Item,
				[0,0,0,0],//Button_ItemUse,
				[0,-5,0,0],//Button_MsgEmotion,
				[0,-5,0,0],//Button_MsgOption,
				[0,0,0,0],//Button_Page,
				[0,0,0,0],//Button_Ready,
				[0,0,0,0],//Button_SendGift,
				[1,1,0,0],//Button_Setup,
				[0,-3,0,0],//Button_Shop,
				[0,0,0,0],//Button_ShopBuy,
				[30,0,0,0],//Button_ShopNoBuy,
				[0,0,0,0],//Button_ToLastTable,
				[0,0,0,0],//Button_ToLobbyFace,
				[0,0,0,0],//Button_ToRoom,
				[10,-3,0,0],//Button_Vita,
				[0,0,0,0],//OptionWindow_CloseButton,
				
				[0,0,0,0],//imgTable
				[0,0,0,0],//imgChair
				[0,0,0,0],//Bg_DT_skin
				[0,0,0,0],//tableIdPanel_skin
				[0,0,0,0],//lobbyPanel_skin
				[0,0,0,0],//text_gamelist_skin
				[0,0,0,0],//text_gamelobby_skin
				[0,0,0,0],//bg_5_skin
				[0,0,0,0],//bg_4_skin
				[0,0,0,0],//Bg_shop_skin
				[0,12,0,0],//shop_text_skin
				[0,12,0,0],//item_text_skin
				[0,0,0,0],//systemBG_skin
				[0,12,0,0],//playerinfo_panel_skin
				[0,0,0,0],//text_createroom_skin
				[0,0,0,0],//text_optionWnd_skin
				[-24,0,0,0],//optionWindow_text_skin
				[0,12,0,0],//friendslist_title_skin
				[0,12,0,0],//text_changeSkin_skin
				[0,0,0,0],//gameLogo_skin
				[0,0,0,0],//gamePanel_skin
				[0,0,0,0],//ButtonBg_skin
				
				[0,0,0,0],//sandglass_skin
				[0,0,0,0],//pass_skin
				[0,0,0,0],//CPUAI_skin
				[0,0,0,0],//ready_skin
				
				[0,4,0,0],//Button_GameFriends,
			],
		];
		
	}
}