package
{
	import components.processMsgbox;
	
	import flash.events.Event;
	
	import json.JSON;
	
	import lobystate.*;
	
	import mx.core.FlexGlobals;
	import mx.managers.CursorManager;
	import mx.managers.PopUpManager;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	// 对服务器发出连接和请求，并作出回应
	public class LobyNetManager
	{
		////////////// 常数定义	///////////////
		// 请求的地址定义
		// 连接地址的规范
		// 首先向一个统一的地址请求房间信息，我们称这个地址为固定loby地址，对这个地址的请求我们会得到一个
		// 新的loby地址
		// 我们将这个loby地址保存下来，这个被我们称为动态loby地址，它可能会有变化
		include "ServerAddress.ini"
		static public var URL_lobyAddress:String = ServerAddress + ServerPerfix+"/";
		//static public var URL_lobysonAddress:String = "http://192.168.18.24/web/world/";
		//static public var URL_lobysonAddress:String = "http://218.108.39.82:9000/web/world/";
		static public var URL_lobysonAddress:String = URL_lobyAddress;
		// 然后我们都通过这个地址来进行房间和桌子的信息请求
		static public const URL_roomInfo:String = "lobby/info/list";	// 大厅的信息
		static public const URL_addloby:String = "lobby/player/add";
		static public const URL_autoAddlobby:String = "game/room/autoAdd";
		static public const URL_leaveloby:String = "lobby/player/remove";
		static public const URL_roomPlayerlist:String = "lobby/player/list";
		static public const URL_playerInfo:String = "default/account/identity";
		static public const URL_tableInfo:String = "game/list/list";	// 房间中桌子的信息
		static public const URL_joinTable:String = "game/room/add";
		static public const URL_leaveTable:String = "game/room/remove";
		static public const URL_updateTableInfo:String = "game/room/update";	// 桌子上玩家的信息
		static public const URL_createTable:String = "game/room/create";
		static public const URL_getFriends:String = "game/friend/onlinelist";
		static public const URL_getTableSetting:String = "game/room/viewSetting";
		static public const URL_getInviteList:String = "game/list/invitation";
		static public const URL_refuseInvite:String = "lobby/player/decline";
		static public const URL_getItemEffect:String = "item/player/effectlist";
		static public const URL_sendGift:String = "game/friend/sendgift";
		static public const URL_checkGift:String = "game/friend/checkgift";
		// 各种请求定义
		static public const getlobyaddress:String = "request loby";
		static public const addloby:String = "join to loby";
		static public const autoaddlobby:String = "auto join";
		static public const leaveloby:String = "leave loby";
		static public const playerInfo:String = "request player info";
		static public const roomInfo:String = "request room info";
		static public const tableInfo:String = "request table info";
		static public const joinTable:String = "join table game";
		static public const leaveTable:String = "leave table";
		static public const getRoomPlayerlist:String = "get player list";
		static public const getTablePlayerInfo:String = "get table player info";
		static public const createTable:String = "create table";
		static public const getFriends:String = "get friends";
		static public const getTableSetting:String = "get table setting";
		static public const updateRoomtable:String = "up r t";
		static public const updateRoomplayerlist:String = "up r pl";
		static public const updateInvitelist:String = "up i l";
		static public const refuseInvite:String = "refuse i";
		static public const getitemeffect:String = "g i e";
		static public const sendgift:String = "sd g";
		static public const checkgift:String  = "ck g";
		
		//
		static private var instance:LobyNetManager = null;
		static private var httpser:HTTPService;
		static private var lobbyinfoUpdater:HTTPService;
		
		private var stateManager:StateManager = new StateManager();
		private var lobbyUpdaterstateManager:StateManager = new StateManager();
		
		private var processBox:processMsgbox = null;
		private var isProcessboxShowing:Boolean = false;
		// 这里本来打算加入flex自己带的http用的一个数据格式化工具，但是使用失败了。具体的使用看各处的json format注释
		// 经过考虑实际上是可行的，具体如下
		// 使用这个类就可以了com.adobe.serializers.json.JSONDecoder;
		// json format
		//static private var serializer0:JSONSerializationFilter = new JSONSerializationFilter();
		
		// 本次请求连接开始以后，不能够再进行请求
		private var requestEnable:Boolean = true;
		private var updateRequestenable:Boolean = true;
		
		private var result:Object = new Object();
		private var resultUpdate:Object = new Object();
		private var lastRlt:Object = new Object();
			// store for table data
		public var tabledata:Object = new Object();
		
		public function LobyNetManager()
		{
			httpser = new HTTPService();
			httpser.method = "POST";
			httpser.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			httpser.requestTimeout = 2;
			httpser.showBusyCursor = false;
			httpser.addEventListener(ResultEvent.RESULT, httpResult);
			httpser.addEventListener(FaultEvent.FAULT, httpFault);
			
			lobbyinfoUpdater = new HTTPService();
			lobbyinfoUpdater.method = "POST";
			lobbyinfoUpdater.resultFormat = HTTPService.RESULT_FORMAT_TEXT;
			lobbyinfoUpdater.requestTimeout = 2;
			lobbyinfoUpdater.showBusyCursor = false;
			lobbyinfoUpdater.addEventListener(ResultEvent.RESULT, lobbyupdateResult);
			lobbyinfoUpdater.addEventListener(FaultEvent.FAULT, lobbyupdateFault);
		}
		
		static public function get Instance():LobyNetManager
		{
			if(instance == null)
				instance = new LobyNetManager();
			return instance;
		}
		public function get httpservice():HTTPService
		{
			return httpser;
		}
		public function get lobbyUpdater():HTTPService
		{
			return lobbyinfoUpdater;
		}
		
		public function set RequestEnable(val:Boolean):void
		{
			requestEnable = val; 
		}
		public function get RequestEnable():Boolean
		{
			return requestEnable;
		}
		// 向服务器发送请求
		public function send(type:String, param1:String=null, param2:String=null, param3:String=null):void
		{
			// 请求保护，如果上次的请求还没有返回，不能开始下一次请求。
			if(!requestEnable)
				return;
			else
				requestEnable = false;
				
			if(type == getlobyaddress)
			{
				stateManager.changeState(StateGetLobyAddress.Instance);
			}
			else if(type == addloby)
			{
				stateManager.changeState(StateJoinLoby.Instance);
			}
			else if(type == autoaddlobby)
			{
				stateManager.changeState(StateAutojoinTable.Instance);
			}
			else if(type == leaveloby)
			{
				stateManager.changeState(StateLeaveLoby.Instance);
			}
			else if(type == playerInfo)
			{
				stateManager.changeState(StateGetPlayerInfo.Instance);
			}
			else if(type == roomInfo)
			{
				stateManager.changeState(StateUpdateRoomInfo.Instance);
			}
			else if(type == tableInfo)
			{
				stateManager.changeState(StateGetTableInfo.Instance);
			}
			else if(type == joinTable)
			{
				// 使用了参数1，该参数传递的是这张桌子的编号,  参数2 ，传递是桌子的位置
				httpser.url = URL_lobysonAddress+URL_joinTable;
				var p:int = -1;
				if(param2 == "up"+param1)
				{
					p = 0;
				}
				else if(param2 == "left"+param1)
				{
					p = 1;
				}
				else if(param2 == "down"+param1)
				{
					p = 2;
				}
				else if(param2 == "right"+param1)
				{
					p = 3;
				}
				else if(param2 == "invite"){
					p = 4;
				}
				else if(param2 == "toLast"){
					p = 5;
				}
				stateManager.changeState(StateLobyJoinTable.Instance);
				var rq:Object;
				if(p == 4){
					if(FlexGlobals.topLevelApplication.invitation.getAcceptInviteObj().hasOwnProperty("password")){
						rq = {"roomid":param1, "pw":FlexGlobals.topLevelApplication.invitation.getAcceptInviteObj().password, "getPlayers":"true"};
					}
					else{
						rq = {"roomid":param1, "getPlayers":"true"};
					}
//					StateLobyJoinTable.Instance.setTablename(FlexGlobals.topLevelApplication.invitation.getAcceptInviteObj().rname);
				}
				else if(p == 5){
					rq = {"roomid":param1, "getPlayers":"true"};
				}
				else{
					rq = {"roomid":tabledata[param1].rid.toString(), "pos":p, "pw":param3, "getPlayers":"true"};
//					StateLobyJoinTable.Instance.setTablename(tabledata[param1].name);
				}
				StateLobyJoinTable.Instance.setRequest(rq);
			}
			else if(type == leaveTable)
			{
				stateManager.changeState(StateLeaveTable.Instance);
			}
			else if(type == getRoomPlayerlist)
			{
				stateManager.changeState(StateGetRoomPlayerlist.Instance);
			}
			else if(type == getTablePlayerInfo)
			{
				stateManager.changeState(StateUpdateTableInfo.Instance);
			}
			else if(type == createTable)
			{
				stateManager.changeState(StateCreateTable.Instance);
			}
			else if(type == getFriends)
			{
				stateManager.changeState(StateGetFriends.Instance);
			}
			else if(type == getTableSetting)
			{
				stateManager.changeState(StateGetTableSettingFromLobby.Instance);
			}
			else if(type == refuseInvite)
			{
				stateManager.changeState(StateRefuseInvitation.Instance);
			}
			else if(type == getitemeffect)
			{
				stateManager.changeState(StateGetItemeffect.Instance);
			}
			else if(type == sendgift)
			{
				stateManager.changeState(StateSendGift.Instance);
			}
			else if(type == checkgift)
			{
				stateManager.changeState(StateCheckGift.Instance);
			}
			stateManager.send();
		}
		// 向服务器发送请求
		public function update(type:String):void
		{
			if(!updateRequestenable)
				return;
			else
				updateRequestenable = false;

			if(type == updateRoomtable)
			{
				lobbyUpdaterstateManager.changeState(StateUpdateRoomTable.Instance);
			}
			else if(type == updateRoomplayerlist)
			{
				lobbyUpdaterstateManager.changeState(StateUpdateRoomPlayerlist.Instance);
			}
			else if(type == updateInvitelist)
			{
				lobbyUpdaterstateManager.changeState(StateUpdateInvite.Instance);
			}
			lobbyUpdaterstateManager.send();
		}
		public function resend():void
		{
			if(!requestEnable)
				return;
			else
				requestEnable = false;
			httpservice.send();
		}
		
		public function httpResult(event:Event):void
		{
			// 恢复请求许可
			requestEnable = true;
			CursorManager.removeBusyCursor();

			try{
 			result = JSON.decode(httpser.lastResult.toString());
 			}catch(error:ArgumentError){
 				trace("json decode error");
 			}
			
			stateManager.receive(result);
			lastRlt = result;
		}

		public function httpFault(event:Event):void
		{
			// 恢复请求许可
			requestEnable = true;
			CursorManager.removeBusyCursor();
			stateManager.fault(event);
		}
		
		public function lobbyupdateResult(event:Event):void
		{
			// 恢复请求许可
			updateRequestenable = true;
			
			try{
				resultUpdate = JSON.decode(lobbyinfoUpdater.lastResult.toString());
			}catch(error:ArgumentError){
				trace("json decode error");
			}
			
			lobbyUpdaterstateManager.receive(resultUpdate);
		}
		public function lobbyupdateFault(event:Event):void
		{
			// 恢复请求许可
			updateRequestenable = true;
			lobbyUpdaterstateManager.fault(event);
		}
		
		
		/**
		 * 该部分是显示一个网络进行的状况，明确显示目前进行到什么步骤，以及何处出现了错误
		 * @return 该次操作是否成功
		 * 
		 */		
		public function showNetProcess(text:String):Boolean
		{
			// 创建置顶窗口一旦失败，游戏会出现大量异常表现，暂时先隐去
//			if(isProcessboxShowing){
//				if(processBox){
//					processBox.processMsg.text = text;
//					return true;
//				}
//				return false;
//			}
//			processBox = processMsgbox(PopUpManager.createPopUp(FlexGlobals.topLevelApplication.shopmenu, processMsgbox, false));
//			processBox.processMsg.text = text;

			isProcessboxShowing = true;
			return true;
		}
		public function closeNetProcess():Boolean
		{
			if(isProcessboxShowing){
				PopUpManager.removePopUp(processBox);
				isProcessboxShowing = false;
			}
			
			return true;
		}
	}
}