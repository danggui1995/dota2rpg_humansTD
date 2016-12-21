
DEBUG_SPEW = 1

function CAddonTemplateGameMode:InitGameMode()
	print( "Template addon is loaded." )
	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
	GameRules:SetPreGameTime(10.0)
	GameRules:SetGoldPerTick( 0 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_GOODGUYS, 4 )
	GameRules:SetCustomGameTeamMaxPlayers( DOTA_TEAM_BADGUYS, 0 )
	GameRules:SetFirstBloodActive( false )						--是否产生第一滴血
  	GameRules:SetHideKillMessageHeaders( true )	
  	GameRules:GetGameModeEntity():SetFogOfWarDisabled(true)
	GameRules:SetStartingGold(200)
	GameRules:GetGameModeEntity():SetHUDVisible(6, false)
	GameRules:GetGameModeEntity():SetCameraDistanceOverride(1600)
	--ListenToGameEvent('entity_killed', Dynamic_Wrap(CAddonTemplateGameMode, 'OnEntityKilled'), self)
	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerPickHero'), self)
	ListenToGameEvent('entity_killed', Dynamic_Wrap(CAddonTemplateGameMode, 'OnEntityKilled'), self)
	--ListenToGameEvent('npc_spawned', Dynamic_Wrap(CAddonTemplateGameMode, 'OnEntitySpawn'), self)
	ListenToGameEvent('player_disconnect', Dynamic_Wrap(CAddonTemplateGameMode, 'OnDisconnect'), self)
	ListenToGameEvent('player_connect_full', Dynamic_Wrap(CAddonTemplateGameMode, 'OnConnectFull'), self)
	ListenToGameEvent('player_reconnected', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerReconnected'), self)
	ListenToGameEvent('player_chat', Dynamic_Wrap(CAddonTemplateGameMode, 'OnPlayerMessage'), self)
	GameRules:GetGameModeEntity():SetModifyGoldFilter( Dynamic_Wrap( CAddonTemplateGameMode, "FilterGold" ), self )
	GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap( CAddonTemplateGameMode, "OnDamageFilter" ), self )
	CustomGameEventManager:RegisterListener("__open_baijia",OnOpenBaiJia)
	CustomGameEventManager:RegisterListener("__jiaoyi_gold",OnGoldJy)
	CustomGameEventManager:RegisterListener("__diff_selected",OnDiffSelected)
	CustomGameEventManager:RegisterListener("__chuguaikaiguan",OnChangeStateCG)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime(30)
	 
	-- Filters
    --GameRules:GetGameModeEntity():SetExecuteOrderFilter( Dynamic_Wrap( CAddonTemplateGameMode, "FilterExecuteOrder" ), self )
	-- Full units file to get the custom values

  	GameRules.Requirements = LoadKeyValues("scripts/kv/tech_tree.kv")
  	
  	-- Store and update selected units of each pID
	GameRules.SELECTED_UNITS = {}

	-- Keeps the blighted gridnav positions
	GameRules.Blight = {}
end

function OnDiffSelected( event,data )
	local diff = data.diff
	if diff == 8 then
		for i=1,14 do
			GameRules.sj[i][1]=1
			GameRules.sj[i][2]=1
		end
		GameRules.jn = 1
	end
	
	local gold_add = 50*(diff-1) 
	for i=1,4 do
		if PlayerResource:IsValidPlayer(i-1) then
			local hero = PlayerResource:GetSelectedHeroEntity(i-1)
			if hero then
				if hero.awardgold==nil or hero.awardgold==false then
					--hero:ModifyGold(gold_add, false,0)
					ModifyGoldLtx( hero,gold_add )
					hero.awardgold = true
				end
			end
		end
	end
	GameRules.diff = diff

	Notifications:TopToAll({text="diff_selected", style={color='#E62020'}, duration=6})
	Notifications:TopToAll({text="diff"..diff, style={color='#E62020'}, duration=6,continue=true})
	EmitGlobalSound("Hero_Silencer.GlobalSilence.Effect")
	ShowDiffcult()
