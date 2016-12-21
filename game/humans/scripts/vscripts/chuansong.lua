require('libraries/notifications')
function OnEnterGG( trigger )
	local hero = trigger.activator
	if hero:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		local unitname = hero:GetUnitName()
		local __len = string.len(unitname)
		local __type = string.sub(unitname,__len-1,__len)
		if __type=="11" or __type=="22" or __type=="33" or __type=="46" or __type=="61" then
			GameRules.life_num = GameRules.life_num - 5
		else
			GameRules.life_num = GameRules.life_num - 1
		end
		hero:RemoveSelf()
		if GameRules.life_num <= 0 then
			GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
			return 
		end
		sendToAllUi()
		Notifications:TopToAll({text="sy_life", duration=3.0,style={color="red",["font-size"]="40px"}})
		Notifications:TopToAll({text=GameRules.life_num, duration=3.0,style={color="red",["font-size"]="40px"},continue=true})
		if __type=="61" then
			local units = FindUnitsInRadius(DOTA_TEAM_BADGUYS, Vector(4480,1472,137), nil, 18000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,0,false) 
			if #units==0 then
				GameRules:MakeTeamLose(DOTA_TEAM_BADGUYS)
			end
		end
	end
end

function sendToAllUi()
	CustomGameEventManager:Send_ServerToAllClients("__refresh", {data=GameRules.life_num})
end