"use strict";

var userName = "";
var userId = -1;
var steamId = -1;
function SetPlayerId (data) {
	userId = data;
	$('#name').text = Players.GetPlayerName( userId );
}
function SetSteamId(data)
{
	steamId = data;
}



(function () {
	$.GetContextPanel().SetPlayerId = SetPlayerId;
	$.GetContextPanel().SetSteamId = SetSteamId;
})();