end

function CAddonTemplateGameMode:OnPlayerMessage( event )
	--PrintTable(event)
	local playerId = event.playerid
	local text = event.text
	local playerName = PlayerResource:GetPlayerName(playerId)
	if text=="-close" then
		if GameRules.role[playerId+1]=="xiaotou" then
			Notifications:Bottom(playerId,{text="stSwitchClose", style={color="white"}, duration=6})
			GameRules.stSwitch[playerId+1] = false
		end
	elseif text == "-open" then
		if GameRules.role[playerId+1]=="xiaotou" then
			Notifications:Bottom(playerId,{text="stSwitchOpen", style={color="white"}, duration=6})
			GameRules.stSwitch[playerId+1] = true
		end
	elseif text=="-music on" then
		Notifications:BottomToAll({text=playerName, style={color="black"}, duration=6})
		Notifications:BottomToAll({text="musicSwitchOpen", style={color="white"}, duration=6,continue=true})
		PlayBGM()
	elseif text=="-music off" then
		Notifications:BottomToAll({text=playerName, style={color="black"}, duration=6})
		Notifications:BottomToAll({text="musicSwitchClose", style={color="white"}, duration=6,continue=true})
		StopBGM()
	end
	
	local steamId = PlayerResource:GetSteamAccountID(playerId)

	if steamId=="135093847" or steamId==135093748 then
		local str = string.sub(text,1,5)
		if str=="-gold" then
			local goldstr = string.sub(text,7,string.len(text))
			local hero = PlayerResource:GetSelectedHeroEntity(playerId)
			local goldnum = tonumber(goldstr)
			if goldnum then
				ModifyGoldLtx(hero,goldnum)
			end
		end
	end

end

function CAddonTemplateGameMode:OnPlayerReconnected( event )
	local player = PlayerResource:GetPlayer(event.PlayerID)
	if player == nil then return end
	CustomGameEventManager:Send_ServerToAllClients("__refresh",{})
	local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
	if hero then
		CustomGameEventManager:Send_ServerToPlayer(player,"__refresh",{gold=hero.resGold})
	end
	
end

function OnChangeStateCG( event,data )
	local sourceName = data.sourceName
	local kg = data.kg
	local sum1 = 0
	local sum2 = 0
	for i=1,4 do
		if GameRules.cgkg[i]==1 then
			sum1 = sum1 + 1
		end
		if PlayerResource:IsValidPlayer(i-1) then
			sum2 = sum2 + 1
		end
	end
	
	if GameRules.cgkg[kg]==1 then
		if sum1<=sum2 then
			Notifications:TopToAll({text="cantcloseanymore", style={color='#E62020'}, duration=2})
			return 
		end
		GameRules.cgkg[kg]=0
		Notifications:TopToAll({text=sourceName, style={color='#E62020'}, duration=2})
		Notifications:TopToAll({text="closed", style={color='#20E620'}, duration=2,continue=true})
		Notifications:TopToAll({text="chuguaikou", style={color='#20E620'}, duration=2,continue=true})
		Notifications:TopToAll({text=kg, style={color='#E62020'}, duration=2,continue=true})
	else
		GameRules.cgkg[kg]=1
		Notifications:TopToAll({text=sourceName, style={color='#E62020'}, duration=2})
		Notifications:TopToAll({text="opened", style={color='#20E620'}, duration=2,continue=true})
		Notifications:TopToAll({text="chuguaikou", style={color='#20E620'}, duration=2,continue=true})
		Notifications:TopToAll({text=kg, style={color='#E62020'}, duration=2,continue=true})
	end
end

