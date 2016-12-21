"use strict"

function hidePanel()
{
	if ($('#main').style.visibility=='collapse')
	{
		$('#main').style.visibility="visible";
		$('#aaa').text="-";
		$('#main').SetHasClass("ComeIn",true);
		$.Schedule(0.25,__AddClass);
	}
	else
	{
		$('#main').SetHasClass("ComeOut",true)
		//$('#main').style.visibility="collapse";
		$('#aaa').text="+";
		$.Schedule(0.25,__RemoveClass);
	}
}

function __AddClass()
{
	$('#main').SetHasClass("ComeIn",false);
	
}

function __RemoveClass()
{
	$('#main').SetHasClass("ComeOut",false);
	$('#main').style.visibility = 'collapse';
}

function OnBaiJia()
{
    GameEvents.SendCustomGameEventToServer("__open_baijia",{});
}
function refreshRes(data)
{
	var m_data = CustomNetTables.GetTableValue( "food", "FoodInfo" );
	var m_data2 = CustomNetTables.GetTableValue( "wood", "WoodInfo" );
	var localid = Players.GetLocalPlayer();
	$('#resource_wood2').text=m_data2[localid+1]['wood'];
	$('#resource_food2').text=m_data[localid+1]['food'];
	if (data.data!=null && data.data!=undefined)
	{
		$('#resource_life').text = data.data;
	}
	
	//$('#resource_wood2').text=
}
function getLastHits()
{
	if (Players.IsValidPlayerID(0))
	{
		$('#kill1').text = Players.GetLastHits( 0 );
	}
	if (Players.IsValidPlayerID(1))
	{
		$('#kill2').text = Players.GetLastHits( 1 );
	}
	if (Players.IsValidPlayerID(2))
	{
		$('#kill3').text = Players.GetLastHits( 2 );
	}
	if (Players.IsValidPlayerID(3))
	{
		$('#kill4').text = Players.GetLastHits( 3 );
	}
}
function showPlayerList()
{
	if (Players.IsValidPlayerID(0))
	{
		$('#name1').text = Players.GetPlayerName( 0 );
		$('#pl1').style.visibility='visible';
	}
	else
	{
		$('#pl1').style.visibility='collapse';
	}
	if (Players.IsValidPlayerID(1))
	{
		$('#name2').text = Players.GetPlayerName( 1 );
		$('#pl2').style.visibility='visible';
	}
	else
	{
		$('#pl2').style.visibility='collapse';
	}
	if (Players.IsValidPlayerID(2))
	{
		$('#name3').text = Players.GetPlayerName( 2 );
		$('#pl3').style.visibility='visible';
	}
	else
	{
		$('#pl3').style.visibility='collapse';
	}
	if (Players.IsValidPlayerID(3))
	{
		$('#name4').text = Players.GetPlayerName( 3 );
		$('#pl4').style.visibility='visible';
	}
	else
	{
		$('#pl4').style.visibility='collapse';
	}
}
function updateKill()
{
	getLastHits();
	$.Schedule(0.3,updateKill);
}
function AddGold(data)
{
	var userId = data-1;
	var localid = Game.GetLocalPlayerID();
	var name2 = Players.GetPlayerName( localid );
	var _gold = Players.GetGold( localid );
	var name1 =  Players.GetPlayerName( userId );
	
	if (GameUI.IsAltDown())
	{
		_gold = Math.min(_gold,100);
	}
	else
	{
		_gold = Math.min(_gold,10);
	}
	
	GameEvents.SendCustomGameEventToServer("__jiaoyi_gold",{source:localid,target:userId,gold:_gold,name1:name2,name2:name1});
}

function reconnection(data)
{
	showPlayerList();
	refreshRes(data);
}
function OnCG(data)
{
	var ii;
	if(data=="+CG_1")
		ii=2;
	else if(data=="+CG_2")
		ii=1;
	else if(data=="+CG_3")
		ii=4;
	else if(data=="+CG_4")
		ii=3;
	var id = Game.GetLocalPlayerID();
	var name1 =  Players.GetPlayerName( id );
	GameEvents.SendCustomGameEventToServer("__chuguaikaiguan",{sourceName:name1,kg:ii});
}
(function () {
	//reconnection();
	updateKill();
	//GameUI.CustomUIConfig().getInRange = GetIsInRange;
	//GameEvents.Subscribe( "change_state_shop", ChangeState);
	Game.AddCommand( "OpenBaiJia", OnBaiJia, "", 0 );
	Game.AddCommand( "+CG_1", OnCG, "2", 0 );
	Game.AddCommand( "+CG_2", OnCG, "1", 0 );
	Game.AddCommand( "+CG_3", OnCG, "4", 0 );
	Game.AddCommand( "+CG_4", OnCG, "3", 0 );
	GameEvents.Subscribe( "__refresh", reconnection);
})();