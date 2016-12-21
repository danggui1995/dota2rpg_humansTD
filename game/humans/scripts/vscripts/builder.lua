-- A build ability is used (not yet confirmed)
function Build( event )
    local caster = event.caster
    local ability = event.ability
    local ability_name = ability:GetAbilityName()
    local building_name = ability:GetAbilityKeyValues()['UnitName']
    local hero = caster:IsRealHero() and caster or caster:GetOwner()
    local playerID = hero:GetPlayerID()
    local level = ability:GetLevel() - 1
    local food = ability:GetLevelSpecialValueFor("food", level)
    local wood = ability:GetLevelSpecialValueFor("wood", level)
    local gold = ability:GetLevelSpecialValueFor("gold", level)
    -- If the ability has an AbilityGoldCost, it's impossible to not have enough gold the first time it's cast
    -- Always refund the gold here, as the building hasn't been placed yet
    if not PlayerHasEnoughGold(playerID,gold) then
    	SendErrorMessage(playerID, "#no_enough_gold")
    	return 
    end
    if not PlayerHasEnoughLumber(playerID,wood) then
    	SendErrorMessage(playerID, "#no_enough_wood")
    	return
    end
    if not PlayerHasEnoughFood(playerID,food) then
    	SendErrorMessage(playerID, "#no_enough_food")
    	return 
    end
    -- Makes a building dummy and starts panorama ghosting
    BuildingHelper:AddBuilding(event)

    -- Additional checks to confirm a valid building position can be performed here
    event:OnPreConstruction(function(vPos)

        -- Check for minimum height if defined
        if not BuildingHelper:MeetsHeightCondition(vPos) then
            SendErrorMessage(playerID, "#error_invalid_build_position")
            return false
        end

        return true
    end)

    -- Position for a building was confirmed and valid
    event:OnBuildingPosChosen(function(vPos)
        -- Spend resources
        --print(gold)
        --hero:SpendGold(gold, 0)
        ModifyGoldLtx( hero,-gold )
        --hero:ModifyGold(-gold, true, 0)
        ModifyFood(playerID,-food)
        ModifyWood(playerID,-wood)

        -- Play a sound
        EmitSoundOn( "DOTA_Item.ObserverWard.Activate",hero)
    end)

    -- The construction failed and was never confirmed due to the gridnav being blocked in the attempted area
    event:OnConstructionFailed(function()
        local playerTable = BuildingHelper:GetPlayerTable(playerID)
        local name = playerTable.activeBuilding

        BuildingHelper:print("Failed placement of " .. name)
    end)

    -- Cancelled due to ClearQueue
    event:OnConstructionCancelled(function(work)
        --[[local name = work.name
        BuildingHelper:print("Cancelled construction of " .. name)

        -- Refund resources for this cancelled work
        if work.refund then
            hero:ModifyGold(gold_cost, false, 0)
        end]]
        if work.refund then
        	--hero:ModifyGold(gold, false, 0)
        	ModifyGoldLtx( hero,gold )
        	ModifyFood(playerID,food)
        	ModifyWood(playerID,wood)
        end
        
    end)

    -- A building unit was created
    event:OnConstructionStarted(function(unit)
        BuildingHelper:print("Started construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        -- Play construction sound

        -- If it's an item-ability and has charges, remove a charge or remove the item if no charges left
        if ability.GetCurrentCharges and not ability:IsPermanent() then
            local charges = ability:GetCurrentCharges()
            charges = charges-1
            if charges == 0 then
                ability:RemoveSelf()
            else
                ability:SetCurrentCharges(charges)
            end
        end
        local __item = string.sub(ability_name,1,4)
        if __item == "item" then
        	hero:RemoveItem(ability)
        end
        local __unitname = unit:GetUnitName()
        if __unitname=="yemanren8" then
            ModifyJZState( playerID,8,-999 )
        end
        -- Units can't attack while building
        unit.original_attack = unit:GetAttackCapability()
        unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        unit.upgraded = 1
        -- Give item to cancel
       -- local item = CreateItem("item_building_cancel", hero, hero)
        --unit:AddItem(item)

        -- FindClearSpace for the builder
        FindClearSpaceForUnit(caster, caster:GetAbsOrigin(), true)
        caster:AddNewModifier(caster, nil, "modifier_phased", {duration=0.03})

        -- Remove invulnerability on npc_dota_building baseclass
        unit:RemoveModifierByName("modifier_invulnerable")
    end)

    -- A building finished construction
    event:OnConstructionCompleted(function(unit)
        BuildingHelper:print("Completed construction of " .. unit:GetUnitName() .. " " .. unit:GetEntityIndex())
        
        -- Play construction complete sound

        -- Give the unit their original attack capability
        unit:SetAttackCapability(unit.original_attack)
        checkTaoZhuang(unit)
        
    end)

    -- These callbacks will only fire when the state between below half health/above half health changes.
    -- i.e. it won't fire multiple times unnecessarily.
    event:OnBelowHalfHealth(function(unit)
        BuildingHelper:print("" .. unit:GetUnitName() .. " is below half health.")
    end)

    event:OnAboveHalfHealth(function(unit)
        BuildingHelper:print("" ..unit:GetUnitName().. " is above half health.")        
    end)
end

-- Called when the Cancel ability-item is used
function CancelBuilding( keys )
    local building = keys.unit
    local hero = building:GetOwner()
    local playerID = building:GetPlayerOwnerID()

    BuildingHelper:print("CancelBuilding "..building:GetUnitName().." "..building:GetEntityIndex())

    -- Refund here

    -- Eject builder
    local builder = building.builder_inside
    if builder then
        BuildingHelper:ShowBuilder(builder)
    end

    building.state = "canceled"
    Timers:CreateTimer(1/5, function() 
        BuildingHelper:RemoveBuilding(building, true)
    end)
end


function PlayerHasEnoughLumber( id, wood )
	if GameRules.wood[id+1]<wood then
		return false
	end
	return true
end

function PlayerHasEnoughFood( id, food )
	if GameRules.food[id+1]<food then
		return false
	end
	return true
end
function PlayerHasEnoughGold( id, gold )
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	if hero.resGold<gold then
		return false
	end
	return true
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
function ModifyWood( id,wood )
	GameRules.wood[id+1] = GameRules.wood[id+1] +wood
	local woodInfo = {}
	for i=1,4 do
		local t = {}
		t.id = i-1
		t.wood = GameRules.wood[i]
		table.insert(woodInfo ,t)
	end
	CustomNetTables:SetTableValue("wood", "WoodInfo", woodInfo)
	sendToUi(id)
end
function SendErrorMessage( pID, string )
    Notifications:ClearBottom(pID)
    Notifications:Bottom(pID, {text=string, style={color='#E62020'}, duration=2})
    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(pID))