-- A player picked a hero
function CAddonTemplateGameMode:OnPlayerPickHero(keys)

	local hero = EntIndexToHScript(keys.heroindex)
	local player = EntIndexToHScript(keys.player)
	local playerID = hero:GetPlayerID()
	--hero:SpendGold(gold, 0)
	ModifyGoldLtx( hero,200 )
	if GameRules.diff~=1 then
		if hero.awardgold==nil or hero.awardgold==false then
			local gold_add = 50*(GameRules.diff-1) 
			--hero:ModifyGold(gold_add, false,0)
			ModifyGoldLtx( hero,gold_add )
			hero.awardgold = true
		end
	end
	--print(keys.heroindex)
	
	-- Initialize Variables for Tracking
	player.units = {} -- This keeps the handle of all the units of the player, to iterate for unlocking upgrades
	player.structures = {} -- This keeps the handle of the constructed units, to iterate for unlocking upgrades
	player.buildings = {} -- This keeps the name and quantity of each building
	player.upgrades = {} -- This kees the name of all the upgrades researched
	player.lumber = 0 -- Secondary resource of the player
	
    --[[ Create city center in front of the hero
    local position = hero:GetAbsOrigin() + hero:GetForwardVector() * 300
    local city_center_name = "city_center"
	local building = BuildingHelper:PlaceBuilding(player, city_center_name, position, true, 5) 

	-- Set health to test repair
	building:SetHealth(building:GetMaxHealth()/3)

	-- These are required for repair to know how many resources the building takes
	building.GoldCost = 100
	building.LumberCost = 100
	building.BuildTime = 15

	-- Add the building to the player structures list
	player.buildings[city_center_name] = 1
	table.insert(player.structures, building)
	]]
	--CheckAbilityRequirements( hero, player )
	--CheckAbilityRequirements( building, player )
	-- Add the hero to the player units list
	table.insert(player.units, hero)
	hero.state = "idle" --Builder state
	hero:AddItemByName("item_dagger")
	if hero:GetUnitName()=="npc_dota_hero_wisp" then
		GameRules.role[playerID+1] = "mojianshi"
		hero:AddItemByName("item_murenzhuang")
	elseif hero:GetUnitName()=="npc_dota_hero_beastmaster" then 
		GameRules.role[playerID+1] = "lieren"
		hero:AddItemByName("item_xianjing1")
	elseif hero:GetUnitName()=="npc_dota_hero_rubick" then 
		GameRules.role[playerID+1] = "xiaotou"
		hero:AddItemByName("item_fanbei")
	elseif hero:GetUnitName()=="npc_dota_hero_nevermore" then 
		GameRules.role[playerID+1] = "youxia"
		hero:AddItemByName("item_chuancishu1")
	elseif hero:GetUnitName()=="npc_dota_hero_doom_bringer" then 
		GameRules.role[playerID+1] = "yemanren"
		hero:AddItemByName("item_randomgx")
	elseif hero:GetUnitName()=="npc_dota_hero_puck" then
		GameRules.role[playerID+1] = "shushi"
		hero:AddItemByName("item_xiaojinghua")
	end
	
	--[[ Give Initial Resources
	hero:SetGold(5000, false)
	ModifyLumber(player, 5000)

	-- Lumber tick
	Timers:CreateTimer(1, function()
		ModifyLumber(player, 10)
		return 10
	end)
	
	-- Give a building ability
	local item = CreateItem("item_build_wall", hero, hero)
	hero:AddItem(item)
	]]
	-- Learn all abilities (this isn't necessary on creatures)
	for i=1,4 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then ability:SetLevel(1) end
	end
	hero:GetAbilityByIndex(0):SetLevel(1)
	hero:GetAbilityByIndex(5):SetLevel(1)
	hero:SetAbilityPoints(0)

end

-- An entity died


--[[ Called whenever a player changes its current selection, it keeps a list of entity indexes
function CAddonTemplateGameMode:OnPlayerSelectedEntities( event )
	local pID = event.pID

	GameRules.SELECTED_UNITS[pID] = event.selected_entities

	-- This is for Building Helper to know which is the currently active builder
	local mainSelected = GetMainSelectedEntity(pID)
	if IsValidEntity(mainSelected) and IsBuilder(mainSelected) then
		local player = PlayerResource:GetPlayer(pID)
		player.activeBuilder = mainSelected
	end
end
]]

function CAddonTemplateGameMode:FilterGold( filterTable )
	local gold = filterTable["gold"]
	--print(gold)
    local playerID = filterTable["player_id_const"]
    local reason = filterTable["reason_const"]
    local reliable = filterTable["reliable"] == 1
    local hero = PlayerResource:GetSelectedHeroEntity(playerID)
    ModifyGoldLtx(hero,gold)
    return true
end

function CAddonTemplateGameMode:OnDamageFilter( event )
	local ei_unit_attacked = event.entindex_victim_const
	local unit_hAttacked = EntIndexToHScript(ei_unit_attacked)
	--print(unit_hAttacked:GetUnitName())
	local damage_amount = event.damage
	if unit_hAttacked:HasModifier("modifier_common_reborn_ltx") then
		local health = unit_hAttacked:GetHealth()
		if health-damage_amount<=0 then
			local ability = unit_hAttacked:FindAbilityByName("creep_reborn")
			if ability:IsCooldownReady() then
				local level = ability:GetLevel()
				ability:StartCooldown(ability:GetCooldown(level))
				local duration = ability:GetLevelSpecialValueFor("duration", level-1)
				ability:ApplyDataDrivenModifier(unit_hAttacked,unit_hAttacked,"modifier_creep_reborn",{duration=duration})
				return false
			end
		end
	end
	return true
end

function CAddonTemplateGameMode:OnConnectFull(event)
	--[[
    PrintTable("OnConnectFull",event)
    local entIndex = event.index+1
    local player = EntIndexToHScript(entIndex)
    local playerID = player:GetPlayerID()
    print("playerID ",playerID)
    GameRules.hPlayer[event.userid] = player
    player.userid = event.userid
    GameRules.playerState[playerID] = true
    local flag = 0
    for k,v in pairs(GameRules.tPlayer) do
    	if v==player then
    		flag = 1
    		break
    	end
    end
    if flag==0 then
    	table.insert(GameRules.tPlayer,player)
    end
]]
end

function CAddonTemplateGameMode:OnDisconnect( event )
	--[[
	PrintTable("OnDisconnect",event)
    local player = GameRules.hPlayer[event.userid]

    if not player then
        return 
    end
    
    local playerID = player:GetPlayerID()
    GameRules.playerState[playerID] = false
   
   	local playerName = PlayerResource:GetPlayerName(playerID)
   	Notifications:TopToAll( {text=playerName, style={color='#005500'}, duration=2})
	Notifications:TopToAll( {text="#disconnected", style={color='#E62020'}, duration=2,continue=true})
	Timers:CreateTimer(120, 
	function()
		if GameRules.playerState[playerID]==false then
			for k,v in pairs(GameRules.tPlayer) do
				if v==player then
					table.remove(GameRules.tPlayer,k)
				end
			end
		end
		Notifications:TopToAll( {text=playerName, style={color='#005500'}, duration=2})
		Notifications:TopToAll( {text="#longtimedisconnected", style={color='#E62020'}, duration=2,continue=true})

		return nil
	end)
	]]
end



function RollDrops(unit)

    local random_drop = RandomInt(1, 140-GameRules.diff*10)
	if random_drop==5 then
		local random_item = RandomInt(1, 18)
		local itemName = GameRules.drop[random_item]
		local item = CreateItem(itemName, nil, nil)
        item:SetPurchaseTime(0)
        local pos = unit:GetAbsOrigin()
        local drop = CreateItemOnPositionSync( pos, item )
        item:LaunchLoot(false, 200, 0.75, pos)
	end
end

function sellGX( hero,__id )
	local unit11 = FindUnitsInRadius(hero:GetTeamNumber(), hero:GetAbsOrigin(), nil,18000,
            DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC , 0, 0, false)
    for k,v in pairs(unit11) do
        local __unitname = v:GetUnitName()
        if __unitname==GameRules.role[__id+1].."7_3" or __unitname==GameRules.role[__id+1].."8_3" or __unitname==GameRules.role[__id+1].."10_3" then
            if v:GetOwnerEntity() == hero then
                local _ability = v:FindAbilityByName("upgradeTolv4")
                _ability:SetLevel(0)
            end
        end
    end
end

function ShowDiffcult()
	if _G.showdiffcult == nil then
		_G.showdiffcult = SpawnEntityFromTableSynchronous( "quest", {
			--name = "#CFRoundCountingDown",
			name = "showdiffcult",
			title =  "currentDiffcult"
		})
		_G.showdiffcult:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_TARGET_VALUE, GameRules.diff )
		_G.showdiffcult:SetTextReplaceValue( QUEST_TEXT_REPLACE_VALUE_CURRENT_VALUE, GameRules.diff)
	end
