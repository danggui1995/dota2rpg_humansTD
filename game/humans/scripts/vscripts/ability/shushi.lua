require('libraries/timers')
require('ability/ability_utils')
--[[
function OnLongJuanFeng( event )
	local hCaster = event.caster
	local ability = event.ability 
	local target = event.target 

	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local _order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = hCaster:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = ability:entindex()
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	end
end
]]
--[[

function OnShuangDong( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local duration_boss = event.duration_boss
	local duration = event.duration_basic
	local modifierName = event.modifierName
	if target:HasModifier("modifier_common_boss_strong") then
		duration = event.duration_boss
	end
	local damage = hCaster:GetAttackDamage()
	local damageTable = {
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
	ability:ApplyDataDrivenModifier(hCaster,target, modifierName, {duration=duration})
	
end

function OnBDPT( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local duration = event.duration
	local modifierName = event.modifierName
	local damage = hCaster:GetAttackDamage()
	local damageTable = {
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(damageTable)
	ability:ApplyDataDrivenModifier(hCaster,target, modifierName, {duration=duration})
end

]]

function ShuShiCheckAutocastPoint( event )
	local hCaster = event.caster
	local ability = event.ability 
	local target = event.target
	local point = target:GetAbsOrigin()

	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local _order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			UnitIndex = hCaster:entindex(),
			Position = point,
			AbilityIndex = ability:entindex()
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	end
end

function StartBFX( event )
	local hCaster = event.caster
	local ability = event.ability
	local point = event.target_points[1]
	local level = ability:GetLevel()-1
	local num = ability:GetLevelSpecialValueFor("num", level)
    local radius = ability:GetLevelSpecialValueFor("radius", level)
    local damage = ability:GetAbilityDamage()
    local biaoji = 1
    local vvv = 
    {
        Vector(-radius/2,radius*0.85,0),Vector(radius/2,radius*0.85,0),
        Vector(-radius,0,0),Vector(0,0,0),Vector(radius,0,0),
        Vector(-radius/2,-radius*0.85,0),Vector(radius/2,-radius*0.85,0)
    }
    hCaster:SetContextThink("bfx", 
    function()
        if not hCaster or not hCaster:IsAlive() or biaoji>num then
            return nil
        end
        biaoji = biaoji + 1
        for i=1,7 do
            local pts = ParticleManager:CreateParticle("particles/shushi/baofengxue.vpcf",
             PATTACH_CUSTOMORIGIN, hCaster)
            local __pos = vvv[i]+point
            ParticleManager:SetParticleControl(pts,0,__pos)
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("destroy"),
            function()
                ParticleManager:DestroyParticle(pts,true)
            end,1)
        end
        hCaster:SetContextThink("cause_Damage",
        function()
            if not hCaster or not hCaster:IsAlive() then
                return
            end
            local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),point , nil
            ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
            for k,v in pairs(targets) do
                local damageTable = 
                {
                    victim = v,    --受到伤害的单位
                    attacker = hCaster,          --造成伤害的单位
                    damage = damage,
                    damage_type = DAMAGE_TYPE_MAGICAL
                }
                local num = ApplyDamage(damageTable)
            end
            return nil
        end,0.4)
        EmitSoundOn("Hero_Jakiro.DualBreath",hCaster)
        return 0.7
    end, 0)
end

function ShuShiCheckAutocastNoTarget( event )
	local hCaster = event.caster
	local ability = event.ability 
	
	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local _order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			UnitIndex = hCaster:entindex(),
			AbilityIndex = ability:entindex()
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	end
end

function ShuShiCheckAutocastTarget( event )
	local hCaster = event.caster
	local ability = event.ability 
	local target = event.target
	local radius = event.radius
	local post = target:GetAbsOrigin()
	local posc = hCaster:GetAbsOrigin()

	if (posc-post):Length2D()>=radius then
		return 
	end
	if ability:IsFullyCastable() and ability:GetAutoCastState() then
		local _order =
		{
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			UnitIndex = hCaster:entindex(),
			TargetIndex = target:entindex(),
			AbilityIndex = ability:entindex()
		}
		hCaster:SetContextThink(DoUniqueString("order"), function() ExecuteOrderFromTable(_order) end, 0.1)
	end
end

function ApplyModifier( event )
	local hCaster = event.caster
	local ability = event.ability
	local modifierName = event.modifierName
	local duration = event.duration_basic
	local radius = event.radius
	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),hCaster:GetAbsOrigin() , nil
    ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,0,0,false) 

	
	for i=1,#targets do
		if not targets[i]:HasModifier(modifierName) then
			if targets[i]:HasModifier("modifier_common_boss_strong") then
				duration = event.duration_hero
			end
			ability:ApplyDataDrivenModifier(hCaster,targets[i],modifierName,{duration = duration})
			break
		end
	end
	
end