end

function removeBuilding( event )
	local hCaster = event.caster
	local target = event.target
	if target:GetOwner()~=hCaster or not target.gold or target.gold==0 then
		SendErrorMessage(hCaster:GetPlayerOwnerID(),"notyourunit")
		return
	end
	--print(hCaster.gold)
	local gold = math.floor(target.gold*0.8)
	--hCaster:ModifyGold(gold,false, 0)
	ModifyGoldLtx( hCaster,gold )
	local pts = ParticleManager:CreateParticle(event.effectName, 
			PATTACH_CUSTOMORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
	releasePar(pts)
	EmitSoundOn("General.CoinsBig", hCaster)
	PopupGoldGain(hCaster,gold)
	local id = target:GetPlayerOwnerID()
	ModifyFood(id,target.food)
	local wood = math.floor(target.wood*8/10)
	ModifyWood(id,wood)
	BuildingHelper:RemoveBuilding(target, true)
	target:ForceKill(true)
end

function refund( event )
	local hCaster = event.caster
	local name = hCaster:GetUnitName()
	local gold = GameRules.lto4[name]
	local id = hCaster:GetPlayerOwnerID()
	local hero = PlayerResource:GetSelectedHeroEntity(id)
	if not hCaster:HasModifier("modifier_levelup_channel_cast") then
		return
	end
	--hero:ModifyGold(gold, false ,0)
	ModifyGoldLtx( hero,gold )
	hCaster:RemoveModifierByName("modifier_levelup_channel_cast")
end

function upgradeTolv4( event )
	local hCaster = event.caster
	if not hCaster:HasModifier("modifier_levelup_channel_cast") then

		return 
	end
	local _name = hCaster:GetUnitName()
	local _len = string.len(_name)
	local cutA = string.sub(_name,1,_len-1)
	local t = BuildingHelper:UpgradeBuilding(hCaster,cutA.."4")
	UpgradeParticle(t)
end

function upgradeTolv4Money( event )
	local hCaster = event.caster
	local _name = hCaster:GetUnitName()
	local ability = event.ability
	local id = hCaster:GetPlayerOwnerID()
	local gold = GetGoldByIdLtx(id)
	local oo = hCaster
	if gold < GameRules.lto4[_name] then
		Notifications:ClearBottom(id)
	    Notifications:Bottom(id, {text="#no_enough_gold", style={color='#E62020'}, duration=2})
	    Notifications:Bottom(id, {text="#need", style={color='#E62020'}, duration=2,continue=true})
	    Notifications:Bottom(id, {text=GameRules.lto4[_name], style={color='#E62020'}, duration=2,continue=true})
	    Notifications:Bottom(id, {text="#gold", style={color='#E62020'}, duration=2,continue=true})
	    EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(id))

	    local t_order = {
	    	UnitIndex = hCaster:entindex(),
			OrderType = DOTA_UNIT_ORDER_STOP
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
		return 
	end
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwnerEntity()
	end
	--hCaster:SpendGold(GameRules.lto4[_name], 0)
	ModifyGoldLtx( hCaster,-GameRules.lto4[_name] )
	ability:ApplyDataDrivenModifier(oo, oo, "modifier_levelup_channel_cast",{})
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

function uppage( event )
	local hCaster = event.caster
	local _ability1 = hCaster:GetAbilityByIndex(1)
	local _ability1_name = _ability1:GetAbilityName()
	local _length = string.len(_ability1_name)
	local _type = string.sub(_ability1_name,_length,_length)
	for i=0,10 do
		local ability = hCaster:GetAbilityByIndex(i)
		if ability then
			hCaster:RemoveAbility(ability:GetAbilityName())
		end
	end
	local id = hCaster:GetPlayerOwnerID()
	hCaster:AddAbility("uppage")
	if _type=="1" then
		for i=1,3 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i+8))
		end
		hCaster:AddAbility("common_sell")
		--hCaster:AddAbility("farmer_blink")
	elseif _type=="5" then
		for i=1,4 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i))
		end
	elseif _type == "9" then
		for i=1,4 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i+4))
		end
	end
	hCaster:AddAbility("downpage")
	
	GiveAbilityLevel(hCaster)