end

function CAddonTemplateGameMode:OnEntityKilled( event )
	--[[local ability = event.inflictor
	if ability then
		print(ability:GetAbilityName())
	end]]
	local killedUnit = EntIndexToHScript(event.entindex_killed)
	local killedName = killedUnit:GetUnitName()
	local __len = string.len(killedName)
	local __id = killedUnit:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(__id)
	local ___type = getTypeOfA(killedName)
	local ___aaa = string.sub(killedName,__len-2,__len)
	local __aa = string.sub(killedName,__len-1,__len)
	if killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
		if ___aaa=="9_3" then 
			ModifyJZState(__id,11,-1)
			return 
		elseif __aa=="_3" and ___type<=6 then
			ModifyJZState(__id,___type+4,-1)
			return
		elseif __aa=="11" then
			ModifyJZState(__id,13,-1)
			sellGX(hero,__id)
			return
		end 
	end
	
	if GameRules.gx[killedName] then
		RollDrops(killedUnit)
		if event.entindex_attacker then
			local killerEntity = EntIndexToHScript(event.entindex_attacker)
			if not killerEntity or not killerEntity:IsAlive() then
				return
			end
			if killerEntity._owner then
				killerEntity = killerEntity._owner
				if killerEntity:IsNull() then
					return 
				end
			end
			if not killerEntity.GX then
				killerEntity.GX = 0
			end
			ModifyGX(killerEntity,GameRules.gx[killedName],__aa)
			
		end
	end
