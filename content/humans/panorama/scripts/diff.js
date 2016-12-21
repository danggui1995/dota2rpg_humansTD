"use strict"

function diffSelect(data)
{
	$('#haha').style.visibility = 'collapse';
	GameEvents.SendCustomGameEventToServer("__diff_selected",{diff:data});
}