end

function downpage( event )
	local hCaster = event.caster
	local _ability1 = hCaster:GetAbilityByIndex(1)
	local _ability1_name = _ability1:GetAbilityName()
	local _length = string.len(_ability1_name)
	local _type = string.sub(_ability1_name,_length,_length)
	for i=0,10 do
		local ability = hCaster:GetAbilityByIndex(i)
		if ability then
			hCaster:RemoveAbility(ability:GetAbilityName())
		end
	end
	hCaster:AddAbility("uppage")
	local id = hCaster:GetPlayerOwnerID()
	if _type=="1" then
		for i=1,4 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i+4))
		end
	elseif _type=="5" then
		for i=1,3 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i+8))
		end
		hCaster:AddAbility("common_sell")
		--hCaster:AddAbility("farmer_blink")
	--[[elseif _type == "9" then
		
		if GameRules.role[id+1]=="xiaotou" then
			hCaster:AddAbility("xiaotou_baijia")
		end
		hCaster:AddAbility("seeres")]]
	else
		for i=1,4 do
			hCaster:AddAbility(GameRules.role[id+1].."_tower"..(i))
		end
	end
	hCaster:AddAbility("downpage")
	GiveAbilityLevel(hCaster)
end

function GiveAbilityLevel( hCaster )
	local id = hCaster:GetPlayerOwnerID()
	for i=0,10 do
		local ability = hCaster:GetAbilityByIndex(i)
		if ability then
			local ability_name = ability:GetAbilityName()
			local _type = getTypeOfA(ability_name)
			if _type==-1 then
				ability:SetLevel(1)
			else
				if GameRules.jinjie[id+1][tostring(_type)]>0 then
					ability:SetLevel(1)
				end
			end
		end
	end
end