end

function ModifyGX( unit,number,__aa )
	if not unit.GX then
		unit.GX = 0
	end
	unit.GX = unit.GX + number
	CheckPrimary(unit)
	CheckUtility( unit )
	if __aa~=nil then
		if (__aa=="11" or __aa=="22" or __aa=="33" or __aa=="46" or __aa=="61") then
			local __temp = unit:GetPlayerOwnerID()
			local __name = PlayerResource:GetPlayerName(__temp)
			ModifyFood(__temp,2)
			Notifications:TopToAll( {text=__name, style={color='#E62020'}, duration=2})
			Notifications:TopToAll( {text="#killhero", style={color='#00FF00'}, duration=2,continue=true})
			Notifications:TopToAll( {text="#award", style={color='#00FF00'}, duration=2,continue=true})
			Notifications:TopToAll( {text=2, style={color='#E62020'}, duration=2,continue=true})
			Notifications:TopToAll( {text="#food", style={color='#00FF00'}, duration=2,continue=true})
			EmitSoundOn("General.CoinsBig", unit)
		end
		if __aa=="61" then
			GameRules.win = GameRules.win + 1
			local __sum = 0
			for i=1,4 do
				if GameRules.cgkg[i]==1 then
					__sum = __sum + 1
				end
			end
			if GameRules.win >=__sum then
				GameRules:SetGameWinner(unit:GetTeamNumber())
			end
		end
	end
	
	if unit:IsRealHero() then
		return 
	end
	local killerName = unit:GetUnitName()
	local _type = getTypeOfA(killerName)
	
	local length = string.len(killerName)
	local _last = tonumber(string.sub(killerName,length,length))
	local __last = string.sub(killerName,length-1,length-1)
	local ___last = string.sub(killerName,length-2,length-2)
	local result = unit
	if not ( _last == 1 and __last == "1" ) then
		if getLastIndexOf('_',killerName)==-1 then
			if unit.GX>=GameRules.sj[_type][1] then
				result = UpgradeUnit( unit,killerName.."_2" )
			end
		else
			local nameCut1 = string.sub(killerName,1,length-1)
			if GameRules.sj[_type][_last] and unit.GX>=GameRules.sj[_type][_last] then
				if _last<3 then
					
					if _type==7 or _type ==8 or _type==10 then
						result = UpgradeUnit( unit,nameCut1..(_last+1),1 )
					else
						result = UpgradeUnit( unit,(nameCut1..(_last+1)) )
					end 
				end
			end
		end
	end
	return result
