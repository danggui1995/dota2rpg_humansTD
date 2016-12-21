require("../libraries/buildinghelper")
require('../ability/ability_utils')
require('../utils/msg')
require('../libraries/notifications')
require('../gamemode')
function checkDiff(  )
	if GameRules.diff ~= 8 then
		return true
	end
	return false
end

function OnRandomGx( event )

	local hCaster = event.caster
	if checkDiff() then
		local playerID = hCaster:GetPlayerOwnerID()
		Notifications:Bottom(playerID, {text="#notindiff8", style={color='#E62020'}, duration=2})
		return
	end
	local target = event.target
	local particleName = event.particleName
	if not target.GX then
		target.GX = 0
	end
	local randomNum = RandomInt((GameRules.gw_lv/5)*15+10, (GameRules.gw_lv/5)*30+30)

	local result = ModifyGX(target,randomNum)
	if result then
		PopupHealing(result,randomNum)
		local pts = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN, result)
		ParticleManager:SetParticleControl(pts, 0,result:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pts)
	end
end
--[[
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
]]
--[[
function getLastIndexOf( pattern,str )
	for i=string.len(str),1,-1 do
		if string.sub(str,i,i)==pattern then
			return i
		end
	end
	return -1
end
]]--[[

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
        --[[
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
		
		UpgradeParticle(t)
		return t
	end
	
end
]]
--[[
function UpgradeParticle( target )
	EmitSoundOn("Hero_Sven.StormBolt",target)
	local pts = ParticleManager:CreateParticle("particles/levelup.vpcf", 
			PATTACH_CUSTOMORIGIN,target)
	ParticleManager:SetParticleControl(pts, 0, target:GetAbsOrigin())
end
]]
function OnMRZ( event )
	local hCaster = event.caster

	local name = "npc_dota_mojianshi_muzhuang"
	local duration = event.duration
	local point = event.target_points[1]
	onZhaoHuanGround( name,hCaster,point,hCaster:GetTeamNumber(),duration )
end

function OnXianJing( event )
	local hCaster = event.caster
	if checkDiff() then
		local playerID = hCaster:GetPlayerOwnerID()
		Notifications:Bottom(playerID, {text="#notindiff8", style={color='#E62020'}, duration=2})
		return
	end
	local point = event.target_points[1]
	local name = "npc_dota_xianjing1"
	local duration = event.duration
	local unit = onZhaoHuanGround( name,hCaster,point,DOTA_TEAM_GOODGUYS,duration )
	unit:AddNewModifier(unit, nil, "modifier_disable_turning", {})
end

function OnBomb1( event )
	local hCaster = event.caster

	local newPos = hCaster:GetAbsOrigin()
	local ability = event.ability
	local particleName = event.particleName
	if not hCaster.sum then
		hCaster.sum = 0
		hCaster.oldPos = newPos
	end
	hCaster.sum = hCaster.sum + (newPos-hCaster.oldPos):Length2D()
	hCaster.oldPos = newPos
	local forward = hCaster:GetForwardVector():Normalized()

	local t_order = 
    {                                       
        UnitIndex = hCaster:entindex(), 
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        TargetIndex = nil, 
        AbilityIndex = 0, 
        Position = hCaster:GetAbsOrigin()+forward*200,
        Queue = 0 
    }
    hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(t_order) end, 0.1)
	local units = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
    ,100,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,0,0,false)    
    if units~=nil and #units~=0 then
    	OnTrigerring(hCaster,ability,particleName)
    	hCaster:ForceKill(false)
    end
end

function OnXianJingDamage( event )
	local hCaster = event.caster
	local target = event.target
	local damage = hCaster.sum*GameRules.gw_lv
	local damageTable = 
	{
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
end

function OnTrigerring( hCaster,ability,particleName )
	local foward = hCaster:GetForwardVector()
	local x = foward.x
	local y = foward.y
	local z = foward.z
	local number = 4
	local center = hCaster:GetAbsOrigin()
	local radius = 500
	for i=1,number do
		
		local x_new = x*math.cos(math.pi*2/number*i)-y*math.sin(math.pi*2/number*i)
		local y_new = x*math.sin(math.pi*2/number*i)+y*math.cos(math.pi*2/number*i)
		local xl_new = Vector(x_new,y_new,z)

		local l_point = center+Vector(x_new*radius,y_new*radius,z)
	
		local forward_v = (l_point-center):Normalized()
	    OnLinePro(forward_v,particleName,center,hCaster,150,150,3000,ability,9000)
		
	end

end

function OnDuBo( event )
	local hCaster = event.caster
	if checkDiff() then
		local playerID = hCaster:GetPlayerOwnerID()
		Notifications:Bottom(playerID, {text="#notindiff8", style={color='#E62020'}, duration=2})
		return
	end
	local gold = hCaster.resGold
	local randomNum = RandomInt(1, 100)
	local playerID = hCaster:GetPlayerOwnerID()
	local particleName = event.particleName
	local failName = event.failName
	if randomNum>=60 then
		--hCaster:ModifyGold(gold, false, 0)
		ModifyGoldLtx( hCaster,gold )
		Notifications:Bottom(playerID, {text="#gamblingSucceed", style={color='#005500',["font-size"]="40px"}, duration=2})
		local pts = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts, 0, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pts)

	else

		--hCaster:SpendGold(gold, 0)
		ModifyGoldLtx( hCaster,-gold )
		Notifications:Bottom(playerID, {text="#gamblingFailed", style={color='#E62020',["font-size"]="40px"}, duration=2})
		local pts = ParticleManager:CreateParticle(failName, PATTACH_ABSORIGIN,hCaster)
		ParticleManager:SetParticleControl(pts, 0, hCaster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(pts)
	end
end

function OnXiaoJH( event )
	local hCaster = event.caster
	if checkDiff() then
		local playerID = hCaster:GetPlayerOwnerID()
		Notifications:Bottom(playerID, {text="#notindiff8", style={color='#E62020'}, duration=2})
		return
	end
	local ability = event.ability
	local target = event.target
	target:GiveMana(target:GetMaxMana())
end