function FengHuangNiePan( event )

	-- Variables
	local caster = event.caster
	local ability = event.ability
	local casterLoc = caster:GetAbsOrigin()
	local targetLoc = event.target_points[1]
	local duration = 2
	local distance = 1800
	local radius = 900
	local collision_radius = 100
	local projectile_speed = 600
	local machines_per_sec = 14
	--local forwardVec = targetLoc - casterLoc
	local forwardVec = caster:GetForwardVector()
	local effectName = event.particleName
	forwardVec = forwardVec:Normalized()
	
	-- Find backward vector
	local backwardVec = -forwardVec
	backwardVec = backwardVec:Normalized()
	
	-- Find middle point of the spawning line
	local middlePoint = casterLoc + ( radius * backwardVec )
	
	-- Find perpendicular vector
	local v = middlePoint - casterLoc
	local dx = -v.y
	local dy = v.x
	local perpendicularVec = Vector( dx, dy, v.z )
	perpendicularVec = perpendicularVec:Normalized()
	
	-- Create dummy to store data in case of multiple instances are called
	local dummy = OnZhaoHuan( "npc_dummy_caster",caster,caster:GetAbsOrigin(),caster:GetTeamNumber(),-1 )
	dummy.march_of_the_machines_num = 0
	
	-- Create timer to spawn projectile
	Timers:CreateTimer( function()
			-- Get random location for projectile
			local random_distance = RandomInt( -radius, radius )
			local spawn_location = middlePoint + perpendicularVec * random_distance
			
			local velocityVec = Vector( forwardVec.x, forwardVec.y, 0 )
			
			-- Spawn projectiles
			local projectileTable = {
				Ability = ability,
				EffectName = effectName,
				vSpawnOrigin = spawn_location,
				fDistance = distance,
				fStartRadius = collision_radius,
				fEndRadius = collision_radius,
				Source = caster,
				bHasFrontalCone = false,
				bReplaceExisting = false,
				bProvidesVision = false,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				vVelocity = velocityVec * projectile_speed
			}
			ProjectileManager:CreateLinearProjectile( projectileTable )
			
			-- Increment the counter
			dummy.march_of_the_machines_num = dummy.march_of_the_machines_num + 1
			
			-- Check if the number of machines have been reached
			if dummy.march_of_the_machines_num == machines_per_sec * duration then
				dummy:Destroy()
				return nil
			else
				return 1 / machines_per_sec
			end
		end
	)
end

function DeathWard( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local num = 0
	if hCaster.GX then
		num = hCaster.GX
	end
	local damage = (num+10000)*5
	if hCaster:HasAbility("gxability_shushi3") then
		damage = damage * 1.5
	end

	local damageTable = {
		victim = target,
        attacker = hCaster,
        damage = damage,
        damage_type = DAMAGE_TYPE_PURE
	}
	ApplyDamage(damageTable)
end


function StartSYS( event )
	local hCaster = event.caster
	local ability = event.ability
	local forwardVec = hCaster:GetForwardVector():Normalized()
	local unitName = "npc_shushi_shuiyuansu"
	local point = hCaster:GetAbsOrigin()+forwardVec*200
	local modifierName = event.modifierName
	local duration = event.duration
	local level = ability:GetLevel()-1
	local num = ability:GetLevelSpecialValueFor("num", level) 
	for i=1,num do
		local unit = OnZhaoHuan( unitName,hCaster,point,hCaster:GetTeamNumber(),duration )
		ability:ApplyDataDrivenModifier(hCaster, unit, modifierName, {})
	end
end

function OnGxAbility( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local temp = target
	local parent = getParent(temp)
	if parent == getParent(hCaster) then
		target:GiveMana(target:GetMaxMana())
	end
end

function XXDFParticle( event )
	local hCaster = event.caster
	local ability = event.ability
	local target = event.target
	local particleName = event.particleName
	local attack = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControl(attack, 1, target:GetAbsOrigin())
	

end


function OnShuangDong( event )
	local hCaster = event.caster
	local target = event.target
	local duration_boss = event.duration_boss
	local ability = event.ability
	local modifierName = event.modifierName
	local duration_basic = event.duration_basic
	local radius = event.radius
	local point = target:GetAbsOrigin()
	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),point , nil
     ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
    for i=1,#targets do
    	if targets[i]~=target then
    		local damage = hCaster:GetAttackDamage()
			local damageTable = {
				victim = targets[i],
		        attacker = hCaster,
		        damage = damage,
		        damage_type = DAMAGE_TYPE_PHYSICAL
			}
			ApplyDamage(damageTable)
    	end
		local duration = duration_basic
		if targets[i]:HasModifier("modifier_common_boss_strong") then
			duration = duration_boss
		end
		ability:ApplyDataDrivenModifier(hCaster,targets[i], modifierName, {duration=duration})
    end
end

function OnBDPT( event )
	local hCaster = event.caster
	local target = event.target
	local duration = event.duration
	local ability = event.ability
	local modifierName = event.modifierName
	local radius = event.radius
	local point = target:GetAbsOrigin()
	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(),point , nil
     ,radius,DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,FIND_CLOSEST,false)
    for i=1,#targets do
    	if targets[i]~=target then
    		local damage = hCaster:GetAttackDamage()
			local damageTable = {
				victim = targets[i],
		        attacker = hCaster,
		        damage = damage,
		        damage_type = DAMAGE_TYPE_PHYSICAL
			}
			ApplyDamage(damageTable)
    	end
		ability:ApplyDataDrivenModifier(hCaster,targets[i], modifierName, {duration=duration})
    end
end