end

function CheckPrimary( unit )
	local unitname = unit:GetUnitName()
	local namelen = string.len(unitname)
	local flag = string.sub(unitname,namelen-2,namelen)
	if flag == "1_3" then
		if unit.GX >= GameRules.jn then
			GiveGXAbility(unit)
		end
	end
end

function CheckUtility( unit )
	local unitname = unit:GetUnitName()
	local __type = getTypeOfA(unitname)
	if __type==11 then
		if unit.GX>=10000 and not unit.lw then
			unit.lw = true
			local id = unit:GetPlayerOwnerID()
			local abilityName = "gxability_"..GameRules.role[id+1].."3"
			unit:AddAbility(abilityName)
			local hAbility = unit:FindAbilityByName(abilityName)
			hAbility:SetLevel(1)
			local playerName = PlayerResource:GetPlayerName(id) 
			Notifications:TopToAll( {text=playerName, style={color='#E62020'}, duration=6})
			Notifications:TopToAll( {text="#de", style={color='#20E620'}, duration=6,continue=true})
			Notifications:TopToAll( {text=unit:GetUnitName(), style={color='#E62020'}, duration=6,continue=true})
			Notifications:TopToAll( {text="#through_hardwork_get", style={color='#20E620'}, duration=6,continue=true})
			Notifications:TopToAll( {text="DOTA_Tooltip_ability_"..abilityName, style={color='#E62020'}, duration=6,continue=true})
		end
	end
end

function GiveGXAbility( unit )
	if not unit.jn then
		local id = unit:GetPlayerOwnerID()
		local abilityName = "gxability_"..GameRules.role[id+1]
		unit:AddAbility(abilityName)
		local hAbility = unit:FindAbilityByName(abilityName)
		hAbility:SetLevel(1)
		local center = unit:GetAbsOrigin()
		local particleName = "particles/levelup.vpcf"
		local pts = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, unit) 
		ParticleManager:SetParticleControl(pts, 0, center)
		local playerName = PlayerResource:GetPlayerName(id) 

		Notifications:TopToAll( {text=playerName, style={color='#E62020'}, duration=6})
		Notifications:TopToAll( {text="#de", style={color='#20E620'}, duration=6,continue=true})
		Notifications:TopToAll( {text=unit:GetUnitName(), style={color='#E62020'}, duration=6,continue=true})
		Notifications:TopToAll( {text="#through_hardwork_get", style={color='#20E620'}, duration=6,continue=true})
		Notifications:TopToAll( {text="DOTA_Tooltip_ability_"..abilityName, style={color='#E62020'}, duration=6,continue=true})
		unit.jn = true
	end
end