function seegx( event )
	local hCaster = event.caster
	local playerID = hCaster:GetPlayerOwnerID()
	local num = 0
	if hCaster.GX~=nil then
		num = hCaster.GX
	end
	local towername = hCaster:GetUnitName()
	local namelength = tonumber(string.len(towername))
	local __type = getTypeOfA(towername)
	local __need = 0
	local ___biaoji = 0
	if __type==-1 then
		return 
	else
		local biaoji = string.sub(towername,namelength-1,namelength-1)
		if biaoji == "_" then
			local towerlevel = tonumber(string.sub(towername,namelength,namelength))
			if GameRules.sj[__type][towerlevel] then
				__need = GameRules.sj[__type][towerlevel] - num
			else
				___biaoji = 1
			end
		else
			if __type==11 then
				___biaoji = 1
			else
				__need = GameRules.sj[__type][1] - num
			end
		end
		
	end

	if __type==12 or __type==13 or __type==14 then
		local __tability = hCaster:GetAbilityByIndex(0)
		if __tability then
			local __tlevel = __tability:GetLevel()
			if __tlevel==3 then
				___biaoji = 1
			end
		end
	end
	
	Notifications:Bottom(playerID, {text="your_unit", style={color='#00FF00'}, duration=2})
	Notifications:Bottom(playerID, {text=hCaster:GetUnitName(), style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(playerID, {text="degongxunwei", style={color='#00FF00'}, duration=2,continue=true})
	Notifications:Bottom(playerID, {text=num, style={color='#E62020'}, duration=2,continue=true})
	if ___biaoji~=1 then
		Notifications:Bottom(playerID, {text="still", style={color='#00FF00'}, duration=2,continue=true})
		Notifications:Bottom(playerID, {text="need", style={color='#00FF00'}, duration=2,continue=true})
		Notifications:Bottom(playerID, {text=__need, style={color='#E62020'}, duration=2,continue=true})
		Notifications:Bottom(playerID, {text="toupgrade", style={color='#00FF00'}, duration=2,continue=true})
	end
end

function seeres( event )
	local hCaster = event.caster
	local playerID = hCaster:GetPlayerOwnerID()
	local food = GameRules.food[playerID+1]
	local wood = GameRules.wood[playerID+1]
	Notifications:Bottom(playerID, {text="youhave", style={color='#00FF00'}, duration=2})
	Notifications:Bottom(playerID, {text=food, style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(playerID, {text="food_and", style={color='#00FF00'}, duration=2,continue=true})
	Notifications:Bottom(playerID, {text=wood, style={color='#E62020'}, duration=2,continue=true})
	Notifications:Bottom(playerID, {text="wood", style={color='#00FF00'}, duration=2,continue=true})
end

function sendToUi( id )
	local hPlayer = PlayerResource:GetPlayer(id)
	CustomGameEventManager:Send_ServerToPlayer(hPlayer,"__refresh",{})
end

function sendToAllUi()
	CustomGameEventManager:Send_ServerToAllClients("__refresh", {data=GameRules.life_num})
end

function Eat(event)
	local hCaster = event.caster
	local target = event.target
	local num = 0
	if target.GX then
		num = target.GX
	end
	if target:GetOwnerEntity() == hCaster:GetOwnerEntity() and target~=hCaster then
		local pts = ParticleManager:CreateParticle(event.effectName, 
			PATTACH_CUSTOMORIGIN,target)
		ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pts, 1, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pts, 5, target:GetAbsOrigin())
		releasePar(pts)
		EmitSoundOn("aaa", hCaster)
		PopupCriticalDamage(hCaster,num)
		local pid = hCaster:GetPlayerOwnerID()
		ModifyFood(pid,target.food)
		ModifyWood(pid,target.wood*4/10)
		PopupHealing(hCaster,math.floor(target.wood*4/10))
		local hero = getAncient(hCaster)
		ModifyGoldLtx(hero,target.gold*4/10)
		PopupHealing(hCaster,math.floor(target.gold*4/10))
		BuildingHelper:RemoveBuilding(target, true)
		target:ForceKill(true)
		if not hCaster.GX then
			hCaster.GX = 0
		end
		hCaster.GX = hCaster.GX + num
		
	else
		SendErrorMessage(hCaster:GetPlayerOwnerID(),"notyourunit")
	end
end

function releasePar(pid)
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
	function()
		ParticleManager:DestroyParticle(pid,true)
	end,1)
end

function checkTaoZhuang( unit )
	local name = unit:GetUnitName()
	local id = unit:GetPlayerOwnerID()
	local __type = getTypeOfA(name)
	local __index = getIndexOfNumber(name)
	unit.suited = false
	if __index==-1 then
		return 
	end
	if __type<12 then
		return 
	end

	if __type==12 then
		unit:SetRenderColor(200, 50, 50)
	elseif __type==13 then
		unit:SetRenderColor(50, 50, 200)
	else
		unit:SetRenderColor(50, 250, 50)
	end
	local aaa = string.sub(name,1,__index)
	if aaa~=GameRules.role[id+1] then
		return 
	end
	local tb_temp = {}
	local vt = {}
	table.insert(tb_temp,unit)
	table.insert(vt,unit)
	tb_temp = DGfindSuit(tb_temp,unit,vt)
	local num = #tb_temp
	if num == 3 then
		for i=1,num do
			tb_temp[i].suited = true
			local ability_name = "taozhuang_"..GameRules.role[id+1]
			tb_temp[i]:AddAbility(ability_name)
			local __ability = tb_temp[i]:FindAbilityByName(ability_name)
			__ability:SetLevel(1)
			local pts = ParticleManager:CreateParticle(GameRules.tzp[GameRules.role[id+1]],PATTACH_ABSORIGIN, tb_temp[i])
			ParticleManager:SetParticleControl(pts, 0, tb_temp[i]:GetAbsOrigin())
			ParticleManager:SetParticleControl(pts, 1, tb_temp[(i%3)+1]:GetAbsOrigin())
		end
		local playername = PlayerResource:GetPlayerName(id)
		Notifications:TopToAll({text=playername, style={color='#FF0000'}, duration=3})
		Notifications:TopToAll({text="collectedSuit", style={color='#00FF00'}, duration=3,continue=true})
		Notifications:TopToAll({text=GameRules.role[id+1], style={color='#FF0000'}, duration=3,continue=true})
		EmitGlobalSound("game.war3_goblinshipyardwhat1")
	end
end

function DGfindSuit( tb_temp,unit,vt )
	
	local myunits = FindUnitsInRadius(unit:GetTeamNumber(), unit:GetAbsOrigin(), nil,1700,
                    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC , 0, 0, false)
	if #myunits==0 then
		return tb_temp
	end
	local id = unit:GetPlayerOwnerID()
	for i=12,14 do
		for j=1,#myunits do
			if myunits[j]:GetOwnerEntity() == unit:GetOwnerEntity() and not MyContains(vt,myunits[j]) and myunits[j].suited==false then
				local __name = myunits[j]:GetUnitName()
				local haoma = getTypeOfA(__name)
				local __haoma = getIndexOfNumber(__name)
				if haoma==i then
					local __flag = 0
					for k,v in pairs(tb_temp) do
						if v:GetUnitName()==__name then
							__flag = 1
						end
					end
					if __flag==0 and string.sub(__name,1,__haoma)==GameRules.role[id+1] then
						table.insert(tb_temp,myunits[j])
						if #tb_temp==3 then
							return tb_temp
						end
						tb_temp = DGfindSuit(tb_temp,myunits[j],vt)
					end
					table.insert(vt,myunits[j])
				end
			end
		end
	end
	return tb_temp
end

function getIndexOfNumber( str )
	for i=1,string.len(str) do
		local aa = string.sub(str,i,i)
		if aa>='0' and aa<='9' then
			return i-1
		end
	end
	return -1
end

function MyContains( myTable,myValue )
	for i,v in ipairs(myTable) do
		if v == myValue then
			return true
		end
	end
	return false
end

function gx_delete( event )
	local hCaster = event.caster
	EmitSoundOn("ability.xisheng",hCaster )
	local effectName = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pu_ti6_heal_hammers.vpcf"
	local pts = ParticleManager:CreateParticle(effectName, 
			PATTACH_WORLDORIGIN,hCaster)
	ParticleManager:SetParticleControl(pts, 0, hCaster:GetAbsOrigin())
	ParticleManager:SetParticleControl(pts, 1, Vector(255,255,255))
	releasePar(pts)
	local id = hCaster:GetPlayerOwnerID()
	ModifyFood(id,hCaster.food)
	BuildingHelper:RemoveBuilding(hCaster, true)
	hCaster:ForceKill(true)
end

function gx_xiaotou( event )
	local hCaster = event.caster
	local id = hCaster:GetPlayerOwnerID()
	local oo = hCaster
	while not hCaster:IsRealHero() do
		hCaster = hCaster:GetOwner()
	end
	local gold = hCaster.resGold
	local health = (gold % 7) + 1
	GameRules.life_num = GameRules.life_num + health
	local playerName = PlayerResource:GetPlayerName(id)
	sendToAllUi()
	Notifications:TopToAll({text=playerName, duration=3.0,style={color="white",["font-size"]="40px"}})
	Notifications:TopToAll({text="cast_heal_added", duration=3.0,style={color="green",["font-size"]="40px"},continue=true})
	Notifications:TopToAll({text=health, duration=3.0,style={color="white",["font-size"]="40px"},continue=true})
	Notifications:TopToAll({text="health", duration=3.0,style={color="green",["font-size"]="40px"},continue=true})
	gx_delete(event)
end

function gx_yemanren( event )
	local hCaster = event.caster
	local target = event.target
	local targetName = target:GetUnitName()
	local namelen = string.len(targetName)
	local flag = string.sub(targetName,namelen-1,namelen)
	local id = hCaster:GetPlayerOwnerID()
	local __type = getTypeOfA(targetName)
	if hCaster==target or hCaster:GetOwner() ~= target:GetOwner() then
		EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(id))
		Notifications:Bottom(id, {text="notyourunit", style={color='#FF0000'}, duration=2})
		return 
	end
	if __type>=12 then
		EmitSoundOnClient("General.Cancel", PlayerResource:GetPlayer(id))
		Notifications:Bottom(id, {text="cant_cast_to_tz", style={color='#FF0000'}, duration=2})
		return 
	end
	if not target.GX then
		target.GX = 0
	end

	if flag=="_3" or flag=="_4" or flag=="11" then
		--target.GX = target.GX + hCaster.GX
		ModifyGX(target,hCaster.GX)
		local effectName = "particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_pu_ti6_heal_hammers.vpcf"
		local pts = ParticleManager:CreateParticle(effectName, PATTACH_ABSORIGIN, target) 
		ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
		ParticleManager:SetParticleControl(pts, 1, Vector(255,255,255))
		releasePar(pts)
		gx_delete(event)
		return 
	end
	local preName 
	if string.sub(targetName,namelen-1,namelen-1)=="_" then
		preName = string.sub(targetName,1,namelen-1).."2"
	else
		preName = string.sub(targetName,1,namelen).."_2"
	end
	local tunit = BuildingHelper:UpgradeBuilding(target,preName)
	tunit = ModifyGX(tunit,9999)
	tunit:SetOwner(hCaster:GetOwner())
	local __ability = tunit:FindAbilityByName("upgradeTolv4")

	if __ability then
		if GameRules.jinjie[id+1]["11"]~=0 then
			__ability:SetLevel(1)
		else
			__ability:SetLevel(0)
		end
	end
	gx_delete(event)
end


function gx_mojianshi( event )
	local attacker = event.attacker
	local mana = event.mana
	attacker:GiveMana(mana)
	--PrintTable(event)
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

function ModifyJZState( id,target,opt )
    local __last = tostring(target)
    if target == 13 then
    	__last = "_4"
    end
    local hero = PlayerResource:GetSelectedHeroEntity(id)
    GameRules.jinjie[id+1][__last] = GameRules.jinjie[id+1][__last] + opt
    --print( GameRules.jinjie[id+1][__last])
    for i=0,7 do
        local ability = hero:GetAbilityByIndex(i)
        if ability then
            local ability_name = ability:GetAbilityName()
            local __type = getTypeOfA(ability_name)
            --print(__type)
            if __type == target or (target==-4 and (__type==7 or __type==8 or __type==10)) then
                --print("comein")
                if GameRules.jinjie[id+1][__last]<=0 then
                    ability:SetLevel(0)
                else
                    ability:SetLevel(1)
                end
            end
        end
    end
end

function UpgradeParticle( target )
	EmitSoundOn("Hero_Sven.StormBolt",target)
	local pts = ParticleManager:CreateParticle("particles/levelup.vpcf", 
			PATTACH_CUSTOMORIGIN,target)
	ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
end