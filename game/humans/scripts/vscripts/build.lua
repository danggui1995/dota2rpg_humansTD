require('libraries/notifications')
function SnapToGrid( size, location )
    if size % 2 ~= 0 then
        location.x = SnapToGrid32(location.x)
        location.y = SnapToGrid32(location.y)
    else
        location.x = SnapToGrid64(location.x)
        location.y = SnapToGrid64(location.y)
    end
end

function SnapToGrid64(coord)
    return 64*math.floor(0.5+coord/64)
end

function SnapToGrid32(coord)
    return 32+64*math.floor(coord/64)
end
function OnBuildStart( data )
	local hCaster = data.caster
	local ability = data.ability
	local abilityName = ability:GetAbilityName()
	local _level = ability:GetLevel() - 1
	local _index = ability:GetLevelSpecialValueFor("index", _level)
	local id = hCaster:GetPlayerOwnerID()
	local build_point = data.target_points[1]
	--网格化坐标
	--local xxx = math.floor((p.x+64)/128)+19
	--local yyy = math.floor((p.y+64)/128)+19
	build_point.x = math.floor((build_point.x)/128)*128+64
	build_point.y = math.floor((build_point.y)/128)*128+64

	--[[build_point.x = 64*math.floor(0.5+build_point.x/64)
	build_point.y = 64*math.floor(0.5+build_point.y/64)]]
	local _type = GameRules.role[id+1]

	if build_point.z<383 or build_point.z>397 then
		--print(build_point)
		return
	end
	local build_name = _type..tostring(_index)
	local colis = data.colis or 100
	local gold = ability:GetLevelSpecialValueFor("gold", _level) or 50
	if PlayerResource:GetGold(id)<gold then
		Notifications:Bottom(id,{text="nogold", duration=3.0,style={color="red",["font-size"]="40px"}})
		EmitSoundOn("warning.moregold",hCaster)
		return
	end
	local wood = ability:GetLevelSpecialValueFor("wood", _level) or 0
	if GameRules.wood[id+1]<wood then
		Notifications:Bottom(id,{text="nowood", duration=3.0,style={color="red",["font-size"]="40px"}})
		EmitSoundOn("General.CastFail_AbilityInCooldown",hCaster)
		return
	end
	local food = ability:GetLevelSpecialValueFor("food", _level) or 1
	if GameRules.food[id+1]<food then
		Notifications:Bottom(id,{text="nofood", duration=3.0,style={color="red",["font-size"]="40px"}})
		EmitSoundOn("General.CastFail_AbilityInCooldown",hCaster)
		return
	end
	local time = 10
	local targets = FindUnitsInRadius(hCaster:GetTeam(), build_point, nil,colis,
					DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL , 0, 0, false)
	local __point = GetGroundPosition(build_point,hCaster)
	--[[if __point~=build_point and
		build_point+Vector(colis/2,colis/2,0)~=GetGroundPosition(build_point+Vector(colis/2,colis/2,0),hCaster) and
		build_point+Vector(-colis/2,-colis/2,0)~=GetGroundPosition(build_point+Vector(-colis/2,-colis/2,0),hCaster) and
		build_point+Vector(colis/2,-colis/2,0)~=GetGroundPosition(build_point+Vector(colis/2,-colis/2,0),hCaster) and
		build_point+Vector(-colis/2,colis/2,0)~=GetGroundPosition(build_point+Vector(-colis/2,colis/2,0),hCaster) then
		return
	end]]
	
	if #targets==0 or (#targets==1 and targets[1]==hCaster) then
		hCaster:SpendGold(gold, 0)
		GameRules.food[id+1] = GameRules.food[id+1] - food
		GameRules.wood[id+1] = GameRules.wood[id+1] - wood
		local _unit = CreateUnitByName(build_name, build_point, true, hCaster, hCaster, hCaster:GetTeamNumber())
		build_point = GetGroundPosition(build_point,_unit)
		_unit:SetAbsOrigin(build_point)
		hCaster:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
		local unitHp = _unit:GetMaxHealth()
		local initHp = 5
		local model_scale = _unit:GetModelScale()
		local perScale = model_scale/unitHp*5
		_unit:SetHealth(initHp)
		_unit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		_unit:SetOwner(hCaster)
		_unit:SetModelScale(0.2)
		_unit:SetContextThink("build",
		function()
			if _unit:GetHealth()~=_unit:GetMaxHealth() then
				_unit:SetHealth(_unit:GetHealth()+5)
				_unit:SetModelScale(_unit:GetModelScale()+perScale)
				return 0.1
			else
				_unit:AddNewModifier(nil, nil, "modifier_phased", {duration=0.1}) 
				return nil
			end
		end, 0.2)
	end
end