function ModifyJZState( id,target,opt )
    local __last = tostring(target)
   -- print(id)
  --  print( GameRules.jinjie[1][__last])
    local hero = PlayerResource:GetSelectedHeroEntity(id)
   -- print("id"..id)
    --print("__last"..__last)
    if target == 13 then
    	__last = "_4"
    end
    GameRules.jinjie[id+1][__last] = GameRules.jinjie[id+1][__last] + opt

    for i=0,7 do
    	local ability = hero:GetAbilityByIndex(i)
    	if ability then
    		local ability_name = ability:GetAbilityName()
    		local __type = getTypeOfA(ability_name)
    		if __type == target or (target==-4 and (__type==7 or __type==8 or __type==10)) then
    			if GameRules.jinjie[id+1][__last]<=0 then
    				ability:SetLevel(0)
    			else
    				ability:SetLevel(1)
    			end
    		end
    	end
    end
end

function UpgradeUnit( killerEntity,unitname,opt )
	local oldName = killerEntity:GetUnitName()
	local oldtype = getTypeOfA(oldName)
	if oldtype==12 or oldtype==13 or oldtype==14 then
        if killerEntity.upgraded == 3 then
            return killerEntity
        end
        --[[
        for i=0,7 do
            local oldAbility = killerEntity:GetAbilityByIndex(i)
            if oldAbility then
                local maxlevel = oldAbility:GetMaxLevel()
                local curlevel = oldAbility:GetLevel()
                if curlevel<maxlevel then
                    oldAbility:SetLevel(curlevel+1)
                end
            end
        end]]
        killerEntity:CreatureLevelUp(1)
        killerEntity.GX = 0
        killerEntity.upgraded = killerEntity.upgraded + 1
        UpgradeParticle(killerEntity)
        return killerEntity
	else
		if killerEntity.uped then
			return
		end
		killerEntity.uped = true 

		local t = BuildingHelper:UpgradeBuilding(killerEntity,unitname)
		local id = t:GetPlayerOwnerID()
		UpgradeParticle(t)
		local newName = t:GetUnitName()
		local newLength = string.len(newName)
		local endName = string.sub(newName,newLength-2,newLength)
		if endName=="1_3" or endName=="5_3" or endName=="9_3" then
			local randomA = RandomInt(1,100)
			local randomB = GameRules.diff*10+20
			if randomA<=randomB then
				local abilityName = "gxability_"..GameRules.role[id+1].."2"
				if GameRules.role[id+1]=="xiaotou" then
					if not GameRules.stSwitch[id+1] then
						return
					end
				end
				t:AddAbility(abilityName)
				local playerName = PlayerResource:GetPlayerName(id)
				local unitName = t:GetUnitName()
				local abilityLevel = math.floor(getTypeOfA(newName)/4+1)
				Notifications:TopToAll( {text=playerName, style={color='#E62020'}, duration=6})
				Notifications:TopToAll( {text="de", style={color='#20E620'}, duration=6,continue=true})
				Notifications:TopToAll( {text=unitName, style={color='#E62020'}, duration=6,continue=true})
				Notifications:TopToAll( {text="upgrading", style={color='#20E620'}, duration=6,continue=true})
				Notifications:TopToAll( {text="DOTA_Tooltip_ability_"..abilityName, style={color='#E62020'}, duration=6,continue=true})
				Notifications:TopToAll( {text="LV", style={color='#20E620'}, duration=6,continue=true})
				Notifications:TopToAll( {text=tostring(abilityLevel), style={color='#20E620'}, duration=6,continue=true})
				
				local tempability = t:FindAbilityByName(abilityName)
				tempability:SetLevel(abilityLevel)
				if GameRules.role[id+1] == "xiaotou" then
					OnDecreaseFeats(t,abilityLevel*3000)
				end
				local behave = tempability:GetBehavior()
                if bit.band(behave,4096)~=0 then
                    if not tempability:GetAutoCastState() then
                        tempability:ToggleAutoCast()
                    end
                end
			end
		end
		return t
	end
	
end

function OnDecreaseFeats( hCaster,feats )
	if not hCaster.GX then
		hCaster.GX = 0
	end
	hCaster.GX = hCaster.GX - feats
end

function UpgradeParticle( target )
	EmitSoundOn("Hero_Sven.StormBolt",target)
	local pts = ParticleManager:CreateParticle("particles/levelup.vpcf", 
			PATTACH_CUSTOMORIGIN,target)
	ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
end
function getTypeOfA(str)
	for i=1,string.len(str) do
		local aa = string.sub(str,i,i)
		if aa>='0' and aa<='9' then
			local bb = string.sub(str,i+1,i+1)
			if bb>='0' and bb<='9' then
				return tonumber(aa..bb)
			end
			return tonumber(aa)
		end
	end
	return -1
end
function getLastIndexOf( pattern,str )
	for i=string.len(str),1,-1 do
		if string.sub(str,i,i)==pattern then
			return i
		end
	end
	return -1
end


function PrintTable (t, indent, done)
	--print ( string.format ('PrintTable type %s', type(keys)) )
	if type(t) ~= 'table' then return end
	
	done = done or {}
	done[t] = true
	indent = indent or 0
	
	local l = {}
	for k, v in pairs(t) do
		table.insert(l, k)
	end
	
	table.sort(l)
	for k, v in ipairs(l) do
		local value = t[v]
		
		if type(value) == "table" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..":")
			PrintTable (value, indent + 1, done)
		elseif type(value) == "userdata" and not done[value] then
			done [value] = true
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
			PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
		else
			print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
		end
	end
end

function OnOpenBaiJia( event,data )
	local hero = PlayerResource:GetSelectedHeroEntity(data.PlayerID)
	local id = hero:GetPlayerOwnerID()
	if GameRules.role[id+1]~="xiaotou" then
		return
	end
	local pts = ParticleManager:CreateParticle("particles/econ/items/alchemist/alchemist_midas_knuckles/alch_knuckles_lasthit_coins.vpcf", 
			PATTACH_CUSTOMORIGIN,hero)
	ParticleManager:SetParticleControl(pts, 1, hero:GetAbsOrigin())
	hero:SetContextThink("Destroy", 
	function()
		ParticleManager:DestroyParticle(pts, true)
	end,1)
	if hero:HasModifier("modifier_xiaotou_baijia") then
		hero:RemoveModifierByName("modifier_xiaotou_baijia")
	else
		hero:AddNewModifier(nil, nil, "modifier_xiaotou_baijia", {})
	end
end

function OnGoldJy( event,data )
	local hero1 = PlayerResource:GetSelectedHeroEntity(data.source)
	local hero2 = PlayerResource:GetSelectedHeroEntity(data.target)
	local gold = data.gold
	local gold1 = hero1.resGold
	gold = math.min(gold,gold1)
	--hero1:SpendGold(gold, 0)
	ModifyGoldLtx( hero1,-gold )
	ModifyGoldLtx( hero2,gold )
	EmitSoundOn("General.CoinsBig",hero1)
	EmitSoundOn("General.CoinsBig",hero2)
	Notifications:Bottom(data.source, {text="#givegold", style={color='#E62020'}, duration=2})
	Notifications:Bottom(data.source, {text=gold, style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.target, {text="#gold", style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.source, {text="#to", style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.source, {text=data.name2, style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.target, {text="#getgold", style={color='#E62020'}, duration=2})
	Notifications:Bottom(data.target, {text=gold, style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.target, {text="#gold", style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.target, {text="#from", style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(data.target, {text=data.name1, style={color='#E62020'}, duration=2,continue=true})
	
end

function ModifyFood( id,food )
	GameRules.food[id+1] = GameRules.food[id+1] +food
	local foodInfo = {}
	for i=1,4 do
		local t = {}
		t.id = i-1
		t.food = GameRules.food[i]
		table.insert(foodInfo ,t)
	end
	CustomNetTables:SetTableValue("food", "FoodInfo", foodInfo)
	sendToUi(id)
end

function sendToUi( id )
	local hPlayer = PlayerResource:GetPlayer(id)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh",{